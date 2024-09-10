// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viacep_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnderecoViaCepDTOImpl _$$EnderecoViaCepDTOImplFromJson(
        Map<String, dynamic> json) =>
    _$EnderecoViaCepDTOImpl(
      cep: json['cep'] as String,
      uf: json['uf'] as String,
      localidade: json['localidade'] as String,
      bairro: json['bairro'] as String,
      logradouro: json['logradouro'] as String,
      complemento: json['complemento'] as String,
      ibge: json['ibge'] as String,
      gia: json['gia'] as String,
      ddd: json['ddd'] as String,
      siafi: json['siafi'] as String,
    );

Map<String, dynamic> _$$EnderecoViaCepDTOImplToJson(
        _$EnderecoViaCepDTOImpl instance) =>
    <String, dynamic>{
      'cep': instance.cep,
      'uf': instance.uf,
      'localidade': instance.localidade,
      'bairro': instance.bairro,
      'logradouro': instance.logradouro,
      'complemento': instance.complemento,
      'ibge': instance.ibge,
      'gia': instance.gia,
      'ddd': instance.ddd,
      'siafi': instance.siafi,
    };
