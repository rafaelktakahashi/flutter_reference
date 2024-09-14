package br.com.rtakahashi.playground.flutter_reference

import br.com.rtakahashi.playground.flutter_reference.core.bloc.CounterBlocAdapter
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridge
import br.com.rtakahashi.playground.flutter_reference.core.data.repository.ProductRepository
import br.com.rtakahashi.playground.flutter_reference.core.data.service.LocalStorageService
import br.com.rtakahashi.playground.flutter_reference.core.data.service.StepUpPromptService
import br.com.rtakahashi.playground.flutter_reference.core.injection.Injector
import br.com.rtakahashi.playground.flutter_reference.core.view.InteropNavigator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Our method channel bridge needs to be initialized here, where we have a reference to
        // the Flutter engine.
        // Centralizing all method channel logic in the bridge frees everything else from needing
        // a reference to the Flutter engine to use the channel. Any class that needs to communicate
        // with Flutter code should use the our bridge instead.
        MethodChannelBridge.initialize(flutterEngine);

        // This initializes the interop navigator so that it can receive calls from Flutter.
        InteropNavigator.initializeNavigator(this)

        // Use the dependency injection library of your choice. This is simply an example.
        Injector.registerObject("counterBlocAdapter", CounterBlocAdapter());
        Injector.registerObject("productRepository", ProductRepository());
        Injector.registerObject("localStorageService", LocalStorageService());
        Injector.registerObject("stepUpPromptService", StepUpPromptService());
    }

}
