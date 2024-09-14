package br.com.rtakahashi.playground.flutter_reference.core.data.repository.infra

import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridge
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridgeException

/**
 * Android side of the interop repository.
 *
 * Use this class as a superclass of any repository that needs to make calls to a Flutter repository
 * or expose its methods to the Flutter side.
 *
 * An instance of this class will be able to communicate with the corresponding repository on the
 * other side, which has been instantiated with the same name.
 *
 * Most of the work this class does is simply encapsulating calls to the bridge. If that sounds like
 * it doesn't save any work, that's mostly true; this is just organizational, so that changes in
 * our bridge's API don't have to affect every concrete repository.
 */
abstract class InteropRepository(repositoryName: String) : Repository() {
    private val bridgePort = MethodChannelBridge.openPort("repository/$repositoryName")

    /**
     * Call a method on the Flutter side.
     *
     * A Flutter repository with the same name as this one must have exposed a method with the
     * same name as the one being called here.
     */
    fun call(
        methodName: String, arguments: Any? = null,
        errorCallback: ((MethodChannelBridgeException) -> Any)? = null,
        callback: ((Any?) -> Any)? = null
    ) {
        bridgePort.call(methodName, arguments, errorCallback, callback)
    }

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