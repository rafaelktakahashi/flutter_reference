import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A navigation case is a function that receives a build context that can be
/// used for navigating.
///
/// A navigation case can encapsulate any logic where you need to navigate to
/// multiple pages, or where you need some computation or bloc data to know
/// where to navigate.
///
/// Typically, navigating using the typical methods only lets you navigate to
/// one page. A NavigationCase can push multiple pages and do anything else
/// necessary using the context.
///
/// In this example project, we use this to redirect to a Green Page (of course,
/// that's an example). See the redirect_pages.dart file for more details, and
/// for other ways that redirection can be implemented. Overall, this is the
/// recommended way.
typedef NavigationCase = void Function(BuildContext context);

// Dart extensions can add things to classes without modifying them. This means
// you can add things to classes that aren't yours.
// This is what we're doing here.
// Adding methods and getters to BuildContext is useful for adding funcionality
// that can be accessed from any widget, anywhere.
//
// In this case, we're adding the ability to run a navigation case. Please refer
// to the documentation (page 'View Layer') for more details about navigation
// cases.
//
// Note that this file does not reference go_router; it works regardless of
// which navigation framework you use in your project.

/// Adds a method for running navigation cases.
///
/// Navigation cases are mainly a way of pushing multiple routes, or pushing
/// routes based on information coming from blocs.
/// This is not the only way to implement rules. Simple rules can exist in the
/// route, or even in the pages calling the routes.
///
/// This assumes the existence of go_router methods such as push() and pop().
extension NavigationCaseBuildContext on BuildContext {
  /// Runs a navigation case by name. If a navigation case doesn't exist for the
  /// specified name, this method does not do anything.
  ///
  /// This is a custom method added with an extension. The main reason why this
  /// receives a string (instead of a function) is to make it easier to use
  /// in the interop navigator. Native code can simply call the interop
  /// navigator informing the name of the navigation case that should run.
  ///
  /// If you think this is too complicated and not worth the effort, you can
  /// receive navigation cases here directly. (Navigation cases are functions).
  /// This would simplify the code significantly, and you wouldn't need the
  /// navigation case provider. However, that means you'll have to pass the
  /// navigation cases manually to this function every time.
  void runNavigationCase(String navigationCaseName) {
    // First we attempt to obtain the navigation case from the context (this
    // object). If we cannot, then we don't run anything.
    final runner = NavigationCaseProvider.maybeOf(this);

    if (runner == null) {
      // Navigation case provider wasn't found in the context.
      // Feel free to throw an exception instead if you prefer.
      return;
    }

    // The navigation cases that have been registered are stored in a map where
    // the keys are the names of each navigation case.
    final navCase = runner.navigationCases[navigationCaseName];

    if (navCase == null) {
      // A navigation case was not registered for the specified name.
      // Feel free to throw an exception instead if you prefer.
      return;
    }

    // Run the navigation case.
    // Navigation cases are functions that receive the context.
    // This object is a context.
    navCase(this);
    // Possible improvement: I have not implemented navigation case parameters.
    // The best way of doing that would be url-encoding parameters in the
    // name. I currently don't have a way of handling that.
    // ex.: routename/:id?someparam=1
  }
}

// NOTE: It would be easier to use the provider package, but I didn't want to
// add the dependency in this example project.
// You can feel free to use the provider package in your own implementation, and
// that should simplify things.
// See: https://pub.dev/packages/provider

class NavigationCaseProvider extends InheritedWidget {
  /// Navigation cases, keyed by name.
  /// The name of each navigation case can be used to run it.
  final Map<String, NavigationCase> navigationCases;

  const NavigationCaseProvider({
    super.key,
    required this.navigationCases,
    required super.child,
  });

  static NavigationCaseProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationCaseProvider>();
  }

  static NavigationCaseProvider of(BuildContext context) {
    final NavigationCaseProvider? result = maybeOf(context);
    assert(result != null, 'No NavigationCaseRunner found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(NavigationCaseProvider oldWidget) =>
      !const MapEquality().equals(navigationCases, oldWidget.navigationCases);
}
