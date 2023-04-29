import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/data/client/playground_client.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/data/service/local_storage_service.dart';
import 'package:get_it/get_it.dart';

/// Initialize dependency injection. This function creates all instances
/// that need to exist from the start.
///
/// It is not necessary to call `ensureInitialize()` before this, because all
/// of our classes use method channels through the bridge.
void configureDependencies() {
  // Theoretically, we should decouple GetIt (or any other specific library)
  // by wrapping it with our own classes.
  // Realistically, I think it's safe to reference it directly. We get to
  // use all of GetIt's features, with the only drawback that changing it
  // it in the future would be more work.

  // Register clients
  GetIt.I.registerSingleton<PlaygroundClient>(PlaygroundClient());

  // Register repositories and services.
  // All repositories and services should be registered here, even the ones that
  // don't extend from InteropRepository. That's to enable blocs to obtain
  // references to any repository using GetIt.
  GetIt.I.registerSingleton<ProductRepository>(ProductRepository());
  GetIt.I.registerSingleton<LocalStorageService>(LocalStorageService());

  // Register singletons of blocs that inherit from InteropBloc, because
  // they need to always be available in case native code needs to use them.
  // For this reason, we can't use factories here, only singletons.
  GetIt.I.registerSingleton<CounterBloc>(CounterBloc());
}
