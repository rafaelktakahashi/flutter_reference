import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/icon_with_label.dart';

/// Shows a simple message at the center of the screen, with an icon, and
/// optionally a button.
///
/// Under the error message, this template displays a button that goes back
/// to the previous page; you may also specify `onReturn` to override what that
/// button does.
class FullscreenMessageTemplate extends StatelessWidget {
  final Widget centerWidget;
  final Color? backgroundColor;
  final TextButton? actionButton;

  const FullscreenMessageTemplate({
    super.key,
    required this.centerWidget,
    this.backgroundColor,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
    );
  }
}
