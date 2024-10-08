import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/settings/settings_keys.dart';
import 'package:flutter_reference/data/service/local_storage_service.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

// Normally, settings are saved in local storage, and the operations of reading
// and writing them are asynchronous.
//
// This bloc exposes that information synchronously, assuming that these
// operations can happen in the background and can be relied to work practically
// always. Thus, this bloc doesn't handle errors.
//
// The risk of failing to write or read local storage is very small, and if it
// happens it's much more likely to be a bug than a real runtime error such as
// insufficient storage. If your application has a high chance of encountering
// errors during IO operations, you may want to support errors in the state;
// generally speaking, however, the user can't do anything about IO errors.
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
  // 1. Add the key to the settings key enum, and its name in the extension.
  // 2. Add its default value in SettingsState.defaultSettings().
  // 3. In the bloc, add logic to read it from storage and to write it to
  // storage, considering its expected type.

  /// Keys and values that correspond to what's written in local storage.
  /// The values can be of any type; any widget can reference this map, and is
  /// expected to know the type of each value.
  final Map<SettingsKey, dynamic> values;

  const SettingsState({required this.values});

  /// Create a new instance of this state where you can specify new values for
  /// the map.
  ///
  /// Typically you'd use Freezed to auto-generate the copyWith method, but in
  /// this case I needed a specific behavior with the [ignoreNull] parameter.
  SettingsState copyWith(Map<SettingsKey, dynamic> newValues,
      {bool ignoreNull = true}) {
    // This variable is to avoid modifying the previous map.
    final Map<SettingsKey, dynamic> mapCopy = Map.from(values);

    // This variable is to avoid modifying the parameter.
    final Map<SettingsKey, dynamic> newValuesCopy = Map.from(newValues);

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
      SettingsKey.settingOneKey: false,
      SettingsKey.settingTwoKey: true,
      SettingsKey.settingThreeKey: false,
      SettingsKey.settingAbcKey: 'A',
      SettingsKey.settingNumberKey: 40,
      SettingsKey.settingSimulateStepUpRequestOnBuyersListKey: false,
      SettingsKey.settingSimulateStepUpRequestOnNativeProductsListKey: false,
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
  final SettingsKey settingKey;

  /// This value is dynamic because this bloc supports values of multiple types.
  /// It would be ideal to have static typing depending on what key was
  /// specified; we can do that in Typescript but not in Dart.
  ///
  /// Do keep in mind that the actual type of this [newValue] will be validated
  /// in the bloc. The code that emits this event is expected to know what type
  /// should be sent.
  ///
  /// If your bloc only supports one type (ex.: only booleans), then you can
  /// specify the type here.
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
          localStorageService.read<bool>(SettingsKey.settingOneKey.name),
          localStorageService.read<bool>(SettingsKey.settingTwoKey.name),
          localStorageService.read<bool>(SettingsKey.settingThreeKey.name),
          localStorageService.read<String>(SettingsKey.settingAbcKey.name),
          localStorageService.read<int>(SettingsKey.settingNumberKey.name),
          localStorageService.read<bool>(
              SettingsKey.settingSimulateStepUpRequestOnBuyersListKey.name),
          localStorageService.read<bool>(SettingsKey
              .settingSimulateStepUpRequestOnNativeProductsListKey.name),
        ]);
        // Now we have a list of eithers. For each either that's a right,
        // unwrap its value; for each either that's a left (not expected), use
        // null. Any lefts here should be considered a bug to be fixed in code.
        List<dynamic> values = eithers
            .map((e) => e.fold(
                  (l) {
                    // Lefts are not supposed to happen, so you can print errors
                    // here or send error reports.
                    return null;
                  },
                  (r) => r,
                ))
            .toList();
        // Next, make a new instance of settings where we only overwrite what
        // is non-null and the correct type. Any value that is null will be
        // ignored.
        // Null values can happen if nothing has been written to that key yet,
        // and in that case the default value will remain in the state.
        emit(
          state.copyWith(
            {
              SettingsKey.settingOneKey: _safeCast<bool>(values[0]),
              SettingsKey.settingTwoKey: _safeCast<bool>(values[1]),
              SettingsKey.settingThreeKey: _safeCast<bool>(values[2]),
              SettingsKey.settingAbcKey: _safeCast<String>(values[3]),
              SettingsKey.settingNumberKey: _safeCast<int>(values[4]),
              SettingsKey.settingSimulateStepUpRequestOnBuyersListKey:
                  _safeCast<bool>(values[5]),
              SettingsKey.settingSimulateStepUpRequestOnNativeProductsListKey:
                  _safeCast<bool>(values[6]),
            },
            ignoreNull: true,
          ),
        );
      } catch (_) {
        // This bloc doesn't expose errors. If this happens, that means there's
        // a bug and you must debug this line to investigate. Feel free to print
        // errors or send error reports here.
        return;
      }

      // A note on generic parameters: It would be very useful if we could write
      // a list of settings, each with a key, a default value and a type, to
      // avoid repeated code.
      // However, variables of type Type cannot be used as generic parameters:
      //
      // Type settingType = bool; // Works; settingType contains the value bool.
      // String settingKey = "some_key"; // Of course, this works too.
      // localStorageService.read<settingType>(settingKey); // Doesn't work!
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
      // If your bloc only supports one type (for example, only booleans), then
      // you don't need this switch-case.
      switch (event.settingKey) {
        // Booleans
        case SettingsKey.settingOneKey:
        case SettingsKey.settingTwoKey:
        case SettingsKey.settingThreeKey:
        case SettingsKey.settingSimulateStepUpRequestOnBuyersListKey:
        case SettingsKey.settingSimulateStepUpRequestOnNativeProductsListKey:
          if (event.newValue is bool) {
            emitState();
            // There's no need to await this.
            localStorageService.write<bool>(
                event.settingKey.name, event.newValue);
          }
          // You can handle errors if you want. This code fails silently.
          break;
        // Strings
        case SettingsKey.settingAbcKey:
          if (event.newValue is String) {
            emitState();
            localStorageService.write<String>(
                event.settingKey.name, event.newValue);
          }
          break;
        // Integers
        case SettingsKey.settingNumberKey:
          if (event.newValue is int) {
            emitState();
            localStorageService.write<int>(
                event.settingKey.name, event.newValue);
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
