import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/map.dart';
import 'package:flutter_reference/view/UI/molecules/map_overlays.dart';
import 'package:flutter_reference/view/UI/themes/theme_data.dart';
import 'package:flutter_reference/view/templates/map_with_overlays_template.dart';

/// Page that shows a Google Maps map that can be controlled by other widgets
/// that render on top.
///
/// Controlling the map from other widgets is done using a controller. Some
/// considerations:
/// - Using a controller is unlike the declarative style of most widgets in
/// Flutter. It's like a react-native ref, where you obtain a reference to an
/// object and call its methods, without controlling things through the state.
/// - Some things like adding and removing polygons in the map should be done
/// using the state (or a bloc), not the controller. Your map widget should
/// receive domain classes and internally convert them to Google Maps' objects.
/// Always make sure to keep ids the same and cache as much as possible to avoid
/// performance problems. Test on a lower-end device in release mode.
/// - It's possible that you will need to access the controller from another
/// page (for example, a settings modal page where the user can set the default
/// initial location or something else that needs map interaction). If you need
/// that, you should make a bloc that's dedicated to caching the controller.
/// Because the controller uses a programmatic API (you call methods in it) and
/// not declarative (like other blocs that have their state), it is okay to
/// simply expose the map controller in the bloc's state and call methods in it.
///
/// We need to remember the controller simply because we have widgets on top of
/// the map that can control it. In your own app, it is easier to simply use
/// Google Maps' built-in controls, but that doesn't let you customize styles.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController? controller;
  MapType currentMapType = MapType.satellite;

  @override
  Widget build(BuildContext context) {
    return MapWithOverlaysTemplate(
      title: "Maps and overlays",
      background: PlaygroundMap(
        initialLatitude: 37.43296265331129,
        initialLongitude: -122.08832357078792,
        mapType: currentMapType,
        controllerReference: (controller) {
          setState(() {
            this.controller = controller;
          });
        },
      ),
      topLeft: MapTypeControls(
        mapType: currentMapType,
        onChange: (mapType) {
          setState(() {
            currentMapType = mapType;
          });
        },
      ),
      // These zoom controls are provided as an example of what you _can_ do
      // with a controller; zoom buttons aren't so useful because you can use
      // Google Maps' built-in zoom buttons and also the zoom gesture. However,
      // you could also use the map controller to move the map to certain
      // locations, or to obtain the map's current location on screen, or show
      // a marker's info window, take a screenshot and so on.
      bottomRight: MapZoomControls(controller: controller),
      // Use a light theme when the map is rendering in roadmap mode.
      // This ensures that only the page (and not other types of widgets) decide
      // the styles of things. Organisms, molecules and atoms should render
      // properly regardless of the current theme.
      overlayTheme:
          currentMapType == MapType.roadmap ? lightMapTheme : darkMapTheme,
    );
  }
}
