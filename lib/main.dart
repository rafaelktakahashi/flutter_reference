import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/address_lookup/address_lookup_bloc.dart';
import 'package:flutter_reference/business/buyer/buyer_bloc.dart';
import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/business/life/life_bloc.dart';
import 'package:flutter_reference/business/login_demo/bloc1.dart';
import 'package:flutter_reference/business/login_demo/bloc2.dart';
import 'package:flutter_reference/business/login_demo/login_bloc.dart';
import 'package:flutter_reference/business/product/product_form_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/business/settings/settings_bloc.dart';
import 'package:flutter_reference/config/dependency_injection.dart';
import 'package:flutter_reference/data/bridge/channel_bridge.dart' as bridge;
import 'package:flutter_reference/view/infra/app.dart';
import 'package:flutter_reference/view/nav/nav_case_extension.dart';
import 'package:flutter_reference/view/nav/nav_cases/redirection_nav_cases.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_reference_step_up_auth/flutter_reference_step_up_auth.dart'
    as step_up;

/// Entry point of the application.
///
/// If you're using Flutter code as a module, you must ensure that this code
/// properly runs at the start of the application.
void main() {
  configureDependencies();

  // This line should be as late as possible, because anything that happens
  // after it will only happen after some parts of the Flutter framework
  // are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Flutter side of our method channel bridge.
  bridge.initializeBridge();

  // Initialize the step-up modal library.
  step_up.initialize(clientToken: "clientToken");

  // Here we connect all the blocs and run the app.
  // You can do this in a separate file if you prefer.
  // (The _applyWrapper function is our own utility function; it simplifies the
  // syntax when you need to apply many wrappers, but you don't have to use it.)
  final app = _applyWrappers([_wrapBlocs, _wrapNavigationCases], const App());
  runApp(app);
}

Widget _wrapBlocs(Widget child) {
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
      BlocProvider<AddressLookupBloc>(
        create: (BuildContext context) => AddressLookupBloc(),
      ),
      BlocProvider<LoginBloc>(
        create: (BuildContext context) => LoginBloc(),
      ),
      BlocProvider<Bloc1>(
        create: (BuildContext context) => Bloc1(),
      ),
      BlocProvider<Bloc2>(
        create: (BuildContext context) => Bloc2(),
      ),
    ],
    child: child,
  );
}

// The navigation case provider is our own custom class. See its file for
// details.
Widget _wrapNavigationCases(Widget child) => NavigationCaseProvider(
      navigationCases: {
        "lifeWithGreenPage": greenPageNavigationCase,
      },
      child: child,
    );

/// Utility function that lets you apply multiple wrappers without having to
/// nest them.
///
/// Instead of writing:
///
/// `final app = fun1(fun2(fun3(const App)));`
///
/// You can write:
///
/// `final app = _applyWrappers([fun1, fun2, fun3], const App());`
///
/// Basically, this composes all the functions in a list. "Composing" means that
/// you take two functions f(x) and g(x), and make a new function that does
/// f(g(x)) all in one.
///
/// The body is very simple. "Reducing" a list lets us combine all the elements
/// based on some rule. (e) => f2(f1(e)) is a new function that applies f1 and
/// then f2 on some element. The new function then becomes the f1 that is
/// combined with the next function in the list.
T _applyWrappers<T>(List<T Function(T)> wrappers, T obj) =>
    wrappers.reduce((f1, f2) => ((e) => f2(f1(e))))(obj);
