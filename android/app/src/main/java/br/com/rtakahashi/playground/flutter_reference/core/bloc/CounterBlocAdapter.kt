package br.com.rtakahashi.playground.flutter_reference.core.bloc

import io.flutter.embedding.engine.FlutterEngine
import org.json.JSONObject

/**
 * Example of a bloc adapter that uses the method channel to access a Flutter bloc.
 *
 * Even though the superclass uses the method channel, we don't need to initialize the channel
 * itself here because that's handled by our method channel bridge.
 */
class CounterBlocAdapter() : BaseBlocAdapter<CounterState>("counter", CounterStateNumber(0)) {

    fun incrementBy(step: Int) {
        super.send(mapOf("type" to "INCREMENT", "step" to step));
    }

    fun multiplyBy(factor: Int) {
        super.send(mapOf("type" to "MULTIPLY", "factor" to factor));
    }

    fun reset() {
        super.send(mapOf("type" to "RESET"));
    }

    override fun messageToState(message: JSONObject): CounterState {
        return when (message["type"]) {
            "NUMBER" -> CounterStateNumber(message["value"] as Int);
            "ERROR" -> CounterStateError(message["errorMessage"] as String);
            else -> CounterStateError("UNEXPECTED MESSAGE $message")
        }
    }
}

abstract class CounterState;
class CounterStateNumber(val value: Int) : CounterState();
class CounterStateError(val errorMessage: String): CounterState();