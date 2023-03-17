// I don't have dependency management in this example project.
// Just pretend that these variables are coming from some DI library.

import 'package:flutter_reference/business/counter/counter_bloc.dart';

/// This project doesn't have real dependency injection
/// anywhere, as it is a minimal example of using blocs
/// in native code. In a real project, you should use the
/// DI library of your choice instead of this.
class Injector {
  CounterBloc counterBloc;
  Injector._() : counterBloc = CounterBloc();
  static Injector? _instance;
  static Injector instance() => _instance ??= Injector._();
}
