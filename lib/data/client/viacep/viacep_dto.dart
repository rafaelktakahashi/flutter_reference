import 'package:flutter_reference/domain/entity/address.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'viacep_dto.freezed.dart';
part 'viacep_dto.g.dart';

/// A DTO is a data transfer object. It's made specifically to match the API of
/// a certain client. In this case, this object matches the ViaCep API
/// (endpoint: https://viacep.com.br/ws/{CEP}/json/)
///
/// Using DTOs decouples your domain classes from any APIs.
///
/// Viacep always returns all fields when the query is successful, even if some
/// of them would be empty. For exemple, in Guararema (08900-000), all fields
/// smaller than "localidade" are returned as an empty string.
///
/// For CEP codes that don't exist, Viacep returns { "erro": true }. For queries
/// in a wrong format, Viacep returns a 400 without a json body.
@freezed // Check product.dart for details on freezed.
class EnderecoViaCepDTO with _$EnderecoViaCepDTO {
  const factory EnderecoViaCepDTO({
    required String cep,
    required String uf,
    required String localidade, // município/cidade
    required String bairro,
    required String logradouro,
    required String complemento,
    required String ibge,
    required String gia,
    required String ddd,
    required String siafi,
  }) = _EnderecoViaCepDTO;

  const EnderecoViaCepDTO._();

  factory EnderecoViaCepDTO.fromJson(Map<String, Object?> json) =>
      _$EnderecoViaCepDTOFromJson(json);

  Address toEntity() {
    return Address(
      postalCode: cep,
      streetAddress: logradouro.isNotEmpty ? "$logradouro, $bairro" : "",
      city: localidade,
      state: uf,
      country: "Brasil",
    );
  }
}
