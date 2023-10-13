import 'package:dartz/dartz.dart';
import 'package:flutter_reference/data/infra/interop_repository.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/error/playground_client_error.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

/// Repository for products.
/// Remember always that repositories encapsulate (=hide) where the data is
/// coming from.
class ProductRepository extends InteropRepository {
  /// This specific repository could, but does not use the PlaygroundClient
  /// class. Instead, we get data from native code.

  // When using an interop repository, there must be a corresponding repository
  // in native code that also uses the same name.
  ProductRepository() : super("product");

  /// The [fail] parameter is just an example. In real code,
  /// the parameters would probably be something like a page number or a
  /// filter.
  Future<Either<PlaygroundError, List<Product>>> fetchProduct({
    bool fail = false,
  }) async {
    // This is in case you want to use the native Flutter implementation:
    // return client.fetchProducts(fail: fail);

    // Right now this project is configured to call the corresponding
    // item on the other side of the bridge:
    if (fail) {
      // Of course, "fail" is a mock parameter.
      return const Left(
        PlaygroundClientError("0010", "Induced error.", responseStatus: "0"),
      );
    }
    final result = await super.callNativeMethod("fetchProducts");

    if (result is List) {
      // These safety checks could probably be improved, especially when
      // casting the list.
      try {
        final castResult = result.map((e) => Product.fromJson(e));
        return Right(castResult.toList());
      } on Error catch (_) {
        return const Left(
          PlaygroundClientError(
            "0015",
            "Error casting item in response.",
            responseStatus: "0",
          ),
        );
      }
    } else {
      return const Left(
        PlaygroundClientError(
          "0015",
          "Error casting response to list.",
          responseStatus: "0",
        ),
      );
    }

    // Any processing that needs to be done on the data happens here in the
    // repository.
  }

  Future<Either<PlaygroundError, Unit>> saveProduct(Product product) async {
    try {
      // The parameters that we send here must match what the native code
      // is expecting to receive. In this case, it's an object with a field
      // named product, containing the product as a json.
      await super.callNativeMethod(
        "addProduct",
        {"product": product.toJson()},
      );
      return const Right(unit);
    } catch (exception) {
      return const Left(
        PlaygroundClientError(
          "0199",
          "Error saving product natively.",
          // Presumably, you'll have this information in a real app:
          responseStatus: "0",
        ),
      );
    }
  }
}
