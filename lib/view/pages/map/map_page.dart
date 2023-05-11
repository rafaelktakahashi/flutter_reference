import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/map.dart';
import 'package:flutter_reference/view/templates/map_with_overlays_template.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MapWithOverlaysTemplate(
      title: "Maps and overlays",
      background: PlaygroundMap(
        initialLatitude: 37.43296265331129,
        initialLongitude: -122.08832357078792,
        mapType: MapType.hybrid,
        controllerReference: (controller) => {},
      ),
      topLeft: IconButton(onPressed: () {}, icon: const Icon(Icons.zoom_out)),
      topRight: IconButton(onPressed: () {}, icon: const Icon(Icons.zoom_in)),
      bottomRight:
          IconButton(onPressed: () {}, icon: const Icon(Icons.gps_fixed)),
    );
  }
}
