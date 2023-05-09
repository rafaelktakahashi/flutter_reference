import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Template for a page that renders in a modal.
/// Whatever page uses this template must be rendered in a transparent route.
class ModalTemplate extends StatelessWidget {
  final String title;
  final Widget child;

  const ModalTemplate({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // This gesture detector covers the entire screen, and lets the user
    // dismiss the modal by touching outside of it.
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      // It seems I need a container with non-null color to make the gesture
      // work, but I don't know why. Maybe colorless containers let touches fall
      // through?
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        // Don't let the modal overlap with the status bar.
        child: SafeArea(
          child: Center(
            // Limit the modal's size (makes a difference in large screens).
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 600,
                maxWidth: 600,
              ),
              // Don't take up the whole screen, even on small devices.
              child: Padding(
                padding: const EdgeInsets.all(10),
                // Override the gesture detector outside. This gesture doesn't
                // need to do anything, it just has to disable the outer
                // gesture detector.
                child: GestureDetector(
                  onTap: () {},
                  // Round the modal's corners.
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    // This is a blurred container. It doesn't really have to
                    // do with app functionality, it's just here to show that
                    // this screen can be transparent if needed.
                    child: TransparentContainer(
                      // Override the child's scaffold color, because the
                      // blurred container already applies the tint.
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          scaffoldBackgroundColor: Colors.transparent,
                        ),
                        child: Scaffold(
                          appBar: AppBar(title: Text(title)),
                          body: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransparentContainer extends StatelessWidget {
  const TransparentContainer({
    Key? key,
    required this.child,
    this.minHeight = 0,
    this.minWidth = 0,
    this.borderWidth = 0,
    this.borderRadius = 0,
    this.onTap,
  }) : super(key: key);

  // When using minHeight, provide minWidth as well.
  final double minHeight;

  // When using minWidth, provide minHeight as well.
  final double minWidth;
  final VoidCallback? onTap;
  final double borderWidth;
  final double borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      constraints: minWidth != 0
          ? BoxConstraints(
              minHeight: minHeight,
              minWidth: minWidth,
            )
          : null,
      decoration: BoxDecoration(
        border: borderWidth > 0
            ? Border.all(
                color: Theme.of(context).colorScheme.background.withAlpha(0xff),
                width: borderWidth,
              )
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        // Use an opaque color when a gradient is provided.
        color: Theme.of(context).colorScheme.background.withAlpha(0xff),
      ),
      child: child,
    );

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        // This will blur anything behind this rectangle. Always test if things
        // are actually blurred; some components (e.g. maps) may not be affected
        // by blurred widgets in front of them.
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: container,
        ),
      ),
    );
  }
}
