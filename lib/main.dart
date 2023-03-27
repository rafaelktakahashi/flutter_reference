import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/business/product/product_form_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/config/dependency_injection.dart';
import 'package:flutter_reference/data/bridge/channel_bridge.dart' as bridge;
import 'package:flutter_reference/view/infra/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reference/view/pages/home.dart';
import 'package:get_it/get_it.dart';

void main() {
  // TODO: Anything that doesn't need this call can happen before it.
  // Find a way to call initializeBridge() after this call, but allow for
  // everything else to run in parallel.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Flutter side of our method channel bridge.
  bridge.initializeBridge();

  // Register dependencies. This needs to be after the call to
  // ensureInitialized because some classes open the method channel.
  // TODO: After the bridge works, send this line to the top.
  configureDependencies();

  runApp(_wrapProviders(const App()));
}

Widget _wrapProviders(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<CounterBloc>(
        // All interop blocs need to be singletons.
        // Other blocs can be created normally.
        create: (BuildContext context) => GetIt.I.get<CounterBloc>(),
      ),
      BlocProvider<ProductListBloc>(
        // These blocs will be created when needed.
        // If a bloc needs to exist since startup, then it
        // should be placed in GetIt.
        create: (BuildContext context) => ProductListBloc(),
      ),
      BlocProvider<ProductFormBloc>(
        create: (BuildContext context) => ProductFormBloc(),
      ),
    ],
    child: child,
  );
}
