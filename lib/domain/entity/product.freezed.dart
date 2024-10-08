// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  /// The product's unique identifier.
  String get id => throw _privateConstructorUsedError;

  /// The product's readable name.
  String get name => throw _privateConstructorUsedError;

  /// A detailed description of the product.
  String get description =>
      throw _privateConstructorUsedError; // The following property uses a different name as the json field to show
// that the names you use in the entity don't have to be the same as in
// the native code, and don't even have to be the same as in the json that
// the native code sends through the bridge.
  /// The product's amount in stock.
  @JsonKey(name: "stockAmount")
  int get amountInStock => throw _privateConstructorUsedError;

  /// The product's unit of measure.
  String get unit => throw _privateConstructorUsedError;

  /// The product's price per unit, in cents of Euro.
  ///
  /// For example, 2550 means 25 euros and 50 cents.
  /// This is merely an example, and you should store monetary quantities
  /// according to what is most appropriate to your project. Generally, it is
  /// not recommended to use double (or any floating-point numbers) for
  /// monetary values.
  ///
  /// The reason why I'm using Euro is to demonstrate formatting. Euro uses
  /// a decimal comma (ex.: 1,50 €, not €1.50). Because the default decimal
  /// separator in programming languages is the dot (.), using commas requires
  /// additional logic. Writing this example with American dollars would be
  /// too easy and less useful.
  ///
  /// Many other currencies use the comma as the decimal separator, like the
  /// Argentine Peso or the Brazilian Real.
  int get pricePerUnitCents => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      @JsonKey(name: "stockAmount") int amountInStock,
      String unit,
      int pricePerUnitCents});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? amountInStock = null,
    Object? unit = null,
    Object? pricePerUnitCents = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountInStock: null == amountInStock
          ? _value.amountInStock
          : amountInStock // ignore: cast_nullable_to_non_nullable
              as int,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerUnitCents: null == pricePerUnitCents
          ? _value.pricePerUnitCents
          : pricePerUnitCents // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      @JsonKey(name: "stockAmount") int amountInStock,
      String unit,
      int pricePerUnitCents});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? amountInStock = null,
    Object? unit = null,
    Object? pricePerUnitCents = null,
  }) {
    return _then(_$ProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountInStock: null == amountInStock
          ? _value.amountInStock
          : amountInStock // ignore: cast_nullable_to_non_nullable
              as int,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerUnitCents: null == pricePerUnitCents
          ? _value.pricePerUnitCents
          : pricePerUnitCents // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl extends _Product {
  const _$ProductImpl(
      {required this.id,
      required this.name,
      required this.description,
      @JsonKey(name: "stockAmount") required this.amountInStock,
      required this.unit,
      required this.pricePerUnitCents})
      : super._();

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  /// The product's unique identifier.
  @override
  final String id;

  /// The product's readable name.
  @override
  final String name;

  /// A detailed description of the product.
  @override
  final String description;
// The following property uses a different name as the json field to show
// that the names you use in the entity don't have to be the same as in
// the native code, and don't even have to be the same as in the json that
// the native code sends through the bridge.
  /// The product's amount in stock.
  @override
  @JsonKey(name: "stockAmount")
  final int amountInStock;

  /// The product's unit of measure.
  @override
  final String unit;

  /// The product's price per unit, in cents of Euro.
  ///
  /// For example, 2550 means 25 euros and 50 cents.
  /// This is merely an example, and you should store monetary quantities
  /// according to what is most appropriate to your project. Generally, it is
  /// not recommended to use double (or any floating-point numbers) for
  /// monetary values.
  ///
  /// The reason why I'm using Euro is to demonstrate formatting. Euro uses
  /// a decimal comma (ex.: 1,50 €, not €1.50). Because the default decimal
  /// separator in programming languages is the dot (.), using commas requires
  /// additional logic. Writing this example with American dollars would be
  /// too easy and less useful.
  ///
  /// Many other currencies use the comma as the decimal separator, like the
  /// Argentine Peso or the Brazilian Real.
  @override
  final int pricePerUnitCents;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, amountInStock: $amountInStock, unit: $unit, pricePerUnitCents: $pricePerUnitCents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amountInStock, amountInStock) ||
                other.amountInStock == amountInStock) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.pricePerUnitCents, pricePerUnitCents) ||
                other.pricePerUnitCents == pricePerUnitCents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      amountInStock, unit, pricePerUnitCents);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product extends Product {
  const factory _Product(
      {required final String id,
      required final String name,
      required final String description,
      @JsonKey(name: "stockAmount") required final int amountInStock,
      required final String unit,
      required final int pricePerUnitCents}) = _$ProductImpl;
  const _Product._() : super._();

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  /// The product's unique identifier.
  @override
  String get id;

  /// The product's readable name.
  @override
  String get name;

  /// A detailed description of the product.
  @override
  String
      get description; // The following property uses a different name as the json field to show
// that the names you use in the entity don't have to be the same as in
// the native code, and don't even have to be the same as in the json that
// the native code sends through the bridge.
  /// The product's amount in stock.
  @override
  @JsonKey(name: "stockAmount")
  int get amountInStock;

  /// The product's unit of measure.
  @override
  String get unit;

  /// The product's price per unit, in cents of Euro.
  ///
  /// For example, 2550 means 25 euros and 50 cents.
  /// This is merely an example, and you should store monetary quantities
  /// according to what is most appropriate to your project. Generally, it is
  /// not recommended to use double (or any floating-point numbers) for
  /// monetary values.
  ///
  /// The reason why I'm using Euro is to demonstrate formatting. Euro uses
  /// a decimal comma (ex.: 1,50 €, not €1.50). Because the default decimal
  /// separator in programming languages is the dot (.), using commas requires
  /// additional logic. Writing this example with American dollars would be
  /// too easy and less useful.
  ///
  /// Many other currencies use the comma as the decimal separator, like the
  /// Argentine Peso or the Brazilian Real.
  @override
  int get pricePerUnitCents;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
