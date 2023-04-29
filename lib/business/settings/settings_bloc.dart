import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/service/local_storage_service.dart';
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
// bloc could store flags or other kind of data.

/// The settings state contains a dynamic map, so it's type-unsafe on purpose.
///
/// The main reason for the map being dynamic is that making it type-safe
/// requires a great deal of repeated code for every additional setting in the
/// app. We leave the
class SettingsState {
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

  SettingsState copyWith(Map<String, dynamic> newValues) {
    final Map<String, dynamic> mapCopy = Map.from(values);
    mapCopy.addAll(newValues);

    return SettingsState(values: mapCopy);
  }

  factory SettingsState.defaultSettings() {
    return const SettingsState(values: {
      SettingsState.settingOneKey: false,
      SettingsState.settingTwoKey: true,
      SettingsState.settingThreeKey: false,
      SettingsState.settingAbcKey: 'A',
      SettingsState.settingNumberKey: 42,
    });
  }
}

abstract class SettingsEvent {
  const SettingsEvent();
}

/// Read all settings from memory.
///
/// Settings will be unavailable in the settings bloc until initialization takes
/// place.
/// Initialization is expected to be very fast, but it's an asynchronous
/// operation nonetheless.
class InitializeSettingsEvent extends SettingsEvent {
  const InitializeSettingsEvent();
}

/// Write a new value to a certain key.
///
/// Updating settings does not check for types. All settings are dynamic.
class UpdateSettingEvent extends SettingsEvent {
  final String settingKey;
  final dynamic newValue;
  const UpdateSettingEvent({required this.settingKey, required this.newValue});
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.defaultSettings()) {
    super.on<InitializeSettingsEvent>((event, emit) async {
      // Initialize settings by reading multiple settings from local storage.
      // For all settings that don't exist, use a default value.
      final settingsFromStorage = (await localStorageService.readMultiple([
        SettingsState.settingOneKey,
        SettingsState.settingTwoKey,
        SettingsState.settingThreeKey,
        SettingsState.settingAbcKey,
        SettingsState.settingNumberKey,
      ]))
          .fold((l) => <String, dynamic>{}, (r) => r);

      emit(state.copyWith(settingsFromStorage));
    });

    super.on<UpdateSettingEvent>((event, emit) async {
      // Immediately update the bloc, so that any pages using it get immediately
      // updated. We then update the value in local storage, trusting that it
      // won't fail.
      emit(state.copyWith({event.settingKey: event.newValue}));

      // Don't need to await this. Trust that it succeeds.
      localStorageService.write(event.settingKey, event.newValue);
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
