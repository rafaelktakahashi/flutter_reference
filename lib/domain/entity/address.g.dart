// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Address _$$_AddressFromJson(Map<String, dynamic> json) => _$_Address(
      postalCode: json['postalCode'] as String,
      streetAddress: json['streetAddress'] as String,
      number: json['number'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$$_AddressToJson(_$_Address instance) =>
    <String, dynamic>{
      'postalCode': instance.postalCode,
      'streetAddress': instance.streetAddress,
      'number': instance.number,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
    };
