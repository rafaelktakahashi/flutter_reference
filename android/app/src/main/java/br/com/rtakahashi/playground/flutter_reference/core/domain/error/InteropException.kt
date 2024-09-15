package br.com.rtakahashi.playground.flutter_reference.core.domain.error

/**
 * An exception with some properties that will be read and passed onto the Dart side of the bridge.
 */
abstract class InteropException: Exception() {
    // An exception already has a `message` (String).
    abstract val developerMessage: String
    abstract val errorCode: String
    abstract val extra: Map<String, String>?
}
