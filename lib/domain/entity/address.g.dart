// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressImpl _$$AddressImplFromJson(Map<String, dynamic> json) =>
    _$AddressImpl(
      postalCode: json['postalCode'] as String,
      streetAddress: json['streetAddress'] as String,
      number: json['number'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$$AddressImplToJson(_$AddressImpl instance) =>
    <String, dynamic>{
      'postalCode': instance.postalCode,
      'streetAddress': instance.streetAddress,
      'number': instance.number,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
    };
