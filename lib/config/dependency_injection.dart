import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/business/settings/settings_bloc.dart';
import 'package:flutter_reference/data/client/playground_client.dart';
import 'package:flutter_reference/data/repository/buyer_repository.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/data/service/local_storage_service.dart';
import 'package:flutter_reference/view/nav/interop_navigator.dart';
import 'package:get_it/get_it.dart';

/// Initialize dependency injection. This function creates all instances
/// that need to exist from the start.
///
/// It is not necessary to call `ensureInitialize()` before this, because all
/// of our classes use method channels through the bridge.
///
/// A note on dependency injection: Writing a Java backend service or something
/// similar that allows the implementation of classes to be chosen through some
/// configuration encourages extensive use of dependency injection. Mobile
/// development is very different; you don't have the option to hot-swap
/// anything, since all the classes get packaged into a binary
void configureDependencies() {
  // Theoretically, we should decouple GetIt (or any other specific library)
  // by wrapping it with our own classes.
  // Realistically, I think it's safe to reference it directly. We get to
  // use all of GetIt's features, with the only drawback that changing it
  // it in the future would be more work.

  // When a class is expensive to instantiate (if it runs a lot of code), then
  // it makes more sense to register factories rathen than singletons.
  // On the other hand, registering singletons makes possible errors happen
  // sooner (easier to debug), and ensures that everything will already exist
  // when needed, without the overhead of instantiating classes while the user
  // is already navigating in the app.

  // Register clients
  GetIt.I.registerSingleton<PlaygroundClient>(PlaygroundClient());

  // Register repositories and services.
  // All repositories and services should be registered here, even the ones that
  // don't extend from InteropRepository. That's to enable blocs to obtain
  // references to any repository using GetIt.
  GetIt.I.registerSingleton<ProductRepository>(ProductRepository());
  GetIt.I.registerSingleton<BuyerRepository>(BuyerRepository());
  GetIt.I.registerSingleton<LocalStorageService>(LocalStorageService());

  // Register singletons of blocs that inherit from InteropBloc, because
  // they need to always be available in case native code needs to use them.
  // For this reason, we can't use factories here, only singletons.
  GetIt.I.registerSingleton<CounterBloc>(CounterBloc());

  // Generally speaking, if a bloc needs to be initialized only once, you can
  // do it here or in the bloc provider.
  // This settingsBloc is initialized here and not in the bloc provider, because
  // initializing in the provider means that the initialization event would be
  // emitted when the settings page loads for the first time, and that leads to
  // visual bugs. Thus, this code here ensures that the settingsBloc
  // is initialized at the start of the application.
  final settingsBloc = SettingsBloc();
  settingsBloc.add(const InitializeSettingsEvent());
  GetIt.I.registerSingleton<SettingsBloc>(settingsBloc);

  // It's very important to create this instance here. The interop navigator is
  // a singleton, so it doesn't _need_ to be instantiated; however, its
  // constructor contains logic for registering its handler in the bridge.
  // If you don't instantiate this class during the app's initialization, it's
  // possible that the call registration gets skipped.
  GetIt.I.registerSingleton<InteropNavigator>(InteropNavigator());
}
