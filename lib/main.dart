import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/buyer/buyer_bloc.dart';
import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/business/life/life_bloc.dart';
import 'package:flutter_reference/business/product/product_form_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/business/settings/settings_bloc.dart';
import 'package:flutter_reference/config/dependency_injection.dart';
import 'package:flutter_reference/data/bridge/channel_bridge.dart' as bridge;
import 'package:flutter_reference/view/infra/app.dart';
import 'package:flutter_reference/view/nav/nav_case_extension.dart';
import 'package:flutter_reference/view/nav/nav_cases/redirection_nav_cases.dart';
import 'package:get_it/get_it.dart';

/// Entry point of the application.
///
/// If you're using Flutter code as a module, you must ensure that this code
/// properly runs at the start of the application.
void main() {
  // Register dependencies. This needs to be after the call to
  // ensureInitialized because some classes open the method channel.
  configureDependencies();

  // This line should be as late as possible, because anything that happens
  // after it will only happen after some parts of the Flutter framework
  // are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Flutter side of our method channel bridge.
  bridge.initializeBridge();

  // Here we connect all the blocs and run the app.
  // You can do this in a separate file if you prefer.
  runApp(_wrapProviders(const App()));
}

Widget _wrapProviders(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<CounterBloc>(
        // All interop blocs need to be singletons.
        // Other blocs can be created normally.
        // Anything you use here must have been previously initialized in
        // configureDependencies().
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
      BlocProvider<LifeBloc>(
        create: (BuildContext context) => LifeBloc(),
      ),
      BlocProvider<SettingsBloc>(
        create: (BuildContext context) => GetIt.I.get<SettingsBloc>(),
      ),
      BlocProvider<BuyerBloc>(
        create: (BuildContext context) => BuyerBloc(),
      ),
    ],
    // The navigation case provider is our own custom class. See its file for
    // details.
    child: NavigationCaseProvider(
      navigationCases: {
        "lifeWithGreenPage": greenPageNavigationCase,
      },
      child: child,
    ),
  );
}
