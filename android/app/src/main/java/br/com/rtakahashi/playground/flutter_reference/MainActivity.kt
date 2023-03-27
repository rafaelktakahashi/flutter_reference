package br.com.rtakahashi.playground.flutter_reference

import android.content.Intent
import br.com.rtakahashi.playground.flutter_reference.core.bloc.CounterBlocAdapter
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridge
import br.com.rtakahashi.playground.flutter_reference.core.injection.Injector
import br.com.rtakahashi.playground.flutter_reference.core.view.CounterActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // TODO: Refactor this to use the channel bridge.
    private val CHANNEL_NAVIGATOR = "br.com.rtakahashi.playground.flutter_reference/navigator";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAVIGATOR).setMethodCallHandler {
            call, result ->
            run {
                when (call.method) {
                    "navigate" -> navigateToPage() // Not reading arguments yet.
                    else -> result.notImplemented()
                }
            }
        }

        // Our method channel bridge needs to be initialized here, where we have a reference to
        // the Flutter engine.
        // Centralizing all method channel logic in the bridge frees everything else from needing
        // a reference to the Flutter engine to use the channel. Any class that needs to communicate
        // with Flutter code should use the our bridge instead.
        MethodChannelBridge.initialize(flutterEngine);

        // Use the dependency injection library of your choice. This is simply an example.
        Injector.registerObject("counterBlocAdapter", CounterBlocAdapter());
    }

    private fun navigateToPage() {
        val counterActivityIntent = Intent(this, CounterActivity::class.java).apply {
            // putExtra("some_variable", someValue);
        }
        startActivity(counterActivityIntent);
    }
}
