import 'playground_error.dart';

/// Example of an error class. It implements our Error base class to expose
/// common methods.
class PlaygroundClientError implements PlaygroundError {
  final String code;

  /// This error should be used to document what went wrong, but should not be
  /// shown to the end user. I could explain, for example, that a parsing error
  /// has occurred.
  final String developerErrorMessage;
  final String responseStatus;
  final Exception? nestedException;

  @override
  String errorCode() {
    return code;
  }

  /// This is the message that appears to the end user when the exception makes
  /// it all the way to the screen. If you want to show a different message when
  /// a certain error occurs, identify it by error code in a bloc to wrap the
  /// error.
  @override
  String errorMessage() {
    return "An error occurred. Please try again later.";
  }

  // This is just an example of an implementation of an error.
  // In real code, you should probably think more about what
  // fields will be useful to you.

  @override
  String? developerMessage() {
    return "(status $responseStatus) $developerErrorMessage";
  }

  @override
  Exception? cause() {
    return nestedException;
  }

  const PlaygroundClientError(
    this.code,
    this.developerErrorMessage, {
    required this.responseStatus,
    this.nestedException,
  });
}

class PlaygroundClientErrorStepUpAuthenticationRequired
    implements PlaygroundError {
  @override
  Exception? cause() {
    return null;
  }

  @override
  String? developerMessage() {
    return "Url $url requires step-up authentication.";
  }

  @override
  String errorCode() {
    return "STEP_UP_REQUIRED";
  }

  @override
  String errorMessage() {
    return "An authentication code is required.";
  }

  final String url;
  final String sessionId;
  const PlaygroundClientErrorStepUpAuthenticationRequired({
    required this.url,
    required this.sessionId,
  });
}
