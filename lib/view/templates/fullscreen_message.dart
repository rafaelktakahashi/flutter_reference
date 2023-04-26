import 'package:flutter/material.dart';

/// Shows a simple message at the center of the screen, with an icon, and
/// optionally a button.
///
/// Under the error message, this template displays a button that goes back
/// to the previous page; you may also specify `onReturn` to override what that
/// button does.
class FullscreenMessageTemplate extends StatelessWidget {
  final Widget centerWidget;
  final Color? backgroundColor;
  final Widget? actionButton;

  const FullscreenMessageTemplate({
    super.key,
    required this.centerWidget,
    this.backgroundColor,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor ?? Colors.white24,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.square(
                  dimension: 1,
                ),
                centerWidget,
                actionButton ??
                    const SizedBox.square(
                      dimension: 1,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
