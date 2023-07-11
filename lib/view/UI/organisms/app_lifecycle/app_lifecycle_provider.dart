import 'package:flutter/material.dart';

/// Provides a listener for when the app's lifecycle state changes.
/// This provides the same functionality as the WidgetsBindingObserver mixin,
/// but usable with a declarative syntax.
class AppLifecycleProvider extends StatefulWidget {
  const AppLifecycleProvider({
    super.key,
    required this.onStateChanged,
    required this.child,
  });

  final void Function(AppLifecycleState) onStateChanged;
  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return _AppLifecycleProviderState();
  }
}

/// This state does not contain any variables in it; in fact, this widget is
/// stateful only for the purpose of using WidgetsBindingObserver.
class _AppLifecycleProviderState extends State<AppLifecycleProvider>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    super.didChangeAppLifecycleState(appLifecycleState);

    widget.onStateChanged(appLifecycleState);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
