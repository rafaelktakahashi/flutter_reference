import 'megastore_error.dart';

/// Example of an error class. It implements
class MegastoreClientError implements MegastoreError {
  final String code;
  final String readableErrorMessage;
  final String responseStatus;
  final Exception? nestedException;

  @override
  String errorCode() {
    return code;
  }

  @override
  String errorMessage() {
    return readableErrorMessage;
  }

  // This is just an example of an implementation of an error.
  // In real code, you should probably think more about what
  // fields will be useful to you.

  @override
  String? developerMessage() {
    if (nestedException != null) {
      return "Status $responseStatus, error code $code, nested exception is: ${nestedException.toString()}";
    } else {
      return "Status $responseStatus, error code $code";
    }
  }

  @override
  Exception? cause() {
    return nestedException;
  }

  const MegastoreClientError(
    this.code,
    this.readableErrorMessage, {
    required this.responseStatus,
    this.nestedException,
  });
}
