import 'package:flutter_reference/domain/error/playground_error.dart';

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
    throw UnimplementedError();
  }

  @override
  String errorMessage() {
    throw UnimplementedError();
  }

  const PlaygroundBusinessError(
    this.code,
    this.readableErrorMessage, {
    required this.blocName,
    this.nestedException,
  });
}
