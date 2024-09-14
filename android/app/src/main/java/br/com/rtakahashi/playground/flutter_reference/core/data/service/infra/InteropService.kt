package br.com.rtakahashi.playground.flutter_reference.core.data.service.infra

import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridge
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridgeException

/**
 * Check the InteropRepository.kt file for a better explanation. This is the same thing, but
 * for services.
 * (It would be probably better to abstract the common code into a separate class. I feel that that
 * would complicate things a bit too much for a demo.)
 */
abstract class InteropService(serviceName: String) {
    private val bridgePort = MethodChannelBridge.openPort("service/$serviceName")


    fun call(
        methodName: String, arguments: Any? = null,
        errorCallback: ((MethodChannelBridgeException) -> Any)? = null,
        callback: ((Any?) -> Any)? = null
    ) {
        bridgePort.call(methodName, arguments, errorCallback, callback)
    }

    /**
     * Call a method on the Flutter side.
     *
     * A Flutter service with the same name as this one must have exposed a method with the
     * same name as the one being called here.
     */
    suspend fun call(methodName: String, arguments: Any? = null): Any? {
        return bridgePort.call(methodName, arguments);
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