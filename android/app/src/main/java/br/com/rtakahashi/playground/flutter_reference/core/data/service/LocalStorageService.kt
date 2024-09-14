package br.com.rtakahashi.playground.flutter_reference.core.data.service

import br.com.rtakahashi.playground.flutter_reference.core.data.service.infra.InteropService

/**
 * Adapter that lets this side of the bridge use the Dart side's local storage service.
 *
 * This is not a good practice and you should learn from my mistakes. I used the
 * flutter_secure_storage package to store key-value data, but it doesn't expose a
 * native API to read and write from the native side. I can't even use the secure
 * storage API directly because of the extra stuff the package does. If you ever need
 * to share preferences or other data between the native and the Flutter side, choose
 * another option, such as implementing your own local storage services natively.
 */
class LocalStorageService : InteropService("local-storage") {
    suspend fun read(key: String, default: String): String {
        // On the Dart side, the read method has a generic type that determines conversion logic.
        // However, we're unable to send generic type parameters through the method channel, so
        // the read method always returns String?.
        val result = super.call("read", key);
        if (result == null || result !is String) {
            return default;
        }
        return result;
    }
}