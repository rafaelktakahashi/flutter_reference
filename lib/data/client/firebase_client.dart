import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/error/megastore_error.dart';

class FirebaseClient {
  // This class is just an example of where you could initialize a
  // connection to Firebase.

  static bool _initialized = false;

  static void connect() {
    _initialized = true;
  }

  static Future<Either<FirebaseClientError, dynamic>>
      firebaseParameters() async {
    if (!_initialized) {
      return const Left(FirebaseClientError(
          "There was an error while reading information stored in our servers. If this is preventing you from doing work, please contact our customer support.",
          "Tried to read parameters from Firebase before initialization."));
    } else {
      return const Right({
        "param1": 1,
        "param2": "a",
        "param3:": [],
      });
    }
  }
}

class FirebaseClientError implements MegastoreError {
  final String _message;
  final String _devMessage;

  @override
  Exception? cause() {
    return null;
  }

  @override
  String? developerMessage() {
    return "Error in our Firebase Client";
  }

  @override
  String errorCode() {
    return "MSG-1005";
  }

  @override
  String errorMessage() {
    return _message;
  }

  const FirebaseClientError(this._message, this._devMessage);
}
