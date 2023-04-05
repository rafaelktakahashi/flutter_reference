// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'life_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LifeState {
  LifeBoard get board => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LifeStateCopyWith<LifeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LifeStateCopyWith<$Res> {
  factory $LifeStateCopyWith(LifeState value, $Res Function(LifeState) then) =
      _$LifeStateCopyWithImpl<$Res, LifeState>;
  @useResult
  $Res call({LifeBoard board});

  $LifeBoardCopyWith<$Res> get board;
}

/// @nodoc
class _$LifeStateCopyWithImpl<$Res, $Val extends LifeState>
    implements $LifeStateCopyWith<$Res> {
  _$LifeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
  }) {
    return _then(_value.copyWith(
      board: null == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as LifeBoard,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LifeBoardCopyWith<$Res> get board {
    return $LifeBoardCopyWith<$Res>(_value.board, (value) {
      return _then(_value.copyWith(board: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LifeStateCopyWith<$Res> implements $LifeStateCopyWith<$Res> {
  factory _$$_LifeStateCopyWith(
          _$_LifeState value, $Res Function(_$_LifeState) then) =
      __$$_LifeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LifeBoard board});

  @override
  $LifeBoardCopyWith<$Res> get board;
}

/// @nodoc
class __$$_LifeStateCopyWithImpl<$Res>
    extends _$LifeStateCopyWithImpl<$Res, _$_LifeState>
    implements _$$_LifeStateCopyWith<$Res> {
  __$$_LifeStateCopyWithImpl(
      _$_LifeState _value, $Res Function(_$_LifeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
  }) {
    return _then(_$_LifeState(
      board: null == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as LifeBoard,
    ));
  }
}

/// @nodoc

class _$_LifeState implements _LifeState {
  const _$_LifeState({required this.board});

  @override
  final LifeBoard board;

  @override
  String toString() {
    return 'LifeState(board: $board)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LifeState &&
            (identical(other.board, board) || other.board == board));
  }

  @override
  int get hashCode => Object.hash(runtimeType, board);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LifeStateCopyWith<_$_LifeState> get copyWith =>
      __$$_LifeStateCopyWithImpl<_$_LifeState>(this, _$identity);
}

abstract class _LifeState implements LifeState {
  const factory _LifeState({required final LifeBoard board}) = _$_LifeState;

  @override
  LifeBoard get board;
  @override
  @JsonKey(ignore: true)
  _$$_LifeStateCopyWith<_$_LifeState> get copyWith =>
      throw _privateConstructorUsedError;
}
