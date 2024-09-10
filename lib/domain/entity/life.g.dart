// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LifeBoardImpl _$$LifeBoardImplFromJson(Map<String, dynamic> json) =>
    _$LifeBoardImpl(
      cells: (json['cells'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => LifeCell.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      height: (json['height'] as num).toInt(),
      width: (json['width'] as num).toInt(),
    );

Map<String, dynamic> _$$LifeBoardImplToJson(_$LifeBoardImpl instance) =>
    <String, dynamic>{
      'cells': instance.cells,
      'height': instance.height,
      'width': instance.width,
    };

_$LifeCellImpl _$$LifeCellImplFromJson(Map<String, dynamic> json) =>
    _$LifeCellImpl(
      alive: json['alive'] as bool,
    );

Map<String, dynamic> _$$LifeCellImplToJson(_$LifeCellImpl instance) =>
    <String, dynamic>{
      'alive': instance.alive,
    };
