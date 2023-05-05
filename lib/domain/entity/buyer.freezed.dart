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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Buyer _$BuyerFromJson(Map<String, dynamic> json) {
  return _Buyer.fromJson(json);
}

/// @nodoc
mixin _$Buyer {
  /// The person or company's document.
  String get identification => throw _privateConstructorUsedError;

  /// The person or company's full name.
  String get fullName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
abstract class _$$_BuyerCopyWith<$Res> implements $BuyerCopyWith<$Res> {
  factory _$$_BuyerCopyWith(_$_Buyer value, $Res Function(_$_Buyer) then) =
      __$$_BuyerCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String identification, String fullName});
}

/// @nodoc
class __$$_BuyerCopyWithImpl<$Res> extends _$BuyerCopyWithImpl<$Res, _$_Buyer>
    implements _$$_BuyerCopyWith<$Res> {
  __$$_BuyerCopyWithImpl(_$_Buyer _value, $Res Function(_$_Buyer) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identification = null,
    Object? fullName = null,
  }) {
    return _then(_$_Buyer(
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
class _$_Buyer implements _Buyer {
  const _$_Buyer({required this.identification, required this.fullName});

  factory _$_Buyer.fromJson(Map<String, dynamic> json) =>
      _$$_BuyerFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Buyer &&
            (identical(other.identification, identification) ||
                other.identification == identification) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, identification, fullName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BuyerCopyWith<_$_Buyer> get copyWith =>
      __$$_BuyerCopyWithImpl<_$_Buyer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BuyerToJson(
      this,
    );
  }
}

abstract class _Buyer implements Buyer {
  const factory _Buyer(
      {required final String identification,
      required final String fullName}) = _$_Buyer;

  factory _Buyer.fromJson(Map<String, dynamic> json) = _$_Buyer.fromJson;

  @override

  /// The person or company's document.
  String get identification;
  @override

  /// The person or company's full name.
  String get fullName;
  @override
  @JsonKey(ignore: true)
  _$$_BuyerCopyWith<_$_Buyer> get copyWith =>
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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
abstract class _$$_BuyerDetailsCopyWith<$Res>
    implements $BuyerDetailsCopyWith<$Res> {
  factory _$$_BuyerDetailsCopyWith(
          _$_BuyerDetails value, $Res Function(_$_BuyerDetails) then) =
      __$$_BuyerDetailsCopyWithImpl<$Res>;
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
class __$$_BuyerDetailsCopyWithImpl<$Res>
    extends _$BuyerDetailsCopyWithImpl<$Res, _$_BuyerDetails>
    implements _$$_BuyerDetailsCopyWith<$Res> {
  __$$_BuyerDetailsCopyWithImpl(
      _$_BuyerDetails _value, $Res Function(_$_BuyerDetails) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identification = null,
    Object? address = null,
    Object? fullName = null,
    Object? accountEmail = null,
    Object? birthdate = null,
  }) {
    return _then(_$_BuyerDetails(
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
class _$_BuyerDetails implements _BuyerDetails {
  const _$_BuyerDetails(
      {required this.identification,
      required this.address,
      required this.fullName,
      required this.accountEmail,
      required this.birthdate});

  factory _$_BuyerDetails.fromJson(Map<String, dynamic> json) =>
      _$$_BuyerDetailsFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BuyerDetails &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, identification, address, fullName, accountEmail, birthdate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BuyerDetailsCopyWith<_$_BuyerDetails> get copyWith =>
      __$$_BuyerDetailsCopyWithImpl<_$_BuyerDetails>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BuyerDetailsToJson(
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
      required final DateTime birthdate}) = _$_BuyerDetails;

  factory _BuyerDetails.fromJson(Map<String, dynamic> json) =
      _$_BuyerDetails.fromJson;

  @override

  /// The person or company's document.
  String get identification;
  @override

  /// The person or company's current address.
  String get address;
  @override

  /// The person or company's full name.
  String get fullName;
  @override

  /// E-mail address that this person or company uses.
  String get accountEmail;
  @override

  /// The person's birthdate, or the company's date of foundation.
  /// Has a date component only, without time.
  DateTime get birthdate;
  @override
  @JsonKey(ignore: true)
  _$$_BuyerDetailsCopyWith<_$_BuyerDetails> get copyWith =>
      throw _privateConstructorUsedError;
}
