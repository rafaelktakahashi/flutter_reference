// Normally, settings are saved in local storage, and the operations of reading
// and writing there are asynchronous.
//
// This bloc exposes that information synchronously, assuming that these
// operations can happen in the background and can be relied to work practically
// always. Thus, this bloc doesn't handle errors.
//
// The risk of failing to write or read local storage is very small, and if it
// happens it's indicative of a bug.

import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState {
  const SettingsState();
}

abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    // Register event handlers. TODO.
  }
}
