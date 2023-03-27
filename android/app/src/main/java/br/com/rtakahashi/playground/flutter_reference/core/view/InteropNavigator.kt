package br.com.rtakahashi.playground.flutter_reference.core.view

import android.content.Intent
import br.com.rtakahashi.playground.flutter_reference.core.bridge.MethodChannelBridge

object InteropNavigator {

    private var bridgePort = run {
        val port = MethodChannelBridge.openPort("InteropNavigator")
        port.registerHandler("navigate") {
            // TODO
        }
        port
    }

    fun navigate(pageName: String, parameters: Map<String,Any>? = null) {
        when (pageName) {
            "counter" -> {
                // TODO

            }
        }
    }


}