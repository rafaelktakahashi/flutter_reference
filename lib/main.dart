import 'package:flutter_reference/config/dependency_injection.dart';
import 'package:flutter_reference/data/bridge/channel_bridge.dart' as bridge;
import 'package:flutter_reference/view/infra/app.dart';
import 'package:flutter/material.dart';

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

  runApp(const App());
}
