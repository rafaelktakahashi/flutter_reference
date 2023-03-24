import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/data/client/megastore_client.dart';
import 'package:flutter_reference/domain/error/megastore_error.dart';
import 'package:get_it/get_it.dart';

/// Repository for products.
/// Remember always that repositories encapsulate (=hide) where the data is
/// coming from.
class ProductRepository {
  /// Reference to the Megastore backend client.
  final MegastoreClient client = GetIt.I.get<MegastoreClient>();

  ProductRepository();

  /// The [fail] parameter is just an example. In real code,
  /// the parameters would probably be something like a page number or a
  /// filter.
  Future<Either<MegastoreError, List<Product>>> fetchProduct({
    bool fail = false,
  }) async {
    return client.fetchProducts(fail: fail);
    // If you want to do any kind of processing, such as converting the classes,
    // you can do it here by calling a map or flatmap on the Either that's
    // returned by the client.
  }

  Future<Either<MegastoreError, Unit>> saveProduct(Product product) async {
    return client.saveProduct(product);
  }
}
