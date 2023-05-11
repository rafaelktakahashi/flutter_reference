import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

/// This is our map controller that wraps Google Maps' controller.
///
/// An instance of this controller can be used to programmatically manipulate
/// the map, controlling zoom, current location, type of map, etc. If you don't
/// need to control the map, then you don't need to store this controller.
///
/// We _could_ directly expose Google Maps' controller here, but it's better
/// to wrap it to reduce coupling. It's not good to have too many widgets that
/// directly depend on a specific library.
///
/// The type of map (roadmap of satellite) is not controller using this
/// controller.
///
/// It's up to you how you want to use this controller. You could keep this in
/// a page's state, or put this instance in a bloc if you need to interact with
/// it from other pages.
abstract class MapController {
  Future<void> zoomIn([int steps = 1]);
  Future<void> zoomOut([int steps = 1]);
  Future<void> goTo(double latitude, double longitude);
  Future<bool> goToCurrentLocation();
}

/// Type of map to use. This variable is used declaratively, not with functions.
///
/// This is a wrapper over Google Maps' class, so that the classes using this
/// widget don't have to directly reference a specific library.
enum MapType {
  satellite,
  roadmap,
  hybrid,
}

/// Interactive map. Currently uses Google Maps.
///
/// This widget requires using a controller that is provided using a callback.
/// Note that this kind of controller is unusual in Flutter and in other
/// reactive frameworks. Typically we prefer controlling everything
/// declaratively. This widget is an example of how this less usual approach can
/// work. Other molecules (that render on top of the map) use a reference to the
/// controller to manipulate the map.
class PlaygroundMap extends StatelessWidget {
  final MapType mapType;
  final double initialLatitude;
  final double initialLongitude;
  final void Function(MapController)? controllerReference;

  const PlaygroundMap({
    super.key,
    required this.mapType,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.controllerReference,
  });

  @override
  Widget build(BuildContext context) {
    return gmaps.GoogleMap(
      onMapCreated: (googleMapController) {
        // When Google Maps gives us its controller (only once), we wrap it and
        // pass it on to this widget's parent. This way, the classes using this
        // widget don't need to directly reference Google Maps.
        controllerReference?.call(
          _MapControllerGoogleMapsWrapper(googleMapController),
        );
      },
      initialCameraPosition: gmaps.CameraPosition(
        target: gmaps.LatLng(initialLatitude, initialLongitude),
        zoom: 20,
      ),
      compassEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapType: _translateMapType(mapType),
      // Typically, the Google logo renders very near to the map's edge, but
      // since our map covers the whole screen, it could render behind the
      // navigation bar. This ensures that the Logo renders where it's visible.
      padding: MediaQuery.of(context).padding,
    );
  }

  gmaps.MapType _translateMapType(MapType mapType) {
    switch (mapType) {
      case MapType.satellite:
        return gmaps.MapType.satellite;
      case MapType.hybrid:
        return gmaps.MapType.hybrid;
      case MapType.roadmap:
      default:
        return gmaps.MapType.normal;
    }
  }
}

class _MapControllerGoogleMapsWrapper implements MapController {
  final gmaps.GoogleMapController _gmapController;

  const _MapControllerGoogleMapsWrapper(this._gmapController);

  @override
  Future<void> goTo(double latitude, double longitude) async {
    return _gmapController.animateCamera(
      gmaps.CameraUpdate.newLatLng(
        gmaps.LatLng(latitude, longitude),
      ),
    );
  }

  @override
  Future<bool> goToCurrentLocation() async {
    // TODO: implement goToCurrentLocation
    // This requires getting the user's current location, which isn't so simple.
    // We'll have to create a service and then access it directly from a widget,
    // which is allowed in rare cases. Another option is putting that data in
    // a bloc that remembers the user's location and the request's state.
    throw UnimplementedError();
  }

  @override
  Future<void> zoomIn([int steps = 1]) async {
    return _gmapController
        .animateCamera(gmaps.CameraUpdate.zoomBy(steps.toDouble()));
  }

  @override
  Future<void> zoomOut([int steps = 1]) async {
    return _gmapController
        .animateCamera(gmaps.CameraUpdate.zoomBy(steps.toDouble() * -1));
  }
}
