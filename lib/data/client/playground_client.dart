import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/error/playground_client_error.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

/// Example of a Client.
/// Of course, a real client should make requests to a remote server somewhere.
/// This one mocks its calls to pretend that a request is being made. It does
/// not persist any changes.
///
/// IMPORTANT! Currently, this client is not being used. Instead, we're making
/// native calls to demonstrate a request through the bridge. The repository
/// decides what client to use.
class PlaygroundClient {
  List<Product> _mockProducts = List.from([
    const Product(
      id: "110",
      name: "Powder computer",
      description: "Finely ground computer.",
      stockAmount: 3,
      unit: "g",
      pricePerUnitCents: 799, // 7,99 €
    ),
    const Product(
      id: "190",
      name: "Paperback",
      description:
          "The backside of a sheet of paper (front side purchased separately).",
      stockAmount: 5,
      unit: "unit",
      pricePerUnitCents: 299,
    ),
    const Product(
      id: "210",
      name: "Green ideas",
      description:
          "Thought, concept or mental impression of the green variety.",
      stockAmount: 8,
      unit: "unit",
      pricePerUnitCents: 2599,
    ),
  ]);

  /// Fetch the list of products.
  /// This accept a boolean parameter [fail] as an example only. In pratice,
  /// your real parameters (like page number of a filter) would appear here.
  /// Use [fail]=true to cause an error to be returned, for demonstration
  /// purposes.
  Future<Either<PlaygroundError, List<Product>>> fetchProducts({
    bool fail = false,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (fail) {
      return const Left(
        PlaygroundClientError(
          "MGS-0001",
          "There was an error fetching the list of products.",
          responseStatus: "500",
        ),
      );
    }
    return Right(_mockProducts);
  }

  /// Save a new product. It'll be added to the end of the list.
  Future<Either<PlaygroundError, Unit>> saveProduct(Product product) async {
    await Future.delayed(const Duration(seconds: 1));
    // Make a new list to avoid any possible problems with references.
    // Don't worry about this; in a real app, you'll be fetching fresh data
    // every time. This ensures that the list is a different reference after
    // adding a product, which should be the case automatically when you fetch
    // data remotely.
    _mockProducts = _mockProducts.followedBy([product]).toList();
    return const Right(unit);
  }
}
