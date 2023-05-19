/// Superclass for all errors that can be returned from operations (especially
/// in the data layer) in this project.
///
/// You should change this class according to what you need in your project.
/// You're free to create as many subclasses as are useful to you; for example,
/// a class for network errors that always produces a fixed generic error
/// message, or a bloc error that's instantiated with a bloc and prints its
/// details.
///
/// Having all your errors share a superclass makes it easier to pass on errors
/// without knowing what exactly they are, but be careful not to "bleed"
/// sensitive information on the screen. You should always be mindful of what
/// information is aimed at developers (to be printed in the console or sent to
/// analytics) and what information is aimed at users (to be shown on screen).
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
