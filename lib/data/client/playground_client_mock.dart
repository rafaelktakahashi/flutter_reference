import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_reference/data/client/playground_client.dart';
import 'package:flutter_reference/domain/entity/buyer.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/error/playground_client_error.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

/// A mock implementation of the real client.
///
/// Please read: In this reference architecture, we don't have a backend, so the
/// main PlaingroundClient does not make real requests.
///
/// This mock is provided as an example of how you can use temporary mocks in
/// your own project. The important part is implementing the main client and
/// overriding all methods. All methods should use @override to clearly
/// indicate that the method also exists in the real client.
///
/// In a repository, you can ask GetIt for an instance of this mocked client and
/// store it in a variable of PlaygroundClient.
class PlaygroundClientMock extends PlaygroundClient {
  List<Product> _mockProducts = List.from([
    const Product(
      id: "110",
      name: "Powder computer",
      description: "Finely ground computer.",
      amountInStock: 3,
      unit: "g",
      pricePerUnitCents: 799, // 7,99 €
    ),
    const Product(
      id: "190",
      name: "Paperback",
      description:
          "The backside of a sheet of paper (front side purchased separately).",
      amountInStock: 5,
      unit: "unit",
      pricePerUnitCents: 299,
    ),
    const Product(
      id: "210",
      name: "Green ideas",
      description:
          "Thought, concept or mental impression of the green variety.",
      amountInStock: 8,
      unit: "unit",
      pricePerUnitCents: 2599,
    ),
  ]);

  /// Fetch the list of products.
  /// This accept a boolean parameter [fail] as an example only. In pratice,
  /// your real parameters (like page number of a filter) would appear here.
  /// Use [fail]=true to cause an error to be returned, for demonstration
  /// purposes.
  @override
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
  @override
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

  // This data will appear in the page "List with details request". The bloc
  // demonstrates how to efficiently implement a list where each item needs an
  // additional request to get details.
  final List<BuyerDetails> _mockBuyerDetails = List.from(
    [
      BuyerDetails(
        identification: "12345678",
        address: "38 Hunters Grove, ROMFORD, RM5 2UH, ENGLAND",
        fullName: "Mikhail Kotliarov",
        accountEmail: "mkotl@playgroundmail.com",
        birthdate: DateTime(1998, 10, 22),
      ),
      BuyerDetails(
        identification: "12345890",
        address: "35 Glovers Fld, KELVEDON HATCH, BRENTWOOD CM15 0BD, ENGLAND",
        fullName: "Michael Swiftsmith",
        accountEmail: "mswift@playgroundmail.com",
        birthdate: DateTime(1996, 02, 20),
      ),
      BuyerDetails(
        identification: "12345012",
        address: "24 Woodberry Rd, WICKFORD SS11 8XG, ENGLAND",
        fullName: "Vanessa Flutman",
        accountEmail: "vflut@playgroundmail.com",
        birthdate: DateTime(2002, 12, 1),
      ),
    ],
  );

  /// Fetches a list of buyers with a limited amount of information.
  @override
  Future<Either<PlaygroundError, List<Buyer>>> fetchBuyers() async {
    await Future.delayed(const Duration(milliseconds: 700));

    return Right(
      _mockBuyerDetails
          .map((e) =>
              Buyer(identification: e.identification, fullName: e.fullName))
          .toList(),
    );
  }

  /// Fetches detailed information for a buyer by its identification.
  @override
  Future<Either<PlaygroundError, BuyerDetails>> fetchBuyerDetails(
    String identification,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1400));

    final buyerDetails = _mockBuyerDetails.firstWhereOrNull(
      (element) => element.identification == identification,
    );

    if (buyerDetails != null) {
      return Right(buyerDetails);
    } else {
      return Left(
        PlaygroundClientError(
            "MSG-1190", "Could not find buyer of id $identification",
            responseStatus: "404"),
      );
    }
  }
}
