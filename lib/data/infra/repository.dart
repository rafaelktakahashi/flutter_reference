import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/entity/playground_entity.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

/// Superclass for every repository in the application.
///
/// There's a reason why this interface doesn't have anything in it. We don't
/// actually want to restrict what each repository exposes as its API, because
/// an app may want to declare all sorts of methods in its repositories.
///
/// For example, a `HypotheticalRepository` could have methods for fetching,
/// adding, editing and deleting items whlie a different `OtherRepository` could
/// have completely different methods for listing, reordering and tagging a
/// fixed set of items. The point is, you usually can't find a set of methods
/// that every repository needs to have.
///
/// This somewhat negates the advantage of having an interface for repositories,
/// so this is purely organizational and likely to not be needed in practice.
/// If you decide that it makes sense to restrict each repository to one class
/// in your application and require certain methods like
/// `Future<Either<Error,List<T>>> fetchList(T filterLike);`,
/// you can add them here. That depends on how you intend to use your
/// repositories. See the `SimpleCrudRepository` down below for an example.
abstract class Repository {}

/// Example of a interface for repositories that you may want to use (if you
/// decide it makes sense). This reference architecture does not use this class.
///
/// Generally, this is recommended if you know for sure that all your
/// repositories will have the same methods with the same API. If you want
/// many repositories will different contracts, then enforcing this restriction
/// is likely to hinder development.
///
/// This could be useful for dependency injection; in your bloc, instead of
/// referencing a `PersonRepository` you could instead reference a
/// `SimpleCrudRepository<Person>` and have access to these methods.
abstract class SimpleCrudRepository<T extends PlaygroundEntity> {
  // (You'd have to implement your own standardized way of filtering lists.)
  Future<Either<PlaygroundError, List<T>>> fetchList(/** Possible filter */);

  // (It would be important for every PlaygroundEntity to expose the same
  // id property. If you don't have that, then restricting this method signature
  // becomes more difficult.)
  Future<Either<PlaygroundError, T>> fetchById(String id);

  Future<Either<PlaygroundError, T>> update(T entity);

  Future<Either<PlaygroundError, T>> deleteById(String id);
}
