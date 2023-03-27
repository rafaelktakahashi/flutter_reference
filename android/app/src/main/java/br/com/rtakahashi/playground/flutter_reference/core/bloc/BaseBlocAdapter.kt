package br.com.rtakahashi.playground.flutter_reference.core.bloc

import android.util.Log
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridge
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridgeException
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridgeExceptionCause
import org.json.JSONObject
import java.util.*

/**
 * Offers communication to a bloc that exists in Dart code.
 * The blocName parameter must correspond to an InteropBloc that has the same name.
 *
 * The initial state is not very important, because this base class attempts to get the bloc's
 * current state right away during initialization.
 */
abstract class BaseBlocAdapter<S>(private val blocName: String, initialState: S) {
    private var bridgePort = MethodChannelBridge.openPort("bloc/$blocName")

    private var _updateStateCallbackName: String? = null

    private val _listeners: MutableMap<String, (S) -> Unit> = mutableMapOf()

    // This is to send the most recent state immediately after someone subscribes to this adapter.
    private var _cachedState: S = initialState

    /**
     * In this method we subscribe to the bloc to receive state updates.
     * The bloc (in Flutter) doesn't send state updates by default, because if it did, it would
     * waste messages when the native side isn't listening. A Flutter bloc can exist without an
     * adapter on the native side, and in that case it doesn't need to notify anything when its
     * state changes.
     *
     * Setting up the callback can't be done immediately when the bloc adapter is instantiated,
     * because we must be sure that the corresponding Flutter bloc exists. If it doesn't, then
     * the registerCallback call will fail and this class won't be notified of changes.
     */
    private fun setUpCallback() {
        // If this variable has a value, then we've already set up the callback and don't need
        // to do it again.
        if (_updateStateCallbackName != null) return

        // The callback method can be anything. I'm appending a random part to avoid collisions.
        // Collisions are theoretically impossible because only one instance of each bloc adapter
        // should exist at any given time. If you need multiple adapters for the same bloc, you'll
        // need to make further modifications to the code.
        _updateStateCallbackName = "updateState-${UUID.randomUUID()}"

        // We could use the method channel directly, but here we're using our bridge which
        // centralizes all method channel logic.
        bridgePort.call(
            "registerCallback", _updateStateCallbackName,
            {
                Log.d("BaseBlocAdapter", "Failed to register callback for bloc $blocName: $it")
            },
        )
        bridgePort.registerHandler(_updateStateCallbackName!!) { updateState(it) }

        // Attempt to sync the value here with the value from Flutter right away.
        // If this fails, this instance will continue to use the initial state provided
        // by the subclass, but we don't expect that to happen.
        syncCurrentStateFromFlutter()

        // If kotlin had destructors, we would call "unregisterCallback" in it.
        // Currently, we expect every bloc adapter to live forever. Whatever dependency-injection
        // library you use should make sure that


    }

    // Technically, we can send anything as parameters through the method channel, but if we send
    // some Java object it actually just calls its toString(), which is kinda useless.
    // It's easier to require maps instead. Those always get turned into JSONs as expected.
    protected fun send(data: Map<String, Any>) {
        bridgePort.call(
            "sendEvent",
            data,
            { Log.d("BaseBlocAdapter", "Failed to send message: $data, error: $it") },
        )
    }

    private fun syncCurrentStateFromFlutter() {
        try {
            bridgePort.call(
                "getCurrentState",
                null,
                {
                    Log.d(
                        "BaseBlocAdapter",
                        "Adapter $blocName failed to get current state. Continuing with initial state. Error: $it"
                    )
                }) {
                updateState(it)
            }
        } catch (ex: MethodChannelBridgeException) {
            if (MethodChannelBridgeExceptionCause.RECEIVER_NOT_FOUND == ex.reason) {
                // If this fails because the equivalent method doesn't exist in Flutter,
                // then that's an error.
                throw NotImplementedError("Could not get current state.")
            }
            // Probably fine to ignore. This adapter will continue using the default state
            // provided by the subclass.
            Log.d("BaseBlocAdapter", "Failed to get current state from $blocName bloc.")
        }
    }

    /**
     * Get the current state. This is guaranteed to be the latest data received from the Flutter
     * bloc. It will be the initial state if nothing has been received yet, but that is never
     * expected.
     */
    fun currentState(): S {
        return _cachedState
    }

    /**
     * Convert a message received from Flutter into an instance of the bloc's state.
     * The parameter will be a json object whose fields are created in the Flutter bloc's
     * stateToMessage method.
     */
    protected abstract fun messageToState(message: JSONObject): S

    private fun updateState(data: Any?) {
        if (data == null) {
            // We can never set a null state, so check for that.
            Log.d("BaseBlocAdapter", "Skipping updateState because it received null.")
        }

        val state = messageToState(data as JSONObject)
        _cachedState = state
        for (listener in _listeners) {
            listener.value(state)
        }
    }

    /**
     * Register to listen to the stream of the corresponding bloc.
     * This function will return a handle which must be used to
     * unregister the callback when it's no longer needed.
     *
     * Note that the exact mechanism of this *observable* doesn't matter;
     * if you use something else for your observables, then you should use
     * that instead. This project is a minimal example without any libraries.
     */
    fun listen(callback: (value: S) -> Unit): String {
        // Setting up the callback here ensures that we do so late enough that the Flutter bloc
        // exists and is listening to the channel. This makes it so the Flutter bloc will only
        // start sending state updates once someone on the native side is listening.
        setUpCallback()

        val handle = UUID.randomUUID().toString()
        _listeners[handle] = callback
        // Additionally, send the state immediately to this callback.
        // This ensures that everyone will have a useful state right away without needing to
        // render an empty screen.
        callback(_cachedState)

        return handle
    }

    fun clearListener(handle: String) {
        _listeners.remove(handle)
    }
}