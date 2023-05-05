// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'buyer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BuyerStateSuccess {
  List<Buyer> get buyers => throw _privateConstructorUsedError;

  /// Map from the buyer identification to the details' state. The state may be
  /// loading, error or success. If it's null, it means that the event for
  /// fetching that buyer's details has not been emitted yet.
  Map<String, BuyerDetailsState> get details =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BuyerStateSuccessCopyWith<BuyerStateSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuyerStateSuccessCopyWith<$Res> {
  factory $BuyerStateSuccessCopyWith(
          BuyerStateSuccess value, $Res Function(BuyerStateSuccess) then) =
      _$BuyerStateSuccessCopyWithImpl<$Res, BuyerStateSuccess>;
  @useResult
  $Res call({List<Buyer> buyers, Map<String, BuyerDetailsState> details});
}

/// @nodoc
class _$BuyerStateSuccessCopyWithImpl<$Res, $Val extends BuyerStateSuccess>
    implements $BuyerStateSuccessCopyWith<$Res> {
  _$BuyerStateSuccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buyers = null,
    Object? details = null,
  }) {
    return _then(_value.copyWith(
      buyers: null == buyers
          ? _value.buyers
          : buyers // ignore: cast_nullable_to_non_nullable
              as List<Buyer>,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, BuyerDetailsState>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BuyerStateSuccessCopyWith<$Res>
    implements $BuyerStateSuccessCopyWith<$Res> {
  factory _$$_BuyerStateSuccessCopyWith(_$_BuyerStateSuccess value,
          $Res Function(_$_BuyerStateSuccess) then) =
      __$$_BuyerStateSuccessCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Buyer> buyers, Map<String, BuyerDetailsState> details});
}

/// @nodoc
class __$$_BuyerStateSuccessCopyWithImpl<$Res>
    extends _$BuyerStateSuccessCopyWithImpl<$Res, _$_BuyerStateSuccess>
    implements _$$_BuyerStateSuccessCopyWith<$Res> {
  __$$_BuyerStateSuccessCopyWithImpl(
      _$_BuyerStateSuccess _value, $Res Function(_$_BuyerStateSuccess) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buyers = null,
    Object? details = null,
  }) {
    return _then(_$_BuyerStateSuccess(
      buyers: null == buyers
          ? _value._buyers
          : buyers // ignore: cast_nullable_to_non_nullable
              as List<Buyer>,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, BuyerDetailsState>,
    ));
  }
}

/// @nodoc

class _$_BuyerStateSuccess implements _BuyerStateSuccess {
  const _$_BuyerStateSuccess(
      {required final List<Buyer> buyers,
      required final Map<String, BuyerDetailsState> details})
      : _buyers = buyers,
        _details = details;

  final List<Buyer> _buyers;
  @override
  List<Buyer> get buyers {
    if (_buyers is EqualUnmodifiableListView) return _buyers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_buyers);
  }

  /// Map from the buyer identification to the details' state. The state may be
  /// loading, error or success. If it's null, it means that the event for
  /// fetching that buyer's details has not been emitted yet.
  final Map<String, BuyerDetailsState> _details;

  /// Map from the buyer identification to the details' state. The state may be
  /// loading, error or success. If it's null, it means that the event for
  /// fetching that buyer's details has not been emitted yet.
  @override
  Map<String, BuyerDetailsState> get details {
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_details);
  }

  @override
  String toString() {
    return 'BuyerStateSuccess(buyers: $buyers, details: $details)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BuyerStateSuccess &&
            const DeepCollectionEquality().equals(other._buyers, _buyers) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_buyers),
      const DeepCollectionEquality().hash(_details));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BuyerStateSuccessCopyWith<_$_BuyerStateSuccess> get copyWith =>
      __$$_BuyerStateSuccessCopyWithImpl<_$_BuyerStateSuccess>(
          this, _$identity);
}

abstract class _BuyerStateSuccess implements BuyerStateSuccess {
  const factory _BuyerStateSuccess(
          {required final List<Buyer> buyers,
          required final Map<String, BuyerDetailsState> details}) =
      _$_BuyerStateSuccess;

  @override
  List<Buyer> get buyers;
  @override

  /// Map from the buyer identification to the details' state. The state may be
  /// loading, error or success. If it's null, it means that the event for
  /// fetching that buyer's details has not been emitted yet.
  Map<String, BuyerDetailsState> get details;
  @override
  @JsonKey(ignore: true)
  _$$_BuyerStateSuccessCopyWith<_$_BuyerStateSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
