// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'buyer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Buyer _$BuyerFromJson(Map<String, dynamic> json) {
  return _Buyer.fromJson(json);
}

/// @nodoc
mixin _$Buyer {
  /// The person or company's document.
  String get identification => throw _privateConstructorUsedError;

  /// The person or company's full name.
  String get fullName => throw _privateConstructorUsedError;

  /// Serializes this Buyer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Buyer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuyerCopyWith<Buyer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuyerCopyWith<$Res> {
  factory $BuyerCopyWith(Buyer value, $Res Function(Buyer) then) =
      _$BuyerCopyWithImpl<$Res, Buyer>;
  @useResult
  $Res call({String identification, String fullName});
}

/// @nodoc
class _$BuyerCopyWithImpl<$Res, $Val extends Buyer>
    implements $BuyerCopyWith<$Res> {
  _$BuyerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Buyer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identification = null,
    Object? fullName = null,
  }) {
    return _then(_value.copyWith(
      identification: null == identification
          ? _value.identification
          : identification // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuyerImplCopyWith<$Res> implements $BuyerCopyWith<$Res> {
  factory _$$BuyerImplCopyWith(
          _$BuyerImpl value, $Res Function(_$BuyerImpl) then) =
      __$$BuyerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String identification, String fullName});
}

/// @nodoc
class __$$BuyerImplCopyWithImpl<$Res>
    extends _$BuyerCopyWithImpl<$Res, _$BuyerImpl>
    implements _$$BuyerImplCopyWith<$Res> {
  __$$BuyerImplCopyWithImpl(
      _$BuyerImpl _value, $Res Function(_$BuyerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Buyer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identification = null,
    Object? fullName = null,
  }) {
    return _then(_$BuyerImpl(
      identification: null == identification
          ? _value.identification
          : identification // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuyerImpl implements _Buyer {
  const _$BuyerImpl({required this.identification, required this.fullName});

  factory _$BuyerImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuyerImplFromJson(json);

  /// The person or company's document.
  @override
  final String identification;

  /// The person or company's full name.
  @override
  final String fullName;

  @override
  String toString() {
    return 'Buyer(identification: $identification, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuyerImpl &&
            (identical(other.identification, identification) ||
                other.identification == identification) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identification, fullName);

  /// Create a copy of Buyer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuyerImplCopyWith<_$BuyerImpl> get copyWith =>
      __$$BuyerImplCopyWithImpl<_$BuyerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuyerImplToJson(
      this,
    );
  }
}

abstract class _Buyer implements Buyer {
  const factory _Buyer(
      {required final String identification,
      required final String fullName}) = _$BuyerImpl;

  factory _Buyer.fromJson(Map<String, dynamic> json) = _$BuyerImpl.fromJson;

  /// The person or company's document.
  @override
  String get identification;

  /// The person or company's full name.
  @override
  String get fullName;

  /// Create a copy of Buyer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuyerImplCopyWith<_$BuyerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BuyerDetails _$BuyerDetailsFromJson(Map<String, dynamic> json) {
  return _BuyerDetails.fromJson(json);
}

/// @nodoc
mixin _$BuyerDetails {
  /// The person or company's document.
  String get identification => throw _privateConstructorUsedError;

  /// The person or company's current address.
  String get address => throw _privateConstructorUsedError;

  /// The person or company's full name.
  String get fullName => throw _privateConstructorUsedError;

  /// E-mail address that this person or company uses.
  String get accountEmail => throw _privateConstructorUsedError;

  /// The person's birthdate, or the company's date of foundation.
  /// Has a date component only, without time.
  DateTime get birthdate => throw _privateConstructorUsedError;

  /// Serializes this BuyerDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuyerDetailsCopyWith<BuyerDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuyerDetailsCopyWith<$Res> {
  factory $BuyerDetailsCopyWith(
          BuyerDetails value, $Res Function(BuyerDetails) then) =
      _$BuyerDetailsCopyWithImpl<$Res, BuyerDetails>;
  @useResult
  $Res call(
      {String identification,
      String address,
      String fullName,
      String accountEmail,
      DateTime birthdate});
}

/// @nodoc
class _$BuyerDetailsCopyWithImpl<$Res, $Val extends BuyerDetails>
    implements $BuyerDetailsCopyWith<$Res> {
  _$BuyerDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identification = null,
    Object? address = null,
    Object? fullName = null,
    Object? accountEmail = null,
    Object? birthdate = null,
  }) {
    return _then(_value.copyWith(
      identification: null == identification
          ? _value.identification
          : identification // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      accountEmail: null == accountEmail
          ? _value.accountEmail
          : accountEmail // ignore: cast_nullable_to_non_nullable
              as String,
      birthdate: null == birthdate
          ? _value.birthdate
          : birthdate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuyerDetailsImplCopyWith<$Res>
    implements $BuyerDetailsCopyWith<$Res> {
  factory _$$BuyerDetailsImplCopyWith(
          _$BuyerDetailsImpl value, $Res Function(_$BuyerDetailsImpl) then) =
      __$$BuyerDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String identification,
      String address,
      String fullName,
      String accountEmail,
      DateTime birthdate});
}

/// @nodoc
class __$$BuyerDetailsImplCopyWithImpl<$Res>
    extends _$BuyerDetailsCopyWithImpl<$Res, _$BuyerDetailsImpl>
    implements _$$BuyerDetailsImplCopyWith<$Res> {
  __$$BuyerDetailsImplCopyWithImpl(
      _$BuyerDetailsImpl _value, $Res Function(_$BuyerDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identification = null,
    Object? address = null,
    Object? fullName = null,
    Object? accountEmail = null,
    Object? birthdate = null,
  }) {
    return _then(_$BuyerDetailsImpl(
      identification: null == identification
          ? _value.identification
          : identification // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      accountEmail: null == accountEmail
          ? _value.accountEmail
          : accountEmail // ignore: cast_nullable_to_non_nullable
              as String,
      birthdate: null == birthdate
          ? _value.birthdate
          : birthdate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuyerDetailsImpl implements _BuyerDetails {
  const _$BuyerDetailsImpl(
      {required this.identification,
      required this.address,
      required this.fullName,
      required this.accountEmail,
      required this.birthdate});

  factory _$BuyerDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuyerDetailsImplFromJson(json);

  /// The person or company's document.
  @override
  final String identification;

  /// The person or company's current address.
  @override
  final String address;

  /// The person or company's full name.
  @override
  final String fullName;

  /// E-mail address that this person or company uses.
  @override
  final String accountEmail;

  /// The person's birthdate, or the company's date of foundation.
  /// Has a date component only, without time.
  @override
  final DateTime birthdate;

  @override
  String toString() {
    return 'BuyerDetails(identification: $identification, address: $address, fullName: $fullName, accountEmail: $accountEmail, birthdate: $birthdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuyerDetailsImpl &&
            (identical(other.identification, identification) ||
                other.identification == identification) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.accountEmail, accountEmail) ||
                other.accountEmail == accountEmail) &&
            (identical(other.birthdate, birthdate) ||
                other.birthdate == birthdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, identification, address, fullName, accountEmail, birthdate);

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuyerDetailsImplCopyWith<_$BuyerDetailsImpl> get copyWith =>
      __$$BuyerDetailsImplCopyWithImpl<_$BuyerDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuyerDetailsImplToJson(
      this,
    );
  }
}

abstract class _BuyerDetails implements BuyerDetails {
  const factory _BuyerDetails(
      {required final String identification,
      required final String address,
      required final String fullName,
      required final String accountEmail,
      required final DateTime birthdate}) = _$BuyerDetailsImpl;

  factory _BuyerDetails.fromJson(Map<String, dynamic> json) =
      _$BuyerDetailsImpl.fromJson;

  /// The person or company's document.
  @override
  String get identification;

  /// The person or company's current address.
  @override
  String get address;

  /// The person or company's full name.
  @override
  String get fullName;

  /// E-mail address that this person or company uses.
  @override
  String get accountEmail;

  /// The person's birthdate, or the company's date of foundation.
  /// Has a date component only, without time.
  @override
  DateTime get birthdate;

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuyerDetailsImplCopyWith<_$BuyerDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
