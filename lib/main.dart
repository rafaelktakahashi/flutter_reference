import 'package:flutter_reference/config/dependency_injection.dart';
import 'package:flutter_reference/view/infra/app.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register dependencies. This needs to be after the call to
  // ensureInitialized because some classes open the method channel.
  configureDependencies();

  runApp(const App());
}
