package br.com.rtakahashi.playground.flutter_reference.core.data.service.infra

import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridge
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridgeException

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

    /**
     * Method to be called by concrete implementations to expose a method to be used on the other
     * side of the bridge. Anything returned should be serializable. That means primitive types,
     * strings and collections are fine, but send maps instead of objects.
     */
    fun exposeMethod(methodName: String, handler: suspend (Any?) -> Any?) {
        bridgePort.registerHandlerSuspend(methodName, handler)
    }
}