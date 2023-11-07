import 'package:dartz/dartz.dart';
import 'package:flutter_reference/domain/entity/buyer.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

/// Example of a Client that points to the app's backend server.
///
/// IMPORTANT! Currently, this client does not point to any backend. There's no
/// backend in this example architecture. Some repositories do use this client,
/// but they do so by getting an instance of the mocked client. See the
/// PlaygroundClientMock.
class PlaygroundClient {
  /// Fetch the list of products.
  /// This accepts a boolean parameter [fail] as an example only. In pratice,
  /// your real parameters (like page number of a filter) would appear here.
  /// Use [fail]=true to cause an error to be returned, for demonstration
  /// purposes.
  Future<Either<PlaygroundError, List<Product>>> fetchProducts({
    bool fail = false,
  }) async {
    throw UnimplementedError(
        "The PlaygroundClient does not have implemented methods.");
  }

  /// Save a new product. It'll be added to the end of the list.
  Future<Either<PlaygroundError, Unit>> saveProduct(Product product) async {
    throw UnimplementedError(
        "The PlaygroundClient does not have implemented methods.");
  }

  /// Fetches a list of buyers with a limited amount of information.
  Future<Either<PlaygroundError, List<Buyer>>> fetchBuyers() async {
    throw UnimplementedError(
        "The PlaygroundClient does not have implemented methods.");
  }

  /// Fetches detailed information for a buyer by its identification.
  Future<Either<PlaygroundError, BuyerDetails>> fetchBuyerDetails(
    String identification,
  ) async {
    throw UnimplementedError(
        "The PlaygroundClient does not have implemented methods.");
  }
}
