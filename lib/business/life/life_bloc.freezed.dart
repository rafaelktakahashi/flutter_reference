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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LifeState {
  LifeBoard get board => throw _privateConstructorUsedError;

  /// When true, this means the life board is automatically advancing its state.
  bool get isAutostepping => throw _privateConstructorUsedError;

  /// Create a copy of LifeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LifeStateCopyWith<LifeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LifeStateCopyWith<$Res> {
  factory $LifeStateCopyWith(LifeState value, $Res Function(LifeState) then) =
      _$LifeStateCopyWithImpl<$Res, LifeState>;
  @useResult
  $Res call({LifeBoard board, bool isAutostepping});

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

  /// Create a copy of LifeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? isAutostepping = null,
  }) {
    return _then(_value.copyWith(
      board: null == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as LifeBoard,
      isAutostepping: null == isAutostepping
          ? _value.isAutostepping
          : isAutostepping // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of LifeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LifeBoardCopyWith<$Res> get board {
    return $LifeBoardCopyWith<$Res>(_value.board, (value) {
      return _then(_value.copyWith(board: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LifeStateImplCopyWith<$Res>
    implements $LifeStateCopyWith<$Res> {
  factory _$$LifeStateImplCopyWith(
          _$LifeStateImpl value, $Res Function(_$LifeStateImpl) then) =
      __$$LifeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LifeBoard board, bool isAutostepping});

  @override
  $LifeBoardCopyWith<$Res> get board;
}

/// @nodoc
class __$$LifeStateImplCopyWithImpl<$Res>
    extends _$LifeStateCopyWithImpl<$Res, _$LifeStateImpl>
    implements _$$LifeStateImplCopyWith<$Res> {
  __$$LifeStateImplCopyWithImpl(
      _$LifeStateImpl _value, $Res Function(_$LifeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LifeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? isAutostepping = null,
  }) {
    return _then(_$LifeStateImpl(
      board: null == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as LifeBoard,
      isAutostepping: null == isAutostepping
          ? _value.isAutostepping
          : isAutostepping // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LifeStateImpl implements _LifeState {
  const _$LifeStateImpl({required this.board, required this.isAutostepping});

  @override
  final LifeBoard board;

  /// When true, this means the life board is automatically advancing its state.
  @override
  final bool isAutostepping;

  @override
  String toString() {
    return 'LifeState(board: $board, isAutostepping: $isAutostepping)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LifeStateImpl &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.isAutostepping, isAutostepping) ||
                other.isAutostepping == isAutostepping));
  }

  @override
  int get hashCode => Object.hash(runtimeType, board, isAutostepping);

  /// Create a copy of LifeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LifeStateImplCopyWith<_$LifeStateImpl> get copyWith =>
      __$$LifeStateImplCopyWithImpl<_$LifeStateImpl>(this, _$identity);
}

abstract class _LifeState implements LifeState {
  const factory _LifeState(
      {required final LifeBoard board,
      required final bool isAutostepping}) = _$LifeStateImpl;

  @override
  LifeBoard get board;

  /// When true, this means the life board is automatically advancing its state.
  @override
  bool get isAutostepping;

  /// Create a copy of LifeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LifeStateImplCopyWith<_$LifeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
