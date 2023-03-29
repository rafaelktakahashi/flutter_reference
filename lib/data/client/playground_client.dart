import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/error/playground_client_error.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

/// Example of a Client.
/// In practice, a client should make requests to a remote server somewhere.
/// This one mocks its calls to pretend that a request is being made.
class PlaygroundClient {
  final List<Product> _mockProducts = List.from([
    const Product(
      id: "110",
      name: "Powder computer",
      description: "Finely ground computer.",
      stockAmount: 3,
      unit: "g",
    ),
    const Product(
      id: "190",
      name: "Paperback",
      description:
          "The backside of a sheet of paper (front side purchased separately).",
      stockAmount: 5,
      unit: "unit",
    ),
    const Product(
      id: "210",
      name: "Green ideas",
      description:
          "Thought, concept or mental impression of the green variety.",
      stockAmount: 8,
      unit: "unit",
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
    _mockProducts.add(product);
    return const Right(unit);
  }
}
