import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

/// Example of a service. This stores values of different kinds, such as
/// booleans, strings and numbers in the local device (the smartphone).
///
/// All the operations are asynchronous, but they are all expected to be very
/// fast and unlikely to fail. Any errors are likely to be logic errors (for
/// example, trying to read the wrong type of data).
///
/// Do not use this to store large amounts of data.
class LocalStorageService {
  // The current implementation of this service writes to temporary memory.
  // The next step is to access real device storage to persist information.
  final Map<String, dynamic> _storage = {};

  /// Attempts to read a value from storage with type T. Causes an error if the
  /// value doesn't exist or if it has the wrong type.
  Future<Either<PlaygroundError, T>> _safeRead<T>(String key) async {
    final value = _storage[key];
    if (value == null) {
      return Left(LocalStorageValueNotFoundError(valueName: key));
    }

    if (value is T) {
      return Right(value);
    } else {
      return Left(LocalStorageTypeError(valueName: key));
    }
  }

  // Write other missing methods.
}

// Below are some custom exceptions that this service throws.

class LocalStorageValueNotFoundError extends PlaygroundError {
  final String valueName;
  const LocalStorageValueNotFoundError({required this.valueName});

  @override
  Exception? cause() {
    return null;
  }

  @override
  String? developerMessage() {
    return "Value for key $valueName was not present in memory.";
  }

  @override
  String errorCode() {
    return "LS-0001";
  }

  @override
  String errorMessage() {
    return "A value could not be read from storage.";
  }
}

class LocalStorageTypeError extends PlaygroundError {
  final String valueName;
  const LocalStorageTypeError({required this.valueName});

  @override
  Exception? cause() {
    return null;
  }

  @override
  String? developerMessage() {
    return "Value for key $valueName was not of the requested type.";
  }

  @override
  String errorCode() {
    return "LS-0002";
  }

  @override
  String errorMessage() {
    return "A value could not be read from storage.";
  }
}

class LocalStorageOperationError extends PlaygroundError {
  final Exception ex;
  const LocalStorageOperationError({required this.ex});

  @override
  Exception? cause() {
    return ex;
  }

  @override
  String? developerMessage() {
    return "Local storage read or write operation failed.";
  }

  @override
  String errorCode() {
    return "LS-0003";
  }

  @override
  String errorMessage() {
    return "Storage could not be accessed.";
  }
}
