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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
abstract class _$$_LifeBoardCopyWith<$Res> implements $LifeBoardCopyWith<$Res> {
  factory _$$_LifeBoardCopyWith(
          _$_LifeBoard value, $Res Function(_$_LifeBoard) then) =
      __$$_LifeBoardCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<List<LifeCell>> cells, int height, int width});
}

/// @nodoc
class __$$_LifeBoardCopyWithImpl<$Res>
    extends _$LifeBoardCopyWithImpl<$Res, _$_LifeBoard>
    implements _$$_LifeBoardCopyWith<$Res> {
  __$$_LifeBoardCopyWithImpl(
      _$_LifeBoard _value, $Res Function(_$_LifeBoard) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cells = null,
    Object? height = null,
    Object? width = null,
  }) {
    return _then(_$_LifeBoard(
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
class _$_LifeBoard extends _LifeBoard {
  const _$_LifeBoard(
      {required final List<List<LifeCell>> cells,
      required this.height,
      required this.width})
      : _cells = cells,
        super._();

  factory _$_LifeBoard.fromJson(Map<String, dynamic> json) =>
      _$$_LifeBoardFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LifeBoard &&
            const DeepCollectionEquality().equals(other._cells, _cells) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_cells), height, width);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LifeBoardCopyWith<_$_LifeBoard> get copyWith =>
      __$$_LifeBoardCopyWithImpl<_$_LifeBoard>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LifeBoardToJson(
      this,
    );
  }
}

abstract class _LifeBoard extends LifeBoard {
  const factory _LifeBoard(
      {required final List<List<LifeCell>> cells,
      required final int height,
      required final int width}) = _$_LifeBoard;
  const _LifeBoard._() : super._();

  factory _LifeBoard.fromJson(Map<String, dynamic> json) =
      _$_LifeBoard.fromJson;

  @override

  /// Two-dimensional array of cells in the board.
  ///
  /// The matrix is first indexed by row (zero-indexed vertical coordinate)
  /// and secondly indexed by column (zero-indexed horizontal coordinate).
  List<List<LifeCell>> get cells;
  @override
  int get height;
  @override
  int get width;
  @override
  @JsonKey(ignore: true)
  _$$_LifeBoardCopyWith<_$_LifeBoard> get copyWith =>
      throw _privateConstructorUsedError;
}

LifeCell _$LifeCellFromJson(Map<String, dynamic> json) {
  return _LifeCell.fromJson(json);
}

/// @nodoc
mixin _$LifeCell {
  /// Whether or not this cell is alive.
  bool get alive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
abstract class _$$_LifeCellCopyWith<$Res> implements $LifeCellCopyWith<$Res> {
  factory _$$_LifeCellCopyWith(
          _$_LifeCell value, $Res Function(_$_LifeCell) then) =
      __$$_LifeCellCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool alive});
}

/// @nodoc
class __$$_LifeCellCopyWithImpl<$Res>
    extends _$LifeCellCopyWithImpl<$Res, _$_LifeCell>
    implements _$$_LifeCellCopyWith<$Res> {
  __$$_LifeCellCopyWithImpl(
      _$_LifeCell _value, $Res Function(_$_LifeCell) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alive = null,
  }) {
    return _then(_$_LifeCell(
      alive: null == alive
          ? _value.alive
          : alive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LifeCell implements _LifeCell {
  const _$_LifeCell({required this.alive});

  factory _$_LifeCell.fromJson(Map<String, dynamic> json) =>
      _$$_LifeCellFromJson(json);

  /// Whether or not this cell is alive.
  @override
  final bool alive;

  @override
  String toString() {
    return 'LifeCell(alive: $alive)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LifeCell &&
            (identical(other.alive, alive) || other.alive == alive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, alive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LifeCellCopyWith<_$_LifeCell> get copyWith =>
      __$$_LifeCellCopyWithImpl<_$_LifeCell>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LifeCellToJson(
      this,
    );
  }
}

abstract class _LifeCell implements LifeCell {
  const factory _LifeCell({required final bool alive}) = _$_LifeCell;

  factory _LifeCell.fromJson(Map<String, dynamic> json) = _$_LifeCell.fromJson;

  @override

  /// Whether or not this cell is alive.
  bool get alive;
  @override
  @JsonKey(ignore: true)
  _$$_LifeCellCopyWith<_$_LifeCell> get copyWith =>
      throw _privateConstructorUsedError;
}
