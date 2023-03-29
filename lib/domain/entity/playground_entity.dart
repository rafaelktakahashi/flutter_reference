import 'package:freezed_annotation/freezed_annotation.dart';

/// Superclass for all entities in this project.
/// Every entity in the project should be serializable, but there's not much
/// we can do to require a specific factory. We do, however, require an
/// implementation of toJson(), and that ought to be enough to ensure nobody
/// forgets to make the classes serializable.
abstract class PlaygroundEntity {
  const PlaygroundEntity();

  Map<String, dynamic> toJson();
}
