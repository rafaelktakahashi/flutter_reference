// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LifeBoard _$$_LifeBoardFromJson(Map<String, dynamic> json) => _$_LifeBoard(
      cells: (json['cells'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => LifeCell.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      height: json['height'] as int,
      width: json['width'] as int,
    );

Map<String, dynamic> _$$_LifeBoardToJson(_$_LifeBoard instance) =>
    <String, dynamic>{
      'cells': instance.cells,
      'height': instance.height,
      'width': instance.width,
    };

_$_LifeCell _$$_LifeCellFromJson(Map<String, dynamic> json) => _$_LifeCell(
      alive: json['alive'] as bool,
    );

Map<String, dynamic> _$$_LifeCellToJson(_$_LifeCell instance) =>
    <String, dynamic>{
      'alive': instance.alive,
    };
