package br.com.rtakahashi.playground.flutter_reference.core.bloc

import io.flutter.embedding.engine.FlutterEngine
import org.json.JSONObject

// This class needs to be initialized from somewhere that has access to the
// Flutter engine.
class CounterBlocAdapter(engine: FlutterEngine) : BaseBlocAdapter<CounterState>("counter", engine, CounterStateNumber(0)) {

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