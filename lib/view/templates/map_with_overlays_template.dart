import 'package:flutter/material.dart';

/// Template dedicated for the map page, with one component at the background
/// and multiple components above, each of which covers the screen partially.
///
/// Remember that templates only decide the layout of pages. They do not know
/// the exact widgets that will appear on screen, and do not know anything of
/// their logic. The widgets you see on the map screen have a lot of logic
/// related to the map controller, but this template does not know that.
///
/// Templates can also change where the components render based on the screen
/// size and orientation. This would be a nice place to experiment with that.
class MapWithOverlaysTemplate extends StatelessWidget {
  final String title;
  final Widget background;
  final Widget? topLeft;
  final Widget? topRight;
  final Widget? bottomLeft;
  final Widget? bottomRight;

  /// Theme specifically for the controls that render above the map.
  final ThemeData? overlayTheme;
  const MapWithOverlaysTemplate(
      {super.key,
      required this.title,
      required this.background,
      this.topLeft,
      this.topRight,
      this.bottomLeft,
      this.bottomRight,
      this.overlayTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Stack(
        children: [
          background,
          _buildOverlays(context),
        ],
      ),
    );
  }

  /// Build the components that render on top of the background.
  Widget _buildOverlays(BuildContext context) {
    return Theme(
      data: overlayTheme ?? Theme.of(context),
      child: SafeArea(
        child: Padding(
          // Padding for the overlays only. The map renders without padding.
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Child that renders at the top of the screen: a row of widgets.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [topLeft ?? _spacer(), topRight ?? _spacer()],
              ),
              // Child that renders at the bottom of the screen: another row.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [bottomLeft ?? _spacer(), bottomRight ?? _spacer()],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _spacer() => const SizedBox(height: 1, width: 1);
}
