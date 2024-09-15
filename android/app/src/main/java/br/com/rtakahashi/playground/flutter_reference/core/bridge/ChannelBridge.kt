package br.com.rtakahashi.playground.flutter_reference.core.bridge

import android.util.Log
import br.com.rtakahashi.playground.flutter_reference.core.domain.error.InteropException
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

typealias SimpleBridgeHandlerFunction = (parameters: Any?) -> Any?
typealias NonblockingBridgeHandlerFunction = (parameters: Any?, fulfill: (Any?) -> Unit, reject: (Any?) -> Unit) -> Unit
typealias SuspendBridgeHandlerFunction = suspend (parameters: Any?) -> Any?

/**
 * We allow for different types of handlers to be registered in the bridge.
 * Each one needs to be called in a different way.
 */
private sealed interface BridgeHandler

/**
 * The simplest type of handler to write and call, but also blocks the thread
 * when it runs.
 */
private data class SimpleBridgeHandler(
    val f: SimpleBridgeHandlerFunction
) : BridgeHandler

/**
 * A non-blocking callback-based handler that may be harder to use but doesn't
 * block the thread when it runs.
 */
private data class NonblockingBridgeHandler(
    val f: NonblockingBridgeHandlerFunction
) : BridgeHandler

/**
 * A suspend handler that's the recommended way of registering handlers.
 * It's easy to use and doesn't require manually writing any callbacks,
 * but the other options are provided in case it causes concurrency problems.
 */
private data class SuspendBridgeHandler(
    val f: SuspendBridgeHandlerFunction
) : BridgeHandler

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
 * - Calls and responses are exposed through simple callbacks that are easier to use than the
 * method channel.
 *
 * ```kotlin
 * val weatherPort = MethodChannelBridge.openPort("WeatherRepository");
 *
 * // Send a call to the Flutter side and get its response:
 * val forecast = weatherPort.call("fetchWeatherForecast", args, { logError(it) } ) { handleResponse(it) };
 * // or register to receive calls from the Flutter side:
 * weatherPort.registerHandlerSuspend("fetchWeatherForecast") suspend { params -> handleCall(params) };
 *
 * // if you have concurrency problems, you can use the other functions as well:
 * weatherPort.registerHandlerBlocking("fetchWeatherForecast") { params -> handleCall(params) };
 * weatherPort.registerHandlerPromise("fetchWeatherForecast") { params, fulfill, reject ->
 *  ...
 *  fulfill(value)
 * };
 * ```
 */
object MethodChannelBridge {
    // The functions in this object could've been top-level functions and they would work the same;
    // I decided to put them in an object to make their usage more explicit about that they are.
    // That is, you call them with MethodChannelBridge.initialize() rather than just calling
    // the function.

    /**
     * A static method channel that's shared by all ports in the bridge.
     */
    private var sharedChannel: MethodChannel? = null

    /**
     * Handlers for the Android side of the method channel bridge.
     */
    private var bridgeHandlers: MutableMap<String, BridgeHandler> = mutableMapOf()

    /**
     * This exact string must also be used in the Flutter side of the bridge.
     */
    private const val methodChannelName = "br.com.rtakahashi.playground.flutter_reference"

    /**
     * Open a port to the Flutter side.
     *
     * Anything from navigation to repositories can use a port.
     *
     * "Open" might not be accurate because a port simply works as a prefix when sending and
     * receiving messages through the method channel. Many classes may "open" the same method
     * channel port and they'll all be able to use it, but you should avoid that because only one
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
            // All calls that arrive here are coming from the other side of the bridge.
            // The method names there are constructed using the same rules as this side.
            // Therefore, we expect the method name to include the port name.
            // Our handlers in the bridge are kept in a map, where the keys are strings that also
            // follow that rule.
            val methodName = call.method

            when (val handler = bridgeHandlers[methodName]) {
                null -> result.notImplemented()
                is SimpleBridgeHandler -> {
                    // A simple bridge handler is one that was registered as a simple function
                    // of Any? to Any?, and it blocks the thread while it runs.
                    try {
                        // Execute the handler and send the result back through the method channel.
                        result.success(handler.f.invoke(call.arguments))
                    } catch (e: Exception) {
                        errorWithException(result, e)
                    }
                }

                is NonblockingBridgeHandler -> {
                    // A non-blocking handler is one that receives the parameters and also a fulfill
                    // and a reject callback, and it's expected to call one of them.
                    handler.f.invoke(call.arguments, {
                        result.success(it)
                    }, {
                        errorWithException(result, it)
                    })
                }

                is SuspendBridgeHandler -> {
                    // A suspend handler needs to execute in the global scope.
                    GlobalScope.launch {
                        try {
                            val res = handler.f.invoke(call.arguments)
                            result.success(res)
                        } catch (e: Exception) {
                            errorWithException(result, e)
                        }
                    }
                }
            }

        }

        sharedChannel = newChannel
    }

    // Call the method channel's result with the information contained in the exception.
    private fun errorWithException(methodChannelResult: MethodChannel.Result, e: Any?) {
        if (e is InteropException) {
            // In this case, we have additional information to send.
            methodChannelResult.error(
                e.errorCode,
                e.message,
                e.extra
            );
        } else if (e is Exception) {
            methodChannelResult.error(
                "bridge-handler-execution-error",
                "Android handler has failed with exception: $e",
                e.toString(),
            );
        } else {
            methodChannelResult.error(
                "bridge-handler-execution-error",
                "Android handler has failed with unknown error: $e",
                e?.toString(),
            );
        }
    }


    // (This is a private class that implements AndroidMethodChannelBridgePort in order to prevent
    // it from being instantiated elsewhere. See the interface for how to use a port.)
    private class AndroidMethodChannelBridgePortImpl(val name: String) :
        AndroidMethodChannelBridgePort {

        override fun call(
            methodName: String,
            arguments: Any?,
            errorCallback: ((MethodChannelBridgeException) -> Any)?,
            callback: ((Any?) -> Any)?
        ) {
            // This variable is just to enable a smart cast.
            val channel = sharedChannel

            if (channel != null) {
                channel.invokeMethod("$name.$methodName", arguments, object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        callback?.invoke(result)
                    }

                    override fun notImplemented() {
                        errorCallback?.invoke(MethodChannelBridgeException.receiverNotFound())
                    }

                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                        errorCallback?.invoke(MethodChannelBridgeException.methodExecutionFailed())
                    }
                })
            } else {
                errorCallback?.invoke(MethodChannelBridgeException.bridgeNotInitialized())
            }
        }

        override suspend fun call(methodName: String, arguments: Any?): Any? {
            // When calling the method channel from Kotlin, it's important to do so from the
            // main thread, otherwise the call simply will never complete (the callbacks will never
            // be called).
            // Simply making this a coroutine with `suspendCoroutine` would not ensure that the
            // call happens in the method channel, so the call to `withContext` around it is needed.
            return withContext(Dispatchers.Main) {
                suspendCoroutine { continuation ->
                    call(methodName, arguments, { error ->
                        continuation.resumeWithException(error)
                    }, { result ->
                        continuation.resume(result)
                    })
                }
            }
        }

        override fun registerHandlerBlocking(
            callbackName: String,
            handler: (SimpleBridgeHandlerFunction)
        ) {
            _registerHandler(callbackName, SimpleBridgeHandler(handler))
        }

        override fun registerHandlerPromise(
            callbackName: String,
            handler: NonblockingBridgeHandlerFunction
        ) {
            _registerHandler(callbackName, NonblockingBridgeHandler(handler))
        }

        override fun registerHandlerSuspend(
            callbackName: String,
            handler: SuspendBridgeHandlerFunction
        ) {
            _registerHandler(callbackName, SuspendBridgeHandler(handler))
        }

        private fun _registerHandler(callbackName: String, handler: BridgeHandler) {
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
}


/**
 * Represents a port in our method channel bridge that can communicate with the Flutter side.
 *
 * A port can be used to send data to the Flutter side, and also register methods that the Flutter
 * side can call. Both a callback-based and a suspend version of the `call` method are provided,
 * so that callers can choose to use straightforward try/catches with suspend functions and use
 * callbacks from non-suspend functions if necessary.
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
     * side, or if either side of the method channel bridge hasn't finished initializing, the error
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
     * Send something through the shared channel.
     *
     * This works the same as the callback-based overload, except that it's a suspend function.
     */
    suspend fun call(methodName: String, arguments: Any? = null): Any?

    /**
     * Register a handler for a name. If a different handler was already registered for the same
     * name, it'll be discarded in favor of this one.
     *
     * Note that this does not directly register a handler in the method channel. This handler is
     * stored on the bridge, and when some message comes through the method channel, the bridge
     * routes it to the correct handler.
     *
     * It is always recommended to call `registerHandlerSuspend()`, which accepts a suspend function.
     * This function registers a BLOCKING handler that must not be used if you intend to make api
     * calls or other asynchronous operation.
     *
     * Handlers are allowed to throw, but avoid that because anything that's thrown gets turned
     * into an error that's send to the Flutter side of the bridge.
     *
     * Usage:
     * ```kotlin
     * bridgePort.registerHandlerBlocking("name") { params ->
     *   ...
     *   return someValue
     *   // Or throw when there's an error.
     * }
     * ```
     */
    fun registerHandlerBlocking(callbackName: String, handler: SimpleBridgeHandlerFunction)

    /**
     * Register a handler for a name. If a different handler was already registered for the same
     * name, it'll be discarded in favor of this one.
     *
     * Note that this does not directly register a handler in the method channel. This handler is
     * stored on the bridge, and when some message comes through the method channel, the bridge
     * routes it to the correct handler.
     *
     * This is a non-blocking method that may be more difficult to use, but unlike the
     * `registerHandlerBlocking()` function, it doesn't block the thread. However, do consider
     * using `registerHandlerSuspend()` instead of this.
     *
     * The first parameter of the handler is for the parameters received from Flutter. The second
     * and third parameters are the fulfill and reject functions, respectively; exactly one of the
     * two must be called eventually, and only once, with the value to be returned to the Flutter
     * side. It's important to fulfill with null even if you don't return anything from the handler,
     * so that the Flutter side doesn't wait for a response indefinitely.
     *
     * Usage:
     * ```kotlin
     * bridgePort.registerHandlerPromise("name") { params, fulfill, reject ->
     *   ...
     *   fulfill(someValue)
     *   // Call either fulfill or reject, only once.
     * }
     * ```
     */
    fun registerHandlerPromise(
        callbackName: String,
        handler: NonblockingBridgeHandlerFunction
    )

    /**
     * Register a handler for a name. If a different handler was already registered for the same
     * name, it'll be discarded in favor of this one.
     *
     * Note that this does not directly register a handler in the method channel. This handler is
     * stored on the bridge, and when some message comes through the method channel, the bridge
     * routes it to the correct handler.
     *
     * There are other versions of this function that you can use if you encounter concurrency
     * problems. However, this is the recommended way of registering handlers in the bridge.
     *
     * Handlers are allowed to throw, but avoid that because anything that's thrown gets turned
     * into an error that's send to the Flutter side of the bridge.
     *
     * Usage:
     * ```kotlin
     * bridgePort.registerHandlerSuspend("name") { params ->
     *   ...
     *   return someValue
     *   // Or throw when there's an error.
     * }
     * ```
     */
    fun registerHandlerSuspend(
        callbackName: String,
        handler: SuspendBridgeHandlerFunction
    )

    /**
     * Unregister a handler by name.
     */
    fun unregisterHandler(callbackName: String)

    /**
     * Unregister all handlers for this port.
     */
    fun unregisterAllHandlers()
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
