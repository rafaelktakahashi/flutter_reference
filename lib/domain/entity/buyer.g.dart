// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Buyer _$$_BuyerFromJson(Map<String, dynamic> json) => _$_Buyer(
      identification: json['identification'] as String,
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$$_BuyerToJson(_$_Buyer instance) => <String, dynamic>{
      'identification': instance.identification,
      'fullName': instance.fullName,
    };

_$_BuyerDetails _$$_BuyerDetailsFromJson(Map<String, dynamic> json) =>
    _$_BuyerDetails(
      identification: json['identification'] as String,
      address: json['address'] as String,
      fullName: json['fullName'] as String,
      accountEmail: json['accountEmail'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
    );

Map<String, dynamic> _$$_BuyerDetailsToJson(_$_BuyerDetails instance) =>
    <String, dynamic>{
      'identification': instance.identification,
      'address': instance.address,
      'fullName': instance.fullName,
      'accountEmail': instance.accountEmail,
      'birthdate': instance.birthdate.toIso8601String(),
    };
