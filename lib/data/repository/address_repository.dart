import 'package:flutter_reference/data/client/viacep/viacep_client.dart';
import 'package:flutter_reference/domain/entity/address.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

/// Repository for everything related to addresses.
///
/// Currently, this has only one method for looking up an address in Brazil
/// based on its postal code.
class AddressRepository {
  final ViacepClient client = GetIt.I.get<ViacepClient>();

  /// Looks up address details based on a postal code.
  /// - country will always contain "Brasil".
  /// - state will be a two-letter abbreviation of the state (unidade federativa).
  /// - city will be the city's full name.
  /// - streetAddress will contain logradouro + bairro.
  /// - number will always be null.
  /// - When the city is not codified by street, city and streetAddress will be
  /// empty strings.
  Future<Either<PlaygroundError, Address>> lookupCep(String cep) async {
    // Map the dto to our domain entity.
    // This is a simple case where the dto corresponds to an entity 1-to-1.
    // Sometimes, mapping is more complicated and requires additional logic
    // here in the repository.
    return (await client.lookupCep(cep)).map((dto) => dto.toEntity());
  }
}
