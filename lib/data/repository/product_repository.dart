import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/data/client/megastore_client.dart';
import 'package:flutter_reference/domain/error/megastore_error.dart';

/// Repository for products.
/// Remember always that repositories encapsulate (=hide) where the data is
/// coming from.
class ProductRepository {
  /// Reference to the Megastore backend client.
  final MegastoreClient client;

  const ProductRepository(this.client);

  Future<Either<MegastoreError, List<Product>>> fetchProduct() async {
    return client.fetchProducts();
  }

  Future<Either<MegastoreError, Unit>> saveProduct(Product product) async {
    return client.saveProduct(product);
  }
}
