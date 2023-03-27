package br.com.rtakahashi.playground.flutter_reference.core.bridge

import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodChannel
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

/**
 * A shared method channel that can be used by multiple classes.
 */
private var sharedChannel: MethodChannel? = null

/**
 * Handlers for the Android side of the method channel bridge.
 */
private var bridgeHandlers: MutableMap<String, suspend (Any?) -> Any?> = mutableMapOf()

/**
 * This exact string must also be used in the Flutter side of the bridge.
 */
private const val methodChannelName = "br.com.rtakahashi.playground.flutter_reference"


/**
 * Android side of the method channel bridge.
 *
 * Use this bridge to communicate with Flutter code instead of directly opening method channels.
 * To use it, open a port with a name.
 *
 * After having obtained a port, you can use it just like you would use the method channel, with a
 * few differences:
 * - Handlers are registered one by one, by method name. You shouldn't register a method name that
 * has been registered before on the same port. If you do, the previous handler will be discarded
 * and that may lead to bugs.
 * - Port names work like prefixes, but you don't have to worry about constructing the names of
 * methods.
 * - Everything is exposed through easy-to-use suspend methods.
 *
 * ```kotlin
 * val weatherPort = AndroidMethodChannelBridge.openPort("WeatherRepository");
 *
 * // Send a call to the Flutter side and get its response:
 * val forecast = await weatherPort.call("fetchWeatherForecast");
 * // or register to receive calls from the Flutter side:
 * weatherPort.registerHandler("fetchWeatherForecast", suspend { ... } );
 * ```
 */
object MethodChannelBridge {
    // The functions in this object could've been top-level functions and they would work the same;
    // I decided to put them in an object to make their usage more explicit about that they are.
    // That is, you call them with AndroidMethodChannelBridge.initialize() rather than just calling
    // the function.

    /**
     * Open a port to the Flutter side.
     *
     * Anything from navigation to repositories can use a port.
     *
     * "Open" might not be accurate because a port simply works as a prefix when sending and
     * receiving messages through the method channel. Many classes may "open" the same method
     * channel port and they'll both be able to use it, but you should avoid that because only one
     * handler can be registered for each name in the same port.
     */
    @JvmStatic
    fun openPort(portName: String): AndroidMethodChannelBridgePort {
        // It is better to "open" method channels using a method rather than letting other
        // classes directly instantiate ports because we may want to add some more control
        // here in the future.
        if (portName.isEmpty() || portName.contains('.')) {
            throw IllegalArgumentException("$portName is not a valid port name;" +
                    " it must not be empty and must not contain any dots ('.') in it.")
        }
        return AndroidMethodChannelBridgePortImpl(portName)
    }


    /**
     * Initialize this side of the bridge. This function MUST be called at least once, informing
     * the Flutter engine. The bridge can be used to make calls to the Flutter side only after
     * initialization.
     *
     * It is possible to register handlers before initialization, but method calls from the
     * Flutter side will only reach this side of the bridge after initialization.
     */
    @JvmStatic
    fun initialize(engine: FlutterEngine) {
        if (sharedChannel !== null) {
            // Method channel already initialized. Skipping.
            return
        }

        sharedChannel = MethodChannel(engine.dartExecutor.binaryMessenger,
                methodChannelName, JSONMethodCodec.INSTANCE)
    }
}


/**
 * Represents a port in our method channel bridge that can communicate with the Flutter side.
 *
 * A port can be used to send data to the Flutter side, and also register methods that the Flutter
 * side can call.
 *
 * You can think of each port as only being able to communicate with the corresponding port (with
 * the same name) on the other side.
 */
interface AndroidMethodChannelBridgePort {
    /**
     * Send something through the shared channel.
     *
     * There must be a port on the Flutter side with the same name as this port with a registered
     * handler with the method name specified as [methodName].
     *
     * If a corresponding port with a corresponding method handler doesn't exist in the Flutter
     * side, or if either side of the method channel hasn't finished initializing, an
     * AndroidMethodChannelBridgeException will be thrown.
     */
    suspend fun call(methodName: String, arguments: Any? = null): Any?

    fun debugCall(methodName: String, arguments: Any? = null, callback: ((Any?) -> Any?)? = null)

    /**
     * Register a handler for a name. If a different handler was already registered for the same
     * name, it'll be discarded in favor of this one.
     */
    fun registerHandler(callbackName: String, handler: suspend (Any?) -> Any?)

    /**
     * Unregister a handler by name.
     */
    fun unregisterHandler(callbackName: String)

    /**
     * Unregister all handlers for this port.
     */
    fun unregisterAllHandlers()
}

// (This is a private class that implements AndroidMethodChannelBridgePort in order to prevent
// it from being instantiated elsewhere.)
private class AndroidMethodChannelBridgePortImpl (val name: String) : AndroidMethodChannelBridgePort {
    override suspend fun call(methodName: String, arguments: Any?): Any? = suspendCoroutine { cont ->

        // This doesn't work either.
        debugCall(methodName, arguments) {
            cont.resume(it)
        }

        // This is just to enable a smart cast.
//        val channel = sharedChannel
//
//        if (channel != null) {
//            channel.invokeMethod("$name.$methodName", arguments, object : MethodChannel.Result {
//                override fun success(result: Any?) {
//                    Log.d("a", "a")
//                    cont.resume(result)
//                }
//
//                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
//                    Log.d("a", "a")
//                    cont.resumeWithException(MethodChannelBridgeException.methodExecutionFailed())
//                }
//
//                override fun notImplemented() {
//                    Log.d("a", "a")
//                    cont.resumeWithException(MethodChannelBridgeException.receiverNotFound())
//                }
//            })
//        } else {
//            cont.resumeWithException(MethodChannelBridgeException.bridgeNotInitialized());
//        }
    }

    // Testing. The method channel on the Kotlin side is not receiving anything back when using
    // coroutines.
    // This seems to work, without using coroutines. Callbacks aren't that hard to implement anyway.
    // I originally planned to use coroutines for this, but callbacks will do just fine.
    override fun debugCall(methodName: String, arguments: Any?, callback: ((Any?) -> Any?)?) {
        val channel = sharedChannel

        if (channel != null) {
            channel.invokeMethod("$name.$methodName", arguments, object : MethodChannel.Result {
                override fun success(result: Any?) {
                    callback?.invoke(result);
                }

                override fun notImplemented() {
                    TODO("Not yet implemented")
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    TODO("Not yet implemented")
                }
            })
        }
    }

    override fun registerHandler(callbackName: String, handler: suspend (Any?) -> Any?) {
        if (bridgeHandlers["$name.$callbackName"] !== null) {
            Log.d("bridge", "Method $callbackName for port $name has already been registered in the bridge!")
            Log.d("bridge", "Previous handler for $name.$callbackName will be discarded.")
        }

        bridgeHandlers["$name.$callbackName"] = handler
    }

    override fun unregisterHandler(callbackName: String) {
        bridgeHandlers.remove(callbackName)
    }

    override fun unregisterAllHandlers() {
        bridgeHandlers = bridgeHandlers.filter { entry -> entry.key.startsWith("$name.") }.toMutableMap()
    }

}

/**
 * Custom exception that may be thrown when calling methods on the Flutter side.
 */
class MethodChannelBridgeException private constructor(val reason: MethodChannelBridgeExceptionCause) : Exception() {

    companion object {
        @JvmStatic
        fun receiverNotFound(): MethodChannelBridgeException {
            return MethodChannelBridgeException(MethodChannelBridgeExceptionCause.RECEIVER_NOT_FOUND)
        }

        @JvmStatic
        fun bridgeNotInitialized(): MethodChannelBridgeException {
            return MethodChannelBridgeException(MethodChannelBridgeExceptionCause.BRIDGE_NOT_INITIALIZED)
        }

        @JvmStatic
        fun methodExecutionFailed(): MethodChannelBridgeException {
            return MethodChannelBridgeException(MethodChannelBridgeExceptionCause.METHOD_EXECUTION_FAILED)
        }
    }
}

enum class MethodChannelBridgeExceptionCause {
    /**
     * Means that the called method was not found on the Flutter side. This may be because
     * the bridge has not been initialized on the Flutter side.
     */
    RECEIVER_NOT_FOUND,

    /**
     * Means that the method channel bridge has not been initialized yet, and thus cannot be
     * used. You must call the `initializeBridge` method before calling methods on the Flutter
     * side. Although you can register callbacks before the bridge is initialized, code in the
     * Flutter side won't be able to reach those callbacks until initialization.
     */
    BRIDGE_NOT_INITIALIZED,

    /**
     * Means that the call to the Flutter side was made but the Flutter code threw an error.
     */
    METHOD_EXECUTION_FAILED;
}
