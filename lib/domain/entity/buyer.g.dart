// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuyerImpl _$$BuyerImplFromJson(Map<String, dynamic> json) => _$BuyerImpl(
      identification: json['identification'] as String,
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$$BuyerImplToJson(_$BuyerImpl instance) =>
    <String, dynamic>{
      'identification': instance.identification,
      'fullName': instance.fullName,
    };

_$BuyerDetailsImpl _$$BuyerDetailsImplFromJson(Map<String, dynamic> json) =>
    _$BuyerDetailsImpl(
      identification: json['identification'] as String,
      address: json['address'] as String,
      fullName: json['fullName'] as String,
      accountEmail: json['accountEmail'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
    );

Map<String, dynamic> _$$BuyerDetailsImplToJson(_$BuyerDetailsImpl instance) =>
    <String, dynamic>{
      'identification': instance.identification,
      'address': instance.address,
      'fullName': instance.fullName,
      'accountEmail': instance.accountEmail,
      'birthdate': instance.birthdate.toIso8601String(),
    };
