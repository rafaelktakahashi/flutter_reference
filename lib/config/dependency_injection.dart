import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/data/client/megastore_client.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:get_it/get_it.dart';

/// Initialize dependency injection. This function creates all instances
/// that need to exist from the start.
/// Make sure to call this _after_ a call to ensureInitialized() because
/// some of the classes that are instantiated here need to open a
/// method channel.
void configureDependencies() {
  // Theoretically, we should decouple GetIt (or any other specific library)
  // by wrapping it with our own classes.
  // Realistically, I think it's safe to reference it directly. We get to
  // use all of GetIt's features, with the only drawback that changing it
  // it in the future would be more work.

  // Register clients
  GetIt.I.registerSingleton<MegastoreClient>(MegastoreClient());

  // Register repositories.
  GetIt.I.registerSingleton<ProductRepository>(ProductRepository());

  // Register singletons of blocs that inherit from InteropBloc, because
  // they need to always be available in case native code needs to use them.
  // For this reason, we can't use factories here, only singletons.
  GetIt.I.registerSingleton<CounterBloc>(CounterBloc());
}
