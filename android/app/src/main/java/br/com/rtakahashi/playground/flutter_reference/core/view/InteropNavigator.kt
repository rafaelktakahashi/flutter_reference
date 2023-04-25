package br.com.rtakahashi.playground.flutter_reference.core.view

import android.content.Intent
import android.util.Log
import br.com.rtakahashi.playground.flutter_reference.core.bridge.AndroidMethodChannelBridgePort
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridge
import io.flutter.embedding.android.FlutterActivity
import org.json.JSONObject

/**
 * Example of a class that uses our bridge to navigate to pages.
 *
 * This is primarily meant as an example of how a navigator could work. In a real project,
 * it may make more sense to integrate this with a navigation framework.
 */
object InteropNavigator {
    private var bridgePort: AndroidMethodChannelBridgePort? = null
    private var flutterActivity: FlutterActivity? = null

    /**
     * Navigate to a Flutter page in a context that's already loaded.
     *
     * Be careful! This probably doesn't work in the way you expect.. This sends a command to the
     * Flutter navigator, but that won't affect any native pages.
     *
     * For example, if you have the following stack:
     *
     * A -> B
     *
     * Where A is a Flutter page and B is a native page, then navigating to a new Flutter page C
     * will NOT make that page appear over B. It'll affect only the preexisting Flutter context:
     *
     * A -> C -> B
     *
     * If you're in a native page and you want to navigate to a new Flutter page, you'll have to
     * go to the Flutter activity. Calling the Flutter InteropNavigator only affects the Flutter
     * pages inside the Flutter activity.
     */
    @JvmStatic
    fun navigateInFlutter(url: String, method: String = "push") {
        bridgePort?.call("navigate", mapOf("url" to url, "method" to method));
    }

    // This isn't a particularly good example of how you should configure a navigator.
    // Just focus on how this class uses the bridge instead of using its own method channel.
    @JvmStatic
    fun initializeNavigator(flutterActivity: FlutterActivity) {
        this.flutterActivity = flutterActivity
        val port = MethodChannelBridge.openPort("InteropNavigator")
        port.registerHandlerSuspend("navigate") { params: Any? ->
            if (params is JSONObject) {
                val pageName = params["pageName"]
                if (pageName is String) {
                    try {
                        handleNavigate(pageName, params["parameters"] as? Map<String, Any>)
                    } catch (ex: InteropNavigatorException) {
                        Log.d(
                            "InteropNavigator",
                            "InteropNavigator.navigate could not find page $pageName."
                        )
                    }
                } else {
                    Log.d(
                        "InteropNavigator",
                        "InteropNavigator.navigate did not receive page name."
                    )
                }
            } else {
                Log.d(
                    "InteropNavigator",
                    "InteropNavigator.navigate received parameter different from an object."
                )
            }

        }

        this.bridgePort = port
    }


    @JvmStatic
    private fun handleNavigate(pageName: String, parameters: Map<String, Any>? = null) {
        val fActivity =
            this.flutterActivity ?: return // Cannot use this class before initialization.

        when (pageName) {
            "counter" -> {
                val counterActivityIntent =
                    Intent(fActivity, CounterActivity::class.java).apply {
                        // Here, you can call .putExtra(...) to add parameters to each
                        // page using the parameters map.
                        // In this example we're not using them.
                    }
                fActivity.startActivity(counterActivityIntent)
            }
            else -> {
                throw InteropNavigatorException("Route not found.")
            }
        }
    }

    private class InteropNavigatorException(message: String) : Exception(message)

}