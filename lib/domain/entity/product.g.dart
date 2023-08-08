// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Product _$$_ProductFromJson(Map<String, dynamic> json) => _$_Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      amountInStock: json['stockAmount'] as int,
      unit: json['unit'] as String,
      pricePerUnitCents: json['pricePerUnitCents'] as int,
    );

Map<String, dynamic> _$$_ProductToJson(_$_Product instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'stockAmount': instance.amountInStock,
      'unit': instance.unit,
      'pricePerUnitCents': instance.pricePerUnitCents,
    };
