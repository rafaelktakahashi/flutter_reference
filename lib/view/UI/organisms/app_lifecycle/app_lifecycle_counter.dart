import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/organisms/app_lifecycle/app_lifecycle_provider.dart';

/// Widget that renders counters that increment whenever the app lifecycle
/// changes.
///
/// I suspect that the detached case will never occur because of the way this
/// example app is built.
class AppLifecycleCounter extends StatefulWidget {
  const AppLifecycleCounter({super.key});

  @override
  State<AppLifecycleCounter> createState() {
    return _AppLifecycleCounterState();
  }
}

class _AppLifecycleCounterState extends State<AppLifecycleCounter> {
  int resumedCounter = 0;
  int inactiveCounter = 0;
  int pausedCounter = 0;
  int detachedCounter = 0;
  int hiddenCounter = 0;

  // Strings that will render on screen, at most 10 at a time. Initialize with
  // 10 empty lines.
  List<String> logLines = List.filled(10, "");

  String _currentTime() {
    final h = DateTime.now().hour.toString().padLeft(2, '0');
    final m = DateTime.now().minute.toString().padLeft(2, '0');
    final s = DateTime.now().second.toString().padLeft(2, '0');
    final ms = DateTime.now().millisecond.toString().padLeft(3, '0');
    return "$h:$m:$s.$ms";
  }

  @override
  Widget build(BuildContext context) {
    return AppLifecycleProvider(
      onStateChanged: (state) {
        setState(() {
          // Increment the corresponding counter and also add a line in this
          // page's log.
          String log = _currentTime();
          switch (state) {
            case AppLifecycleState.resumed:
              resumedCounter++;
              log = "$log - App resumed";
              break;
            case AppLifecycleState.inactive:
              inactiveCounter++;
              log = "$log - App became inactive";
              break;
            case AppLifecycleState.paused:
              pausedCounter++;
              log = "$log - App was paused";
              break;
            case AppLifecycleState.detached:
              detachedCounter++;
              log = "$log - App was detached";
              break;
            case AppLifecycleState.hidden:
              hiddenCounter++;
              log = "$log - App was hidden";
              break;
          }
          // Add a new line to the log, but only keep the last ten.
          logLines =
              [...logLines, log].reversed.take(10).toList().reversed.toList();
        });
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Resumed: $resumedCounter"),
            Text("Inactive: $inactiveCounter"),
            Text("Paused: $pausedCounter"),
            Text("Detached: $detachedCounter"),
            Text("Hidden: $hiddenCounter"),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(logLines.join("\n")),
            ),
          ],
        ),
      ),
    );
  }
}
