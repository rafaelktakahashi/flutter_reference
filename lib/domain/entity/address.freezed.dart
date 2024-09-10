// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Address _$AddressFromJson(Map<String, dynamic> json) {
  return _Address.fromJson(json);
}

/// @nodoc
mixin _$Address {
  /// Postal code; format and name varies by country. Sometimes called
  /// "zip code", but generally speaking that's not correct because zip codes
  /// are a system used only by the United States Postal Service (USPS).
  ///
  /// The amount of information contained in the postal code varies by country
  /// and even varies by region in each country. Generally speaking, postal
  /// codes should not be considered sufficient to deduce an entire address.
  ///
  /// Examples:
  /// "48227" (Detroit, Michigan, USA)
  /// "13010-180" (Praça dos Ferroviários, Campinas, SP, Brazil)
  /// "849-0500" (Kohoku-machi, Kishima-gun, Saga-ken, Japan)
  ///
  /// This class is merely an example, and in your case you may only need to
  /// handle addresses in one or a few countries. This class assembles the
  /// address as is done in the US and the UK, with building number first,
  /// then street name, then city, state, postal code and country. Other
  /// countries follow their own schemes, for example:
  /// - Brazilian addresses place the building number after the street name,
  /// and also include a neighborhood name (bairro) after the number. They
  /// also don't typically include the postal code (CEP) inside the written
  /// address.
  /// - Japanese addresses are written in order of largest unit to smallest,
  /// starting with the prefecture (todofuken), then a municipality (shi/ku/
  /// gun), followed by either the city (cho/machi) and district (chome) or
  /// aza, and then the building number (go). Addresses in Japan do not
  /// include the street name, and there are very many exceptions and special
  /// cases where a region may have its own address structure that deviates
  /// from the standard.
  String get postalCode => throw _privateConstructorUsedError;

  /// Most specific part of an address. Varies by country, but here it always
  /// covers everything that's more specific than the city.
  String get streetAddress => throw _privateConstructorUsedError;

  /// Number, which may contain non-numeric digits as well (ex.: "10b").
  /// If the address does not have a number, use null.
  String? get number => throw _privateConstructorUsedError;

  /// Full name of the city.
  String get city => throw _privateConstructorUsedError;

  /// Name or abbreviation for the highest administrative division of the
  /// country, which may be a state, oblast, canton, prefecture, provice or
  /// region among many other names.
  /// Ex.: "SP" (State in Brazil), "MI" (State in the USA),
  /// "Черка́ська о́бласть" (Oblast in Ukraine), "沖縄県" (Prefecture in Japan)
  String get state => throw _privateConstructorUsedError;

  /// Localized name of the country, in the same language as the rest of the
  /// address. Ex.: "USA", "Brasil", "Ελλάδα"
  String get country => throw _privateConstructorUsedError;

  /// Serializes this Address to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressCopyWith<Address> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressCopyWith<$Res> {
  factory $AddressCopyWith(Address value, $Res Function(Address) then) =
      _$AddressCopyWithImpl<$Res, Address>;
  @useResult
  $Res call(
      {String postalCode,
      String streetAddress,
      String? number,
      String city,
      String state,
      String country});
}

/// @nodoc
class _$AddressCopyWithImpl<$Res, $Val extends Address>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postalCode = null,
    Object? streetAddress = null,
    Object? number = freezed,
    Object? city = null,
    Object? state = null,
    Object? country = null,
  }) {
    return _then(_value.copyWith(
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      streetAddress: null == streetAddress
          ? _value.streetAddress
          : streetAddress // ignore: cast_nullable_to_non_nullable
              as String,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressImplCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$$AddressImplCopyWith(
          _$AddressImpl value, $Res Function(_$AddressImpl) then) =
      __$$AddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String postalCode,
      String streetAddress,
      String? number,
      String city,
      String state,
      String country});
}

/// @nodoc
class __$$AddressImplCopyWithImpl<$Res>
    extends _$AddressCopyWithImpl<$Res, _$AddressImpl>
    implements _$$AddressImplCopyWith<$Res> {
  __$$AddressImplCopyWithImpl(
      _$AddressImpl _value, $Res Function(_$AddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postalCode = null,
    Object? streetAddress = null,
    Object? number = freezed,
    Object? city = null,
    Object? state = null,
    Object? country = null,
  }) {
    return _then(_$AddressImpl(
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      streetAddress: null == streetAddress
          ? _value.streetAddress
          : streetAddress // ignore: cast_nullable_to_non_nullable
              as String,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressImpl extends _Address {
  const _$AddressImpl(
      {required this.postalCode,
      required this.streetAddress,
      this.number,
      required this.city,
      required this.state,
      required this.country})
      : super._();

  factory _$AddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressImplFromJson(json);

  /// Postal code; format and name varies by country. Sometimes called
  /// "zip code", but generally speaking that's not correct because zip codes
  /// are a system used only by the United States Postal Service (USPS).
  ///
  /// The amount of information contained in the postal code varies by country
  /// and even varies by region in each country. Generally speaking, postal
  /// codes should not be considered sufficient to deduce an entire address.
  ///
  /// Examples:
  /// "48227" (Detroit, Michigan, USA)
  /// "13010-180" (Praça dos Ferroviários, Campinas, SP, Brazil)
  /// "849-0500" (Kohoku-machi, Kishima-gun, Saga-ken, Japan)
  ///
  /// This class is merely an example, and in your case you may only need to
  /// handle addresses in one or a few countries. This class assembles the
  /// address as is done in the US and the UK, with building number first,
  /// then street name, then city, state, postal code and country. Other
  /// countries follow their own schemes, for example:
  /// - Brazilian addresses place the building number after the street name,
  /// and also include a neighborhood name (bairro) after the number. They
  /// also don't typically include the postal code (CEP) inside the written
  /// address.
  /// - Japanese addresses are written in order of largest unit to smallest,
  /// starting with the prefecture (todofuken), then a municipality (shi/ku/
  /// gun), followed by either the city (cho/machi) and district (chome) or
  /// aza, and then the building number (go). Addresses in Japan do not
  /// include the street name, and there are very many exceptions and special
  /// cases where a region may have its own address structure that deviates
  /// from the standard.
  @override
  final String postalCode;

  /// Most specific part of an address. Varies by country, but here it always
  /// covers everything that's more specific than the city.
  @override
  final String streetAddress;

  /// Number, which may contain non-numeric digits as well (ex.: "10b").
  /// If the address does not have a number, use null.
  @override
  final String? number;

  /// Full name of the city.
  @override
  final String city;

  /// Name or abbreviation for the highest administrative division of the
  /// country, which may be a state, oblast, canton, prefecture, provice or
  /// region among many other names.
  /// Ex.: "SP" (State in Brazil), "MI" (State in the USA),
  /// "Черка́ська о́бласть" (Oblast in Ukraine), "沖縄県" (Prefecture in Japan)
  @override
  final String state;

  /// Localized name of the country, in the same language as the rest of the
  /// address. Ex.: "USA", "Brasil", "Ελλάδα"
  @override
  final String country;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressImpl &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.streetAddress, streetAddress) ||
                other.streetAddress == streetAddress) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, postalCode, streetAddress, number, city, state, country);

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      __$$AddressImplCopyWithImpl<_$AddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressImplToJson(
      this,
    );
  }
}

abstract class _Address extends Address {
  const factory _Address(
      {required final String postalCode,
      required final String streetAddress,
      final String? number,
      required final String city,
      required final String state,
      required final String country}) = _$AddressImpl;
  const _Address._() : super._();

  factory _Address.fromJson(Map<String, dynamic> json) = _$AddressImpl.fromJson;

  /// Postal code; format and name varies by country. Sometimes called
  /// "zip code", but generally speaking that's not correct because zip codes
  /// are a system used only by the United States Postal Service (USPS).
  ///
  /// The amount of information contained in the postal code varies by country
  /// and even varies by region in each country. Generally speaking, postal
  /// codes should not be considered sufficient to deduce an entire address.
  ///
  /// Examples:
  /// "48227" (Detroit, Michigan, USA)
  /// "13010-180" (Praça dos Ferroviários, Campinas, SP, Brazil)
  /// "849-0500" (Kohoku-machi, Kishima-gun, Saga-ken, Japan)
  ///
  /// This class is merely an example, and in your case you may only need to
  /// handle addresses in one or a few countries. This class assembles the
  /// address as is done in the US and the UK, with building number first,
  /// then street name, then city, state, postal code and country. Other
  /// countries follow their own schemes, for example:
  /// - Brazilian addresses place the building number after the street name,
  /// and also include a neighborhood name (bairro) after the number. They
  /// also don't typically include the postal code (CEP) inside the written
  /// address.
  /// - Japanese addresses are written in order of largest unit to smallest,
  /// starting with the prefecture (todofuken), then a municipality (shi/ku/
  /// gun), followed by either the city (cho/machi) and district (chome) or
  /// aza, and then the building number (go). Addresses in Japan do not
  /// include the street name, and there are very many exceptions and special
  /// cases where a region may have its own address structure that deviates
  /// from the standard.
  @override
  String get postalCode;

  /// Most specific part of an address. Varies by country, but here it always
  /// covers everything that's more specific than the city.
  @override
  String get streetAddress;

  /// Number, which may contain non-numeric digits as well (ex.: "10b").
  /// If the address does not have a number, use null.
  @override
  String? get number;

  /// Full name of the city.
  @override
  String get city;

  /// Name or abbreviation for the highest administrative division of the
  /// country, which may be a state, oblast, canton, prefecture, provice or
  /// region among many other names.
  /// Ex.: "SP" (State in Brazil), "MI" (State in the USA),
  /// "Черка́ська о́бласть" (Oblast in Ukraine), "沖縄県" (Prefecture in Japan)
  @override
  String get state;

  /// Localized name of the country, in the same language as the rest of the
  /// address. Ex.: "USA", "Brasil", "Ελλάδα"
  @override
  String get country;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
