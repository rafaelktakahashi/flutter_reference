import 'package:flutter_reference/data/bridge/channel_bridge.dart';
import 'package:flutter_reference/data/infra/repository.dart';

abstract class InteropRepository extends Repository {
  /// A reference to a port in our bridge.
  /// The port has the name specified in this constructor. The name should
  /// be decided by the concrete class.
  /// The port is private because the concrete class shouldn't need to worry
  /// about interacting with our bridge. If we ever change the bridge's API,
  /// only this class would need to change and not the concrete repositories.
  late FlutterMethodChannelBridgePort _port;

  // In this reference project, we only have Flutter repositories making calls
  // to repository methods exposed from the native side, but making calls the
  // other way around works the same because our channel bridge is symmetrical.

  InteropRepository(final repositoryName) {
    // Open the port with the specified name.
    // It's fine to open multiple ports in our bridge; all of them share one
    // method channel.
    // Also, we don't need to remember the repository name because that
    // information is available in the port.
    _port = openBridgePort("repository/$repositoryName");

    // If it seems like all this class does is encapsulate the bridge without
    // simplifying any of the work, that's mostly true. The separation is only
    // organizational. If our bridge's API changes, we don't want to edit every
    // repository in the application, just this one.
  }

  /// Method available for the implementations of the interop repository, to
  /// register methods that are available to be called from the native side of
  /// the bridge.
  void exposeMethod(String name, dynamic Function(dynamic) handler) {
    // If you want, you can restrict what kind of function is allowed here,
    // perhaps using a generic parameter
    // I'm not doing that, though. That's because we
  }

  /// Method available for the implementations
  Future<dynamic> callNativeMethod(String methodName,
      [dynamic arguments]) async {
    // Unfortunately, it is not possible to automatically generate the correct
    // type here. That's for a technical reason and for an architectural reason.
    // - The technical reason is that even if we were to add a generic parameter
    // <T extends PlaygroundEntity> in this class and make this method return a
    // T, we wouldn't be able to create a T from a json because that
    // functionality is exposed through a factory constructor in T. Also,
    // requiring a `PlaygroundEntity fromJson(dynamic json)` in PlaygroundEntity
    // would add a lot more boilerplate in each entity.
    // - The architectural reason is that we don't know what the format of this
    // call is. If we only ever worked with CRUD operations for every single
    // entity, it could make sense to restrict what functions could be called;
    // however, an app may routinely work with all sorts of inputs and outputs
    // in its repositories, and we may want to create repositories that work
    // with more than one type of entity. Thus, it may not always be worth the
    // effort to restrict the repositories' contract. That's also the reason
    // why the repository's superclass doesn't have anything in it.
    return await _port.call(methodName, arguments: arguments);
  }
}
