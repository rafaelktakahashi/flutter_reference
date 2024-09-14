import 'package:flutter_reference/domain/error/playground_error.dart';

class PlaygroundBridgeError implements PlaygroundError {
  final String code;
  final String devMessage;
  final Exception? nestedException;

  const PlaygroundBridgeError(
    this.code,
    this.devMessage, {
    this.nestedException,
  });

  @override
  Exception? cause() {
    return nestedException;
  }

  @override
  String? developerMessage() {
    return devMessage;
  }

  @override
  String errorCode() {
    return code;
  }

  @override
  String errorMessage() {
    return "There was an error in the app.";
  }
}
