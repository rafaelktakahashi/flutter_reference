package br.com.rtakahashi.playground.flutter_reference.core.view

import android.content.Intent
import android.os.Parcelable
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

    // This isn't a particularly good example of how you should configure a navigator.
    // Just focus on how this class uses the bridge instead of using its own method channel.
    @JvmStatic
    fun initializeNavigator(flutterActivity: FlutterActivity) {
        this.flutterActivity = flutterActivity
        val port = MethodChannelBridge.openPort("InteropNavigator")
        port.registerHandler("navigate") {
            if (it is JSONObject) {
                val pageName = it["pageName"]
                if (pageName is String) {
                    try {
                        navigate(pageName, it["parameters"] as? Map<String, Any>)
                    } catch (ex: InteropNavigatorException) {
                        Log.d(
                            "InteropNavigator",
                            "InteropNavigator.navigate could not find page $pageName."
                        )
                        return@registerHandler null
                    }
                } else {
                    Log.d(
                        "InteropNavigator",
                        "InteropNavigator.navigate did not receive page name."
                    )
                    return@registerHandler null
                }
            } else {
                Log.d(
                    "InteropNavigator",
                    "InteropNavigator.navigate received parameter different from an object."
                )
                return@registerHandler null
            }

        }

        this.bridgePort = port
    }


    @JvmStatic
    fun navigate(pageName: String, parameters: Map<String, Any>? = null) {
        val fActivity =
            this.flutterActivity ?: return // Cannot use this class before initialization.

        when (pageName) {
            "counter" -> {
                val counterActivityIntent =
                    Intent(fActivity, CounterActivity::class.java).apply {
                        if (parameters !== null) {
                            parameters.forEach { entry ->
                                val extra = entry.value // There's probably a better way to do this,
                                when (extra) { // but the putExtra itself has all these overloads.
                                    is Int -> putExtra(entry.key, extra)
                                    is String -> putExtra(entry.key, extra)
                                    is java.io.Serializable -> putExtra(entry.key, extra)
                                    is Parcelable -> putExtra(entry.key, extra)
                                    // etc
                                }
                            }
                        }
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