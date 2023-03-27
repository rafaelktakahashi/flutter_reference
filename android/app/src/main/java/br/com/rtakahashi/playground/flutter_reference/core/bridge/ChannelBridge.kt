package br.com.rtakahashi.playground.flutter_reference.core.bridge

import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodChannel

/**
 * A shared method channel that can be used by multiple classes.
 */
private var sharedChannel: MethodChannel? = null

/**
 * Handlers for the Android side of the method channel bridge.
 */
private var bridgeHandlers: MutableMap<String, (Any?) -> Any?> = mutableMapOf()

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
            throw IllegalArgumentException(
                "$portName is not a valid port name;" +
                        " it must not be empty and must not contain any dots ('.') in it."
            )
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

        val newChannel = MethodChannel(
            engine.dartExecutor.binaryMessenger,
            methodChannelName, JSONMethodCodec.INSTANCE
        )

        newChannel.setMethodCallHandler { call, result ->
            // All methods that arrive here are coming from the other side of the bridge.
            // The method names there are constructed using the same rules as this side.
            // Therefore, we expect the method name to include the port name.
            // Our handlers in the bridge are kept in a map, where the keys are strings that also
            // follow that rule.
            val methodName = call.method
            val handler = bridgeHandlers[methodName]

            if (handler == null) {
                result.notImplemented()
            } else {
                try {
                    // Execute the handler and send the result back through the method channel.
                    result.success(handler.invoke(call.arguments))
                } catch (e: Exception) {
                    result.error(
                        "bridge-handler-execution-error",
                        "Android handler for method $methodName failed.",
                        e.toString(),
                    )
                }
            }
        }

        sharedChannel = newChannel
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
     * side, or if either side of the method channel hasn't finished initializing, the error
     * callback will be called receiving an exception as parameter. Otherwise, the success callback
     * will be called receiving what the Flutter method returned (may be null).
     *
     * The success callback is declared last for two reasons:
     * 1. Both callbacks are optional, but it's highly recommended to always handle the error case.
     * 2. Having the success callback declared last allows writing it outside the parentheses when
     * calling this method.
     *
     * The return type of the callbacks does not matter. They're given as "Any" to allow for not
     * returning anything.
     */
    fun call(
        methodName: String,
        arguments: Any? = null,
        errorCallback: ((MethodChannelBridgeException) -> Any)? = null,
        callback: ((Any?) -> Any)? = null
    )

    /**
     * Register a handler for a name. If a different handler was already registered for the same
     * name, it'll be discarded in favor of this one.
     *
     * Note that this does not directly register a handler in the method channel. This handler is
     * stored on the bridge, and when some message comes through the method channel, the bridge
     * routes it to the correct handler.
     */
    fun registerHandler(callbackName: String, handler: (Any?) -> Any?)

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
private class AndroidMethodChannelBridgePortImpl(val name: String) :
    AndroidMethodChannelBridgePort {

    // I originally intended this to be a suspend function, but that didn't work with the method
    // channel for some reason I can't explain (the result callbacks were never called).
    // It's possible to use some library like RxKotlin here to simplify the callbacks, but I wanted
    // to avoid dependencies in this part of the project.
    override fun call(
        methodName: String,
        arguments: Any?,
        errorCallback: ((MethodChannelBridgeException) -> Any)?,
        callback: ((Any?) -> Any)?
    ) {
        // This is just to enable a smart cast.
        val channel = sharedChannel

        // This is the part I tried to do with a suspendCoroutine, but I couldn't get it to work.
        // For some reason the callbacks would never get called.
        if (channel != null) {
            channel.invokeMethod("$name.$methodName", arguments, object : MethodChannel.Result {
                override fun success(result: Any?) {
                    callback?.invoke(result)
                }

                override fun notImplemented() {
                    errorCallback?.invoke(MethodChannelBridgeException.receiverNotFound())
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    errorCallback?.invoke(MethodChannelBridgeException.methodExecutionFailed())
                }
            })
        } else {
            errorCallback?.invoke(MethodChannelBridgeException.bridgeNotInitialized())
        }
    }

    override fun registerHandler(callbackName: String, handler: (Any?) -> Any?) {
        if (bridgeHandlers["$name.$callbackName"] !== null) {
            Log.d(
                "bridge",
                "Method $callbackName for port $name has already been registered in the bridge!"
            )
            Log.d("bridge", "Previous handler for $name.$callbackName will be discarded.")
        }

        bridgeHandlers["$name.$callbackName"] = handler
    }

    override fun unregisterHandler(callbackName: String) {
        bridgeHandlers.remove(callbackName)
    }

    override fun unregisterAllHandlers() {
        bridgeHandlers =
            bridgeHandlers.filter { entry -> entry.key.startsWith("$name.") }.toMutableMap()
    }

}

/**
 * Custom exception that may be thrown when calling methods on the Flutter side.
 */
class MethodChannelBridgeException private constructor(val reason: MethodChannelBridgeExceptionCause) :
    Exception() {

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
