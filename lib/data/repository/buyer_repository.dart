import 'package:flutter_reference/data/client/playground_client.dart';
import 'package:flutter_reference/data/client/playground_client_mock.dart';
import 'package:flutter_reference/domain/entity/buyer.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

/// Repository for buyers.
class BuyerRepository {
  /// Reference to the Playground backend client.
  ///
  /// PlaygroundClientMock extends PlaygroundClient, so you can get an instance
  /// of the mocked client and use it as if it were the real client.
  /// Switching between the real client and the mock is just a matter of changing
  /// which class you get with GetIt here.
  final PlaygroundClient client = GetIt.I.get<PlaygroundClientMock>();

  // A repository does not necessarily need to work with only one type of
  // entity. A repository groups together operations that are logically related.
  // This one simply makes the call to the client.
  //
  // If you ever need to make class conversions, you should do it here. If the
  // remote API uses a very different entity, you can create DTOs for that
  // client and then make the conversions in the repository.
  //
  // Check the product repository for an example that uses the bridge to get
  // data from native code.

  Future<Either<PlaygroundError, List<Buyer>>> fetchBuyers() async {
    return client.fetchBuyers();
  }

  Future<Either<PlaygroundError, BuyerDetails>> fetchBuyerDetails(
    String identification,
  ) async {
    return client.fetchBuyerDetails(identification);
  }
}
