import 'package:flutter_reference/domain/error/playground_error.dart';

class PlaygroundNavigationError implements PlaygroundError {
  final String code;
  final String readableErrorMessage;
  final Exception? nestedException;

  const PlaygroundNavigationError(
    this.code, {
    required this.readableErrorMessage,
    this.nestedException,
  });

  @override
  Exception? cause() {
    return nestedException;
  }

  @override
  String? developerMessage() {
    if (nestedException != null) {
      return "$readableErrorMessage / found error ${nestedException.toString()}";
    } else {
      return readableErrorMessage;
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
}
