// Navigation cases for showcasing route redirection.
// In this example project, I only have this navigation case, but even in a real
// project, most routes don't need a navigation case.
//
// Navigation cases are only for situations where you need to navigate to an
// unknown number of pages based on certain logic. You can even read the state
// of one or more blocs to take that decision.
//
// Navigation cases are registered in the same way as you register blocs, using
// a provider (the provider is our own custom code in nav_case_extension.dart).
// This project uses go_router, but navigation pages are not part of go_router.

// ignore_for_file: prefer_function_declarations_over_variables
// The linter typically complains that declaring functions as variables is bad
// and we should declare them with the syntax for functions instead, but there
// isn't a way to do that while conforming to a typedef.
// NavigationCase is a typedef of a function.

// After you have written the contents of this file once, you no longer need to
// worry about it.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/life/life_bloc.dart';
import 'package:flutter_reference/view/nav/nav_case_extension.dart';
import 'package:go_router/go_router.dart';

/// Navigation case for navigating to the life page. When the life bloc is not
/// running, this navigation case also pushes the green page on top of the life
/// page.
///
/// This demonstrates how a navigation case can use the state of one or more
/// blocs to change navigation.
final NavigationCase greenPageNavigationCase = (context) {
  // It's theoretically possible to make this an async function, but I do not
  // recommend that. Navigating asynchronously will most certainly lead to
  // delays in UI that the user does not expect.
  final lifeState = context.read<LifeBloc>().state;

  // This navigation case goes to the life page. After that, it checks if the
  // life simulation is running, and if it's not, we show a green page on top
  // of that.
  context.push('/life');

  if (!lifeState.isAutostepping) {
    context.push('/redirect_green');
  }

  // I know that this code is relatively simple, but you could add a lot more
  // complicated logic here. However, I don't recommend doing asynchronous
  // operations here; use blocs with bloc listeners for that.
  //
  // A common use case would be storing flags in a bloc to check if a route is
  // being access for the first time. I don't have that implemented here, but
  // you can check the settings bloc to see how flags can be stored in local
  // storage and yet be available synchronously in the bloc's state.
};

// You can write other related navigation cases in the same file.
// Generally speaking, there shouldn't be that many navigation cases, and you
// should avoid writing navigation cases for simple things. This is reserved for
// complicated logic. For example, if all you want is to initialize a bloc, you
// can put that logic in the router's builder.
