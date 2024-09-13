import 'package:dartz/dartz.dart';
import 'package:flutter_reference/data/infra/interop_service.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
/// Do not use this to store large amounts of data. If you need to store large
/// amounts of information (for example, a json that can be many kilobytes in
/// size), then consider storing that information as files using a dedicated
/// service for writing and reading local files.
class LocalStorageService extends InteropService {
  LocalStorageService() : super("local-storage") {
    // This exposed version of the read method is very unsafe and could probably
    // be improved.
    super.exposeMethod("read", (value) {
      // The parameter is assumed to be the key.
      if (value is! String) {
        throw LocalStorageValueNotFoundError(valueName: "$value");
      }

      // final valueReadFromSecureStorage = await read(value);
      final valueReadFromSecureStorage = Right(true);
      // Turning Eithers into try/catch-style code is very awkward, sadly.
      if (valueReadFromSecureStorage.isLeft()) {
        throw LocalStorageValueNotFoundError(valueName: value);
      } else {
        return valueReadFromSecureStorage.getOrElse(() => false);
      }
    });
  }

  // A NOTE ABOUT FLUTTER_SECURE_STORAGE:
  // The library is not trivial to use, and it makes some changes to the native
  // projects that you may not want, depending on the project's configuration.
  // I'm using this library because it's a simple way of demonstrating the
  // implementation of this service. Depending on your circumstances, it may be
  // better to write your own native code to write and read files.
  // If you do that, you'd have a corresponding LocalStorageService in Android
  // code, and another in iOS code. The read<T>(...) and write<T>(...) methods
  // here would use the bridge to call the corresponding native methods.
  //
  // Another concern is that you may need different key names in Android and in
  // iOS, for example if you need to support legacy variables that already
  // existed before. However, that is not the concern of this service, since
  // here we only receive the variable names to interact with them. See the
  // settings bloc for an example implementation.

  /// This instance interacts with the system API.
  final storage = const FlutterSecureStorage();

  /// Reads a value as the specified type. Only some specific types are
  /// supported, since everything is stored as string and conversions are done
  /// manually in this method.
  ///
  /// If the key is not present in storage, this will return null. When the app
  /// runs for the first time, you should expect the storage to be empty.
  ///
  /// Currently the generic parameter supports String, int, double and bool.
  /// Other types must be implemented if necessary.
  Future<Either<PlaygroundError, T?>> read<T>(String key) async {
    // This can throw a platform exception, but that likely would be caused by
    // a bug.
    final String? stringValue = await storage.read(key: key);

    // Whenever a key is not present in storage, return null, but don't consider
    // it a failure (a Left). Nulls are expected during the app's maiden flight.
    if (stringValue == null) {
      return const Right(null);
    }

    // Now, we have a string. We need to convert the value depending on what is
    // expected. For example, if T is Int, then we need to convert the string to
    // int.
    //
    // -- A note on functional programming:
    // There's an argument to be made that it's not "correct" to do if-elses
    // with types, because anything that's generic is supposed to work the same
    // regardless of type, reusing the same logic. However, pattern-matching on
    // values and on types is common in functional programming, and that is
    // effectively the same as if-elses.
    switch (T) {
      case String:
        // Simplest case, return the value as it is.
        return Right(stringValue as T);
      case int:
        // Attempt to cast to integer.
        try {
          return Right(int.parse(stringValue) as T);
        } on FormatException catch (e) {
          return Left(
            LocalStorageCastError(
              actualValue: stringValue,
              expectedType: T,
              keyName: key,
              parseException: e,
            ),
          );
        }
      case double:
        // Attempt to cast to double.
        try {
          return Right(double.parse(stringValue) as T);
        } on FormatException catch (e) {
          return Left(
            LocalStorageCastError(
              actualValue: stringValue,
              expectedType: T,
              keyName: key,
              parseException: e,
            ),
          );
        }
      case bool:
        switch (stringValue.toLowerCase()) {
          // The linter suggests returning const Right(true as T), but that
          // causes a compilation error because T is Never in constants
          // (I think).
          case 'true':
            // ignore: prefer_const_constructors
            return Right(true as T);
          case 'false':
            // ignore: prefer_const_constructors
            return Right(false as T);
          default:
            return Left(
              LocalStorageCastError(
                actualValue: stringValue,
                expectedType: T,
                keyName: key,
              ),
            );
        }
      default:
        // Getting the name of a generic type is something you can't do in just
        // about any language. Dart supports it.
        return Left(LocalStorageUnsupportedTypeError(typeName: T.toString()));
    }
  }

  /// Write a [value] to local storage, under a specified [key].
  ///
  /// The types supported for [T] are String, int, double and bool, because
  /// those are the values that can be read using this class.
  Future<Either<PlaygroundError, Unit>> write<T>(String key, T value) async {
    // Everything gets converted to String, but first we need to verify that
    // the value is of a supported type. This is just because we don't want to
    // write a value that this class can't read.
    switch (T) {
      case String:
      case int:
      case double:
      case bool:
        await storage.write(key: key, value: "$value");
        return const Right(unit);
      default:
        return Left(LocalStorageUnsupportedTypeError(typeName: T.toString()));
    }
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
    return "Tried to read or write value of unsupported type $typeName to local storage.";
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

class LocalStorageCastError extends PlaygroundError {
  final String actualValue;
  final Type expectedType;
  final String keyName;
  final Exception? parseException;
  const LocalStorageCastError({
    required this.actualValue,
    required this.expectedType,
    required this.keyName,
    this.parseException,
  });

  @override
  Exception? cause() {
    return parseException;
  }

  @override
  String? developerMessage() {
    return "Tried to read value of type $expectedType from key $keyName, but could not cast its value $actualValue";
  }

  @override
  String errorCode() {
    return "LS-0005";
  }

  @override
  String errorMessage() {
    return "A value could not be read from storage.";
  }
}
