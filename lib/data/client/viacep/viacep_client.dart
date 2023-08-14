import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_reference/data/client/viacep/viacep_dto.dart';
import 'package:flutter_reference/domain/error/playground_client_error.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

var client = HttpClient();

/// Client that connects to Viacep's free service. Only supports addresses in
/// Brazil.
class ViacepClient {
  /// Looks up a CEP postal code and returns an address.
  ///

  ///
  /// In your application, you'll probably be using your own version of the
  /// Address class, depending on what your application needs. Thus, adapt the
  /// code accordingly.
  Future<Either<PlaygroundError, EnderecoViaCepDTO>> lookupCep(
      String cep) async {
    // Important: This example uses a very simple request with Dart's basic
    // http client. In a larger application, you should consider picking an
    // http library to help you save work and get more features.

    // Viacep accepts CEP with a "-", but we're removing all non-digits here
    // to avoid any possible errors anyway.
    String cepOnlyDigits = cep.replaceAll(RegExp(r"\D"), "");

    HttpClientRequest request =
        await client.get('viacep.com.br', 80, '/ws/$cepOnlyDigits/json/');
    HttpClientResponse response = await request.close();

    // ex.: 404 => divide by 100 to get 4.04
    // Then apply the floor function to get 4.
    // Every 4xx will give the integer 4. This calculates the hundreds digit
    // of the status code.
    if ((response.statusCode / 100).floor() == 4) {
      // if it's a 4xx
      // We don't expect the response to contain a body in json format. It'll
      // likely return an xml, but we won't parse it here.
      return Left(
        PlaygroundClientError(
          "viacep-001",
          "There was an error when querying ViaCep", // <- dev message
          responseStatus: response.statusCode.toString(),
        ),
      );
    }

    if ((response.statusCode % 100).floor() == 5) {
      // if it's a 5xx
      // There's nothing we can do about server errors. This is true for any
      // client.
      PlaygroundClientError(
        "viacep-002",
        "ViaCep is down.",
        responseStatus: response.statusCode.toString(),
      );
    }

    try {
      final rawData = await response.transform(utf8.decoder).join();

      final data = json.decode(rawData);

      if (data["erro"] == true) {
        // Viacep returns { "erro": true } when we ask for a CEP that doesn't
        // exist.
        return Left(
          PlaygroundClientError(
            "viacep-003",
            "CEP does not exist.",
            // The status will be 200, meaning the request succeeded, but a
            // successful request doesn't necessarily mean a successful result.
            responseStatus: response.statusCode.toString(),
          ),
        );
      }

      final dto = EnderecoViaCepDTO.fromJson(data);

      return Right(dto);
    } on FormatException catch (formatException) {
      return Left(
        PlaygroundClientError(
          "viacep-004",
          "Response was in an unexpected format.",
          responseStatus: response.statusCode.toString(),
          nestedException: formatException,
        ),
      );
    } on Exception catch (e) {
      return Left(
        PlaygroundClientError(
          "viacep-005",
          "Unknown error.",
          responseStatus: response.statusCode.toString(),
          nestedException: e,
        ),
      );
    }
  }
}
