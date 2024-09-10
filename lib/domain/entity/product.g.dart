// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      amountInStock: (json['stockAmount'] as num).toInt(),
      unit: json['unit'] as String,
      pricePerUnitCents: (json['pricePerUnitCents'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'stockAmount': instance.amountInStock,
      'unit': instance.unit,
      'pricePerUnitCents': instance.pricePerUnitCents,
    };
