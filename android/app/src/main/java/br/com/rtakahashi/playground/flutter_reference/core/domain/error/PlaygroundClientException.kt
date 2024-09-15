package br.com.rtakahashi.playground.flutter_reference.core.domain.error

/**
 * Example implementation of an InteropException.
 * The point is that you can throw the same exceptions as when working with just Kotlin code,
 * but if the exception thrown extends from InteropException, its data will make it through
 * the bridge.
 */
class PlaygroundClientException(
    override val errorCode: String,
    val statusCode: String,
    override val developerMessage: String,
) : InteropException() {
    override val message: String = "A network error has occurred."
    override val extra: Map<String, String>
        get() {
            return mapOf(
                "statusCode" to this.statusCode,
                "developerMessage" to this.developerMessage
            )
        }
}