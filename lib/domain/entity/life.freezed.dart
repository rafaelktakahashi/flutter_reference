// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'life.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LifeBoard _$LifeBoardFromJson(Map<String, dynamic> json) {
  return _LifeBoard.fromJson(json);
}

/// @nodoc
mixin _$LifeBoard {
  /// Two-dimensional array of cells in the board.
  ///
  /// The matrix is first indexed by row (zero-indexed vertical coordinate)
  /// and secondly indexed by column (zero-indexed horizontal coordinate).
  List<List<LifeCell>> get cells => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;

  /// Serializes this LifeBoard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LifeBoard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LifeBoardCopyWith<LifeBoard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LifeBoardCopyWith<$Res> {
  factory $LifeBoardCopyWith(LifeBoard value, $Res Function(LifeBoard) then) =
      _$LifeBoardCopyWithImpl<$Res, LifeBoard>;
  @useResult
  $Res call({List<List<LifeCell>> cells, int height, int width});
}

/// @nodoc
class _$LifeBoardCopyWithImpl<$Res, $Val extends LifeBoard>
    implements $LifeBoardCopyWith<$Res> {
  _$LifeBoardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LifeBoard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cells = null,
    Object? height = null,
    Object? width = null,
  }) {
    return _then(_value.copyWith(
      cells: null == cells
          ? _value.cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<List<LifeCell>>,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LifeBoardImplCopyWith<$Res>
    implements $LifeBoardCopyWith<$Res> {
  factory _$$LifeBoardImplCopyWith(
          _$LifeBoardImpl value, $Res Function(_$LifeBoardImpl) then) =
      __$$LifeBoardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<List<LifeCell>> cells, int height, int width});
}

/// @nodoc
class __$$LifeBoardImplCopyWithImpl<$Res>
    extends _$LifeBoardCopyWithImpl<$Res, _$LifeBoardImpl>
    implements _$$LifeBoardImplCopyWith<$Res> {
  __$$LifeBoardImplCopyWithImpl(
      _$LifeBoardImpl _value, $Res Function(_$LifeBoardImpl) _then)
      : super(_value, _then);

  /// Create a copy of LifeBoard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cells = null,
    Object? height = null,
    Object? width = null,
  }) {
    return _then(_$LifeBoardImpl(
      cells: null == cells
          ? _value._cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<List<LifeCell>>,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LifeBoardImpl extends _LifeBoard {
  const _$LifeBoardImpl(
      {required final List<List<LifeCell>> cells,
      required this.height,
      required this.width})
      : _cells = cells,
        super._();

  factory _$LifeBoardImpl.fromJson(Map<String, dynamic> json) =>
      _$$LifeBoardImplFromJson(json);

  /// Two-dimensional array of cells in the board.
  ///
  /// The matrix is first indexed by row (zero-indexed vertical coordinate)
  /// and secondly indexed by column (zero-indexed horizontal coordinate).
  final List<List<LifeCell>> _cells;

  /// Two-dimensional array of cells in the board.
  ///
  /// The matrix is first indexed by row (zero-indexed vertical coordinate)
  /// and secondly indexed by column (zero-indexed horizontal coordinate).
  @override
  List<List<LifeCell>> get cells {
    if (_cells is EqualUnmodifiableListView) return _cells;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cells);
  }

  @override
  final int height;
  @override
  final int width;

  @override
  String toString() {
    return 'LifeBoard(cells: $cells, height: $height, width: $width)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LifeBoardImpl &&
            const DeepCollectionEquality().equals(other._cells, _cells) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_cells), height, width);

  /// Create a copy of LifeBoard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LifeBoardImplCopyWith<_$LifeBoardImpl> get copyWith =>
      __$$LifeBoardImplCopyWithImpl<_$LifeBoardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LifeBoardImplToJson(
      this,
    );
  }
}

abstract class _LifeBoard extends LifeBoard {
  const factory _LifeBoard(
      {required final List<List<LifeCell>> cells,
      required final int height,
      required final int width}) = _$LifeBoardImpl;
  const _LifeBoard._() : super._();

  factory _LifeBoard.fromJson(Map<String, dynamic> json) =
      _$LifeBoardImpl.fromJson;

  /// Two-dimensional array of cells in the board.
  ///
  /// The matrix is first indexed by row (zero-indexed vertical coordinate)
  /// and secondly indexed by column (zero-indexed horizontal coordinate).
  @override
  List<List<LifeCell>> get cells;
  @override
  int get height;
  @override
  int get width;

  /// Create a copy of LifeBoard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LifeBoardImplCopyWith<_$LifeBoardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LifeCell _$LifeCellFromJson(Map<String, dynamic> json) {
  return _LifeCell.fromJson(json);
}

/// @nodoc
mixin _$LifeCell {
  /// Whether or not this cell is alive.
  bool get alive => throw _privateConstructorUsedError;

  /// Serializes this LifeCell to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LifeCell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LifeCellCopyWith<LifeCell> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LifeCellCopyWith<$Res> {
  factory $LifeCellCopyWith(LifeCell value, $Res Function(LifeCell) then) =
      _$LifeCellCopyWithImpl<$Res, LifeCell>;
  @useResult
  $Res call({bool alive});
}

/// @nodoc
class _$LifeCellCopyWithImpl<$Res, $Val extends LifeCell>
    implements $LifeCellCopyWith<$Res> {
  _$LifeCellCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LifeCell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alive = null,
  }) {
    return _then(_value.copyWith(
      alive: null == alive
          ? _value.alive
          : alive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LifeCellImplCopyWith<$Res>
    implements $LifeCellCopyWith<$Res> {
  factory _$$LifeCellImplCopyWith(
          _$LifeCellImpl value, $Res Function(_$LifeCellImpl) then) =
      __$$LifeCellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool alive});
}

/// @nodoc
class __$$LifeCellImplCopyWithImpl<$Res>
    extends _$LifeCellCopyWithImpl<$Res, _$LifeCellImpl>
    implements _$$LifeCellImplCopyWith<$Res> {
  __$$LifeCellImplCopyWithImpl(
      _$LifeCellImpl _value, $Res Function(_$LifeCellImpl) _then)
      : super(_value, _then);

  /// Create a copy of LifeCell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alive = null,
  }) {
    return _then(_$LifeCellImpl(
      alive: null == alive
          ? _value.alive
          : alive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LifeCellImpl implements _LifeCell {
  const _$LifeCellImpl({required this.alive});

  factory _$LifeCellImpl.fromJson(Map<String, dynamic> json) =>
      _$$LifeCellImplFromJson(json);

  /// Whether or not this cell is alive.
  @override
  final bool alive;

  @override
  String toString() {
    return 'LifeCell(alive: $alive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LifeCellImpl &&
            (identical(other.alive, alive) || other.alive == alive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, alive);

  /// Create a copy of LifeCell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LifeCellImplCopyWith<_$LifeCellImpl> get copyWith =>
      __$$LifeCellImplCopyWithImpl<_$LifeCellImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LifeCellImplToJson(
      this,
    );
  }
}

abstract class _LifeCell implements LifeCell {
  const factory _LifeCell({required final bool alive}) = _$LifeCellImpl;

  factory _LifeCell.fromJson(Map<String, dynamic> json) =
      _$LifeCellImpl.fromJson;

  /// Whether or not this cell is alive.
  @override
  bool get alive;

  /// Create a copy of LifeCell
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LifeCellImplCopyWith<_$LifeCellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
