/// Superclass for all errors that can be returned from operations (especially
/// in the data layer) in this project.
abstract class PlaygroundError {
  const PlaygroundError();

  /// Readable error message that can be shown to the end-user to explain
  /// what went wrong.
  ///
  /// Example: "Service unavailable. Try again later or contact our customer
  /// support if the issue persists."
  String errorMessage();

  /// Optionally, more details for the developer to use when debugging.
  /// Never show this to the end user.
  ///
  /// Example: "Exception while parsing the response. Exception: ..."
  String? developerMessage();

  /// Optionally, an exception that caused this error, for the developer to
  /// use when debugging.
  /// Never show this to the end user.
  Exception? cause();

  /// Error code intended for developers only, to more easily locate where
  /// the error was thrown. If you show this value to the end user, make it
  /// clear that they should inform this to customer support.
  ///
  /// Example: "MGS-0115"
  String errorCode();
}
