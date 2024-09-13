package br.com.rtakahashi.playground.flutter_reference.core.data.service.infra

import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridge
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridgeException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

/**
 * Check the InteropRepository.kt file for a better explanation. This is the same thing, but
 * for services.
 */
abstract class InteropService(serviceName: String) {
    private val bridgePort = MethodChannelBridge.openPort("service/$serviceName")

    /**
     * Call a method on the Flutter side.
     *
     * A Flutter service with the same name as this one must have exposed a method with the
     * same name as the one being called here.
     */
    fun call(
        methodName: String, arguments: Any? = null,
        errorCallback: ((MethodChannelBridgeException) -> Any)? = null,
        callback: ((Any?) -> Any)? = null
    ) {
        // I think it should be possible to expose this function as suspend with a suspendCoroutine,
        // but I haven't been able to make it work. I believe coroutines don't work well because
        // the method channel does something with the main thread.
        bridgePort.call(methodName, arguments, errorCallback, callback)
    }

    suspend fun callSuspend(methodName: String, arguments: Any? = null): Any? {
        return suspendCoroutine { continuation ->
            runBlocking(Dispatchers.Main) {
                // Replace the runBlocking with something else. But first check if it works.
                call(methodName, arguments, {
                    error -> continuation.resumeWithException(error)
                }) {
                    result -> continuation.resume(result)
                }
            }
        }
    }

    /**
     * Method to be called by concrete implementations to expose a method to be used on the other
     * side of the bridge. Anything returned should be serializable. That means primitive types,
     * strings and collections are fine, but send maps instead of objects.
     */
    fun exposeMethod(methodName: String, handler: suspend (Any?) -> Any?) {
        bridgePort.registerHandlerSuspend(methodName, handler)
    }
}