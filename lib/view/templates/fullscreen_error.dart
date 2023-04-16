import 'package:flutter/material.dart';

/// Shows a simple error message at the center of the screen.
/// In a real app, you'd style this template accordingly.
///
/// Under the error message, this template displays a button that goes back
/// to the previous page; you may also specify `onReturn` to override what that
/// button does.
class FullscreenErrorTemplate extends StatelessWidget {
  final String message;
  final Function? onReturn;

  const FullscreenErrorTemplate(
      {super.key, required this.message, this.onReturn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Error",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(message),
            TextButton(
              onPressed: () {
                if (onReturn != null) {
                  onReturn?.call();
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text("Go back"),
            )
          ],
        ),
      ),
    );
  }
}
