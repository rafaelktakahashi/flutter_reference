import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_reference/data/client/playground_client.dart';
import 'package:flutter_reference/data/service/local_storage_service.dart';
import 'package:flutter_reference/data/service/platform_select.dart';
import 'package:flutter_reference/data/service/step_up_auth_service.dart';
import 'package:flutter_reference/domain/entity/buyer.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/error/playground_client_error.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';
import 'package:get_it/get_it.dart';

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
///
/// This class also provides a step-up interceptor. See the readme for more.
class PlaygroundClientMock extends PlaygroundClient {
  // Use only from the _makeRequest method. Do not use in other methods.
  final _mockHttpClient = _FakeHttpClient();

  /// Fetch the list of products.
  /// This accepts a boolean parameter [fail] as an example only. In pratice,
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
          "Error induced by fail flag.",
          responseStatus: "500",
        ),
      );
    }

    return (await _makeRequest("GET", "/products")).flatMap((dyn) {
      try {
        final parsed = dyn as List<Product>;
        return Right(parsed);
      } catch (e) {
        return Left(PlaygroundClientError(
          "MGS-0099",
          "Error parsing the products list.",
          responseStatus: "0",
          nestedException: e is Exception ? e : null,
        ));
      }
    });
  }

  /// Save a new product. It'll be added to the end of the list.
  @override
  Future<Either<PlaygroundError, Unit>> saveProduct(Product product) async {
    await Future.delayed(const Duration(seconds: 1));
    await _makeRequest("POST", "/products", body: {"product": product});
    return const Right(unit);
  }

  /// Fetches a list of buyers with a limited amount of information.
  @override
  Future<Either<PlaygroundError, List<Buyer>>> fetchBuyers() async {
    await Future.delayed(const Duration(milliseconds: 700));

    final response = await _makeRequest("GET", "/buyers");

    return response.flatMap<List<BuyerDetails>>((dyn) {
      try {
        final parsed = dyn as List<BuyerDetails>;
        return Right(parsed);
      } catch (e) {
        return Left(PlaygroundClientError(
          "MGS-0099",
          "Error parsing the products list.",
          responseStatus: "0",
          nestedException: e is Exception ? e : null,
        ));
      }
    }).map(
      (buyerDetailsList) => buyerDetailsList
          .map((e) =>
              Buyer(identification: e.identification, fullName: e.fullName))
          .toList(),
    );
  }

  /// Fetches detailed information for a buyer by their identification.
  @override
  Future<Either<PlaygroundError, BuyerDetails>> fetchBuyerDetails(
    String identification,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1400));

    final response = await _makeRequest("GET", "/buyers/$identification");

    return response.flatMap((dyn) {
      try {
        final parsed = dyn as BuyerDetails;
        return Right(parsed);
      } catch (e) {
        return Left(PlaygroundClientError(
          "MGS-0099",
          "Error parsing the buyer by id.",
          responseStatus: "0",
          nestedException: e is Exception ? e : null,
        ));
      }
    });
  }

  // Generally it's a good idea to centralize all calls to the http client into
  // a single method. This way, you can handle different responses and retries
  // in one place. In this demo, this is used to handle a step up request, but
  // it's also common to handle expired tokens.
  Future<Either<PlaygroundError, dynamic>> _makeRequest(
    String method,
    String url, {
    Map<String, dynamic>? body,
  }) async {
    if (method != "GET" && method != "POST") {
      return Left(
        PlaygroundClientError(
          "CLERR-094",
          "Unrecognized method $method passed to _makeRequest.",
          responseStatus: "0",
        ),
      );
    }

    // Function that will be called once or more. It makes the actual http call.
    Future<_FakeHttpResponse> makeRequestFunction(
        Map<String, String>? headers) async {
      final response = method == "GET"
          ? await _mockHttpClient.get(url, headers)
          : await _mockHttpClient.post(url, body ?? {}, headers);
      return response;
    }

    // This mutable list is declared before the retry strategies so that it can
    // be captured and modified.
    final Map<String, String> headers = {};

    // Note: Originally the makeRequestFunction function returned an Either,
    // but dartz's Eithers are very awkward with async operations. Flatmaps and
    // left maps didn't work, and folding into Futures requires awaiting after
    // every call, which makes it impractical to chain folds.
    // I chose instead to use a list of retry strategies, but there are other
    // solutions. It's probably possible to use interceptors, depending on the
    // http client library.
    final List<_RetryStrategy> retryStrategies = [
      // Retry when forbidden due to rejected access token.
      _RetryStrategy(
        shouldRetryRequest: (response) =>
            response.statusCode == 403 &&
            response.body["error_code"] == "INVALID_TOKEN",
        onRetryingRequest: (_) async {
          // This is where you would attempt to refresh the token using an
          // AuthService or similar. This demo doesn't have that.
          return const Right(false);
        },
      ),
      // Retry when forbidden due to necessary step-up authentication.
      _RetryStrategy(
        shouldRetryRequest: (response) =>
            response.statusCode == 403 &&
            response.body["error_code"] == "STEP_UP_REQUIRED",
        onRetryingRequest: (response) async {
          final sessionId = _safeCast<String>(response.body["session_id"]);
          // If no session id is present, skip the retry with an error.
          if (sessionId == null) {
            return const Left(
              PlaygroundClientError(
                "CLERR200",
                "Session id was not found in a step-up required response.",
                responseStatus: "403",
              ),
            );
          }
          // This displays the Auth SDK's UI prompt to the user.
          final stepUpResult = await GetIt.I
              .get<StepUpAuthService>()
              .displayStepUpRequest(sessionId);

          if (stepUpResult is StepUpSuccess) {
            // Set the header then retry (returning true means ok to retry).
            headers["X-step-up-auth-token"] = stepUpResult.authenticationToken;
            headers["X-step-up-auth-session"] = stepUpResult.stepUpSessionId;
            return const Right(true);
          } else if (stepUpResult is StepUpFailure) {
            // Do not attempt the retry. Fail with the corresponding reason.
            return switch (stepUpResult.reason) {
              StepUpFailureReason.userDismissed => const Left(
                  PlaygroundClientError(
                    "CLERR981",
                    "Request required step-up auth but user dismissed prompt.",
                    responseStatus: "403",
                  ),
                ),
              StepUpFailureReason.ranOutOfAttempts => const Left(
                  PlaygroundClientError(
                    "CLERR982",
                    "Request required step-up auth but user ran out of attempts.",
                    responseStatus: "403",
                  ),
                ),
              _ => const Left(
                  PlaygroundClientError(
                    "CLERR983",
                    "Request required step-up auth failed for an unknown reason.",
                    responseStatus: "403",
                  ),
                ),
              // Getting the code wrong is not a possible reason, because the
              // user can retry a few times.
            };
          } else {
            return const Left(
              PlaygroundClientError(
                "CLERR992",
                "Unexpected result returned from the step up service.",
                responseStatus: "0",
              ),
            );
          }
        },
      ),
    ];

    // First, attempt to make the request with the standard headers.
    // (Normally you would send at least an authorization header, but this
    // demo doesn't have that.)
    var response = await makeRequestFunction(headers);
    if (response.statusCode ~/ 100 == 2) {
      return Right(response.body);
    }

    // In case of any problem, we check if any of the retry strategies match.
    // If so, execute the strategy once and remove it from the list.
    whileLoop:
    while (true) {
      // One of the end conditions, for a success:
      if (response.statusCode ~/ 100 == 2) {
        return Right(response.body);
      }

      for (int i = 0; i < retryStrategies.length; i++) {
        if (retryStrategies[i].shouldRetryRequest(response)) {
          final shouldContinue =
              await retryStrategies[i].onRetryingRequest(response);
          // In case of left, return from this function with the left.
          // Otherwise, extract the right. There are certainly more elegant
          // ways to represent the result of the callback.
          if (shouldContinue.isLeft()) {
            return shouldContinue;
          } else {
            if (shouldContinue.getOrElse(() => false)) {
              retryStrategies.removeAt(i);
              // At this point, the headers may have been changed by the
              // onRetryingRequest callback.
              response = await makeRequestFunction(headers);
              continue whileLoop;
            } else {
              // Fall out of the loop and return left.
              break whileLoop;
            }
          }
        }
      }
      // Getting to the end of the retry strategies when none matched means
      // that none of the strategies applied. Fall out of the loop.
      break;
    }
    return Left(PlaygroundClientError(
      "CLR00",
      "An unknown error occurred when making the request.",
      responseStatus: response.statusCode.toString(),
    ));
  }
}

/// This simulates the use of an http client from a library, using predetermined
/// responses. You can safely ignore this class, because you'll use a real http
/// client library in a real app.
class _FakeHttpClient {
  Future<bool> _shouldRequireStepUp() async {
    // There's a setting which causes a step-up request to trigger.
    // This is only part of the demo. In a real-world scenario, the backend
    // decides when the step-up is required and returns some error response that
    // the client (the app) needs to identify. Then, the request is redone
    // sending the additional information. This is handled at the http client
    // level because it may involve sending additional headers.
    final localStorageService = GetIt.I.get<LocalStorageService>();
    final stepUpSettingKey = select(
      whenAndroid: "SETTING_SIMULATE_STEP_UP_REQUEST_ON_BUYERS_LIST",
      whenIos: "settingSimulateStepUpRequestOnBuyersList",
    );
    return (await localStorageService.read<bool>(stepUpSettingKey)).fold(
      (_) => false, // consider false if an error occurs.
      (value) => value ?? false, // consider null if value is missing.
    );
  }

  Future<String> _startStepUpSession() async {
    return (Random().nextInt(999999) + 1000000).toString();
  }

  Future<bool> _verifyStepUpAuthToken(String token, String sessionId) async {
    return token ==
        "諸行無常 諸行是苦 諸法無我"; // fixed string that the mocked SDK returns.
  }

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

  // This data will appear in the page "List with details request". The bloc
  // demonstrates how to efficiently implement a list where each item needs an
  // additional request to get details.
  final List<BuyerDetails> _mockBuyerDetails = List.from(
    [
      BuyerDetails(
        identification: "12341234",
        address: "1 The Lea, KIDDERMINSTER DY11 6JY, UK",
        fullName: "Thomas Javner",
        accountEmail: "thjavner@playgroundmail.com",
        birthdate: DateTime(1956, 11, 5),
      ),
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
        address: "26 Woodberry Rd, WICKFORD SS11 8XG, ENGLAND",
        fullName: "Vanessa Flutman",
        accountEmail: "vflut@playgroundmail.com",
        birthdate: DateTime(2002, 12, 1),
      ),
    ],
  );

  Future<_FakeHttpResponse> get(String url,
      [Map<String, String>? headers]) async {
    if (url == "/products") {
      return _FakeHttpResponse(
        statusCode: 200,
        body: _mockProducts,
      );
    }

    if (url == "/buyers") {
      return _FakeHttpResponse(
        statusCode: 200,
        body: _mockBuyerDetails,
      );
    }

    if (url.startsWith("/buyers/")) {
      final id = url.replaceAll("/buyers/", "");

      // This (fake) endpoint may refuse a request if the app is currently
      // configured to simulate a step-up-request.
      if (await _shouldRequireStepUp()) {
        // Mimicking a real server's behavior, we simply check if the step-up
        // auth token is present as a header. If it isn't, the server complains
        // with a request to authenticate with an alphanumeric code.
        final stepUpAuthToken =
            _safeCast<String>(headers?["X-step-up-auth-token"]);
        if (stepUpAuthToken == null) {
          return _FakeHttpResponse(
            statusCode: 403,
            body: {
              "error_code": "STEP_UP_REQUIRED",
              "session_id": await _startStepUpSession(),
            },
          );
        }

        // Then, if a step up auth token was provided, check the code for the
        // session.
        final stepUpAuthSessionId =
            _safeCast<String>(headers?["X-step-up-auth-session"]) ?? "";

        final bool stepUpTokenChecksOut = await _verifyStepUpAuthToken(
          stepUpAuthToken,
          stepUpAuthSessionId,
        );

        if (!stepUpTokenChecksOut) {
          return const _FakeHttpResponse(
            statusCode: 403,
            body: {
              "error_code": "STEP_UP_NOT_ACCEPTED",
            },
          );
        }
      }

      final BuyerDetails? buyer =
          _mockBuyerDetails.firstWhereOrNull((e) => e.identification == id);
      if (buyer == null) {
        return const _FakeHttpResponse(
          statusCode: 404,
          body: {
            "message": "Buyer not found.",
          },
        );
      }

      return _FakeHttpResponse(
        statusCode: 200,
        body: buyer,
      );
    }

    return _FakeHttpResponse(
        statusCode: 404, body: {"message": "Url not found: GET $url"});
  }

  Future<_FakeHttpResponse> post(String url, Map<String, dynamic> body,
      [Map<String, String>? headers]) async {
    if (url == "/products") {
      try {
        final product = body["product"] as Product;
        // Make a new list to avoid any possible problems with references.
        // Don't worry about this; in a real app, you'll be fetching fresh data
        // every time. This ensures that the list is a different reference after
        // adding a product, which should be the case automatically when you fetch
        // data remotely.
        _mockProducts = _mockProducts.followedBy([product]).toList();
        return const _FakeHttpResponse(statusCode: 200, body: {});
      } catch (_) {
        return _FakeHttpResponse(
          statusCode: 400,
          body: {"message": "A POST request for $url has failed."},
        );
      }
    }

    return _FakeHttpResponse(
      statusCode: 404,
      body: {"message": "Url not found: POST $url"},
    );
  }
}

class _FakeHttpResponse {
  final int statusCode;
  final dynamic body;

  const _FakeHttpResponse({
    required this.statusCode,
    required this.body,
  });
}

/// Class for storing the logic of a request retry.
/// A list of instances of this class is created before the request, and in case
/// of non-2XX response, each retry strategy is checked in turn and executed if
/// its condition matches, then removed from the list.
/// Note that in practice, it's much more likely that you will implement the
/// retry logic according to the best practices of the client http library.
class _RetryStrategy {
  /// Callback for checking if the request should be retried.
  final bool Function(_FakeHttpResponse response) shouldRetryRequest;

  /// Callback invoked before retrying the request. Return whether the request
  /// should be retried; if false, it will be skipped and the original error
  /// will be returned. If a Left is returned, that error will replace the
  /// original error and the retry will not be attempted.
  final Future<Either<PlaygroundError, bool>> Function(
      _FakeHttpResponse response) onRetryingRequest;

  const _RetryStrategy({
    required this.shouldRetryRequest,
    required this.onRetryingRequest,
  });
}

// Helper function.
T? _safeCast<T>(dynamic input) {
  if (input is T) {
    return input;
  } else {
    return null;
  }
}
