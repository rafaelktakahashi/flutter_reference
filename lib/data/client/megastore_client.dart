import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/error/megastore_error.dart';

/// Example of a Client.
/// In practice, a client should make requests to a remote server somewhere.
/// This one mocks its calls to pretend that a request is being made.
class MegastoreClient {
  final List<Product> _mockProducts = List.from([
    const Product("110", "Powder computer", "Finely ground computer.", 3, "g"),
    const Product("190", "Game controller",
        "Device for interacting with a videogame console.", 5, "unit"),
    const Product("210", "Green ideas",
        "Thought or suggestion of the green variety.", 8, "unit"),
  ]);

  /// Fetch the list of products.
  /// This fetch does not accept any parameters. If it did (for example,
  /// page number or a filter), the parameters would appear here.
  Future<Either<MegastoreError, List<Product>>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return Right(_mockProducts);
  }

  /// Save a new product. It'll be added to the end of the list.
  Future<Either<MegastoreError, Unit>> saveProduct(Product product) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockProducts.add(product);
    return const Right(unit);
  }
}
