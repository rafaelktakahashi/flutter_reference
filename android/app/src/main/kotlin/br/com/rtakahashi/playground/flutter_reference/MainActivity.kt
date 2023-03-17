package br.com.rtakahashi.playground.flutter_reference

import android.content.Intent
import androidx.annotation.NonNull
import br.com.rtakahashi.playground.flutter_reference.core.bloc.CounterBlocAdapter
import br.com.rtakahashi.playground.flutter_reference.core.injection.Injector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL_NAVIGATOR = "br.com.rtakahashi.playground.flutter_reference/navigator";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
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

        Injector.registerObject("counterBlocAdapter", CounterBlocAdapter(flutterEngine));
    }

    private fun navigateToPage() {
        val counterActivityIntent = Intent(this, CounterActivity::class.java).apply {
            // putExtra("some_variable", someValue);
        };
        startActivity(counterActivityIntent);
    }
}
