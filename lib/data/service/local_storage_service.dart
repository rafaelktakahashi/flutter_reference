import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

/// Example of a service. This stores values of different kinds, such as
/// booleans, strings and numbers in the local device (the smartphone).
///
/// While blocs should use repositories for remote operations (the repository
/// itself hides the integration), blocs are allowed to use services directly.
/// Services expose a part of the system OS. In this case, this service uses
/// storage APIs to store and retrieve values.
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
  Future<Either<PlaygroundError, T>> readSafe<T>(String key) async {
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

  /// Attempts to read a value from storage without validating its type.
  Future<Either<PlaygroundError, dynamic>> readDynamic(String key) async {
    return _storage[key];
  }

  /// Attempts to read multiple values from storage in a single operation.
  /// Causes an error if any of the requested values doesn't exist.
  ///
  /// The result is not type-safe. If successful, the list will contain exactly
  /// as many items as the array of [keys] that was provided.
  Future<Either<PlaygroundError, Map<String, dynamic>>> readMultiple(
      List<String> keys) async {
    // Real implementation with the system API should be better than just this.
    final resultMap = <String, dynamic>{};
    for (final key in keys) {
      resultMap[key] = _storage[key];
    }
    return Right(resultMap);
  }

  /// Attempts to write a value to storage. Generally, this should always
  /// succeed, unless you try to write a value of unsupported type.
  Future<Either<PlaygroundError, Unit>> write<T>(String key, T value) async {
    _storage[key] = value;
    return const Right(unit);
  }
}

// Below are some custom exceptions that this service throws.
// They're public but not meant to be instantiated outside of this file.

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

class LocalStorageUnsupportedTypeError extends PlaygroundError {
  final String typeName;
  const LocalStorageUnsupportedTypeError({required this.typeName});

  @override
  Exception? cause() {
    return null;
  }

  @override
  String? developerMessage() {
    return "Tried to write value of unsupported type $typeName to local storage.";
  }

  @override
  String errorCode() {
    return "LS-0004";
  }

  @override
  String errorMessage() {
    return "A value could not be written to storage.";
  }
}
