import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/organisms/app_lifecycle/app_lifecycle_counter.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

/// Page that demonstrates a declarative use of the WidgetsBindingObserver
/// class to keep track of the app's state.
class AppLifecyclePage extends StatelessWidget {
  const AppLifecyclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleTemplate(
      title: "App Lifecycle Demo",
      child: Center(
        child: AppLifecycleCounter(),
      ),
    );
  }
}
