import 'package:flutter_reference/domain/error/playground_error.dart';

/// Error class for problems that occur in blocs.
/// This class has a field for a readable error message, which can be used to
/// display a message to the end user.
class PlaygroundBusinessError implements PlaygroundError {
  final String code;
  final String readableErrorMessage;
  final String blocName;
  final Exception? nestedException;

  @override
  Exception? cause() {
    return nestedException;
  }

  @override
  String? developerMessage() {
    if (nestedException != null) {
      return "Bloc $blocName, error code $code, nested exception is: ${nestedException.toString()}";
    } else {
      return "Bloc $blocName, eror code $code";
    }
  }

  @override
  String errorCode() {
    return code;
  }

  @override
  String errorMessage() {
    return readableErrorMessage;
  }

  const PlaygroundBusinessError(
    this.code,
    this.readableErrorMessage, {
    required this.blocName,
    this.nestedException,
  });
}
