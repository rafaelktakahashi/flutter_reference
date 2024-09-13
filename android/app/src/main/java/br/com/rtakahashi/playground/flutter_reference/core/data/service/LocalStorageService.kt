package br.com.rtakahashi.playground.flutter_reference.core.data.service

import br.com.rtakahashi.playground.flutter_reference.core.data.service.infra.InteropService
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

/**
 * Adapter that lets this side of the bridge use the Dart side's local storage service.
 */
class LocalStorageService : InteropService("local-storage") {
    // TODO: It would seem this call does not work. Something about suspend functions breaks with
    // the method channel.
    suspend fun <T> read(key: String): T {
        return suspendCoroutine { cont ->
            super.call("read", key, { error ->
                {
                    println(error)
                    cont.resumeWithException(error);
                }
            }) { value ->
                // T is an erased type (curse the JVM), so we just assume it's correct,
                // and if it isn't, some error will happen later. That, however, can be
                // considered a bug and not part of the program's intended operation.
                cont.resume(value as T)
            }
        }

    }
}