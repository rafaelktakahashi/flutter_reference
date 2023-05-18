// This file contains numerous controls, all with a similar theme, that appear
// in front of the map.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/map.dart';

int _containerBorderRadius = 7;
double _buttonBorderRadius = 7;

/// Container that renders in front of a map. This is intended to change styles
/// according to the map's style. The parent of this widget provides the theme
/// data, so that the widgets in this file don't need any style logic.
///
/// In general, you should avoid having if-elses for styles anywhere other than
/// in the pages. Pages are the only kind of widget that decides the style of
/// things, and the components (organisms, molecules and atoms) should render
/// well in multiple themes.
class _OverlayContainer extends StatelessWidget {
  final BorderRadius? borderRadius;
  final Widget child;
  const _OverlayContainer({
    super.key,
    this.borderRadius,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Apply border with the same color as the background, but without
        // transparency. If the background color is opaque, it'll look as though
        // there's no border.
        border: Border.all(
          color: Theme.of(context).colorScheme.background.withAlpha(0xff),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(_containerBorderRadius * 1.0),
        color: Theme.of(context).colorScheme.background,
      ),
      child: child,
    );
  }
}

/// A pair of buttons to increase and decrease map zoom.
class MapZoomControls extends StatelessWidget {
  final MapController? controller;

  const MapZoomControls({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return _OverlayContainer(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                controller?.zoomIn();
              },
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_buttonBorderRadius),
                    bottomLeft: Radius.circular(_buttonBorderRadius),
                  ),
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Icon(Icons.zoom_in),
            ),
            ElevatedButton(
              onPressed: () {
                controller?.zoomOut();
              },
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(_buttonBorderRadius),
                    bottomRight: Radius.circular(_buttonBorderRadius),
                  ),
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Icon(Icons.zoom_out),
            ),
          ],
        ),
      ),
    );
  }
}

class MapTypeControls extends StatelessWidget {
  final MapType mapType;
  final Function(MapType) onChange;
  MapTypeControls({
    super.key,
    required this.mapType,
    required this.onChange,
  });

  final List<MapType> _mapTypes = [
    MapType.roadmap,
    MapType.satellite,
    MapType.hybrid,
  ];

  @override
  Widget build(BuildContext context) {
    return _OverlayContainer(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ToggleButtons(
          onPressed: (index) {
            onChange(_mapTypes[index]);
          },
          isSelected:
              _mapTypes.map((mapType) => mapType == this.mapType).toList(),
          borderRadius: BorderRadius.all(Radius.circular(_buttonBorderRadius)),
          borderColor: Theme.of(context).colorScheme.onPrimary,
          children: _mapTypes
              .mapIndexed(
                (i, _) => Container(
                  // This padding only affects the sides
                  padding: const EdgeInsets.all(5),
                  child: Text(["Roadmap", "Satellite", "Hybrid"][i]),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
