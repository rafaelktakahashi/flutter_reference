import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/service/local_storage_service.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';
import 'package:get_it/get_it.dart';

// Normally, settings are saved in local storage, and the operations of reading
// and writing there are asynchronous.
//
// This bloc exposes that information synchronously, assuming that these
// operations can happen in the background and can be relied to work practically
// always. Thus, this bloc doesn't handle errors.
//
// The risk of failing to write or read local storage is very small, and if it
// happens it's much more likely to be a bug than a real runtime error such as
// insufficient storage.
//
//
// You may have multiple blocs that access local storage to do different things;
// this is an example of a bloc that uses storage for settings, but a different
// bloc could store flags or other kinds of data.

/// The settings state contains a dynamic map, so it's type-unsafe on purpose.
///
/// The main reason for the map being dynamic is that making it type-safe
/// requires a great deal of repeated code for every additional setting in the
/// app. Other blocs can offer type-safe operations if it only supports values
/// of one type.
class SettingsState {
  // To add a new setting:
  // 1. Add the key in this class.
  // 2. Add its default value in SettingsState.defaultSettings().
  // 3. In the bloc, add logic to read it from storage and to write it to
  // storage, considering its expected type.
  //
  // If you need different variable names in Android and iOS (for example, if
  // you need to support legacy variables that already existed), you can use
  // the Flutter API to check for the platform here. You'd continue to use these
  // variables as if they were constants:
  // static final dependsOnPlatform = Platform.isAndroid ? "value-a" : "value-b";
  //
  // Also, these constants don't need to be in the state. You can place them
  // elsewhere if you prefer, and even use enums or classes instead.

  /// Expected type: boolean.
  static const settingOneKey = "setting_1";

  /// Expected type: boolean.
  static const settingTwoKey = "setting_2";

  /// Expected type: boolean.
  static const settingThreeKey = "setting_3";

  /// Expected type: string.
  static const settingAbcKey = "setting_abc";

  /// Expected type: int.
  static const settingNumberKey = "setting_number";

  final Map<String, dynamic> values;

  const SettingsState({required this.values});

  /// Create a new instance of this state where you can specify new values for
  /// the map.
  ///
  /// Typically you'd use Freezed to auto-generate the copyWith method, but in
  /// this case I needed a specific behavior with the [ignoreNull] parameter.
  SettingsState copyWith(Map<String, dynamic> newValues,
      {bool ignoreNull = true}) {
    // This is to avoid modifying the previous map.
    final Map<String, dynamic> mapCopy = Map.from(values);

    // This is to avoid modifying the parameter.
    final Map<String, dynamic> newValuesCopy = Map.from(newValues);

    if (ignoreNull) {
      newValuesCopy.removeWhere((key, value) => value == null);
    }

    mapCopy.addAll(newValuesCopy);

    return SettingsState(values: mapCopy);
  }

  // Default settings are used in two situations: (1) when the app opens for the
  // first time, and (2) when settings fail to load.
  // The second case should be very rare or never happen. If you determine that
  // such failures are common in your app, you'll need additional logic to use
  // a separate set of fallback values.
  factory SettingsState.defaultSettings() {
    return const SettingsState(values: {
      SettingsState.settingOneKey: false,
      SettingsState.settingTwoKey: true,
      SettingsState.settingThreeKey: false,
      SettingsState.settingAbcKey: 'A',
      SettingsState.settingNumberKey: 40,
    });
  }
}

abstract class SettingsEvent {
  const SettingsEvent();
}

/// Read all settings from memory.
///
/// Settings will be unavailable in the settings bloc until initialization takes
/// place. You can reference the settings, but all you'll find are default
/// values, so it's not recommended to use them too early during the app's
/// initialization.
///
/// Initialization is expected to be very fast, but it's an asynchronous
/// operation nonetheless.
///
/// One instance of this event must be emitted at initialization. The bloc does
/// not automatically initialize itself. Check the `dependency_injection.dart`
/// file to see where this event is emitted.
class InitializeSettingsEvent extends SettingsEvent {
  const InitializeSettingsEvent();
}

/// Write a new value to a certain key.
///
/// The setting will be updated immediately, and then written to storage in the
/// background. Each key has an expected type. If the [newValue] is of the wrong
/// type, then nothing will happen (fails silently).
class UpdateSettingEvent extends SettingsEvent {
  final String settingKey;
  final dynamic newValue;
  const UpdateSettingEvent({required this.settingKey, required this.newValue});
}

/// This is only necessary because dart doesn't have null-safe casts.
/// (For example, other languages have the as? operator.)
T? _safeCast<T>(dynamic input) {
  if (input is T) {
    return input;
  } else {
    return null;
  }
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.defaultSettings()) {
    super.on<InitializeSettingsEvent>((event, emit) async {
      // Initialize settings by reading multiple settings from local storage.
      // For all settings that don't exist, use a default value.
      try {
        // Here we make multiple parallel calls, but the local storage ought
        // to be able to handle all that without any problems.
        List<Either<PlaygroundError, dynamic>> eithers = await Future.wait([
          localStorageService.read<bool>(SettingsState.settingOneKey),
          localStorageService.read<bool>(SettingsState.settingTwoKey),
          localStorageService.read<bool>(SettingsState.settingThreeKey),
          localStorageService.read<String>(SettingsState.settingAbcKey),
          localStorageService.read<int>(SettingsState.settingNumberKey),
        ]);
        // Now we have a list of eithers. For each either that's a right,
        // unwrap its value; for each either that's a left (not expected), use
        // null. Any lefts here should be considered a bug to be fixed in code.
        List<dynamic> values = eithers
            .map((e) => e.fold(
                  (l) => null,
                  (r) => r,
                ))
            .toList();
        // Next, make a new instance of settings where we only overwrite what
        // is non-null and the correct type. Any value that is null will be
        // ignored (but that should be considered a bug).
        emit(
          state.copyWith(
            {
              SettingsState.settingOneKey: _safeCast<bool>(values[0]),
              SettingsState.settingTwoKey: _safeCast<bool>(values[1]),
              SettingsState.settingThreeKey: _safeCast<bool>(values[2]),
              SettingsState.settingAbcKey: _safeCast<String>(values[3]),
              SettingsState.settingNumberKey: _safeCast<int>(values[4]),
            },
            ignoreNull: true,
          ),
        );
      } catch (_) {
        // This bloc doesn't expose errors. If this happens, that means there's
        // a bug and you must debug this line to investigate.
        return;
      }

      // A note on generic parameters: It would be very useful if we could write
      // a list of settings, each with a key, a default value and a type, to
      // avoid repeated code.
      // However, variables of type Type cannot be used as generic parameters:
      //
      // Type settingType = bool;
      // String settingKey = "some_key";
      // localStorageService.read<settingType>(settingKey); // Doesn't work
      //
      // We could rewrite the `read()` method to receive a Type parameter, as in
      // `read(String key, Type type)`, but then we lose the generic parameter
      // and can't return instances of T, only dynamic.
      // That would be alright for this specific use case (since this bloc
      // treats all returns as dynamic anyway), but then we get a service with
      // an unsafe return just because of the way a bloc works, and that is not
      // correct.
    });

    super.on<UpdateSettingEvent>((event, emit) async {
      // This function emits the new state immediately. However, we don't want
      // to call it right away, because validating types comes first.
      emitState() => emit(state.copyWith({event.settingKey: event.newValue}));

      // Each setting may have different types. Verifying that the type is
      // correct is a responsibility of this bloc, not the widgets.

      switch (event.settingKey) {
        // Booleans
        case SettingsState.settingOneKey:
        case SettingsState.settingTwoKey:
        case SettingsState.settingThreeKey:
          if (event.newValue is bool) {
            emitState();
            // There's no need to await this.
            localStorageService.write<bool>(event.settingKey, event.newValue);
          }
          // You can handle errors if you want. This code fails silently.
          break;
        // Strings
        case SettingsState.settingAbcKey:
          if (event.newValue is String) {
            emitState();
            localStorageService.write<String>(event.settingKey, event.newValue);
          }
          break;
        // Integers
        case SettingsState.settingNumberKey:
          if (event.newValue is int) {
            emitState();
            localStorageService.write<int>(event.settingKey, event.newValue);
          }
      }
    });
  }

  final localStorageService = GetIt.I.get<LocalStorageService>();
}

// Rambling.
// I really miss Typescript's static type checking in times like these.
// Its type system is very powerful and lets you do things like this:
//
// (typescript)
//
// type Settings = {
//     settingA: Boolean,
//     settingB: Boolean,
//     settingC: String,
//     settingD: Number,
// }
//
// type SettingsKey = keyof Settings;
//
// function updateSettings<T extends SettingsKey>(key: T, value: Settings[T]) {
//     // ...
// }
//
// // Now, you can only call this method with a string that's a property of
// // Settings (otherwise you get a compilation error), and with a variable of
// // the corresponding type (otherwise you get a compilation error).
// updateSettings("settingA", false);
// updateSettings("settingC", "aaa");
// updateSettings("settingD", 50);
//
//
// To the best of my knowledge, other languages like Dart simply cannot do this.
// Instead of insisting on getting static type checking, I preferred to leave
// everything dynamic.
