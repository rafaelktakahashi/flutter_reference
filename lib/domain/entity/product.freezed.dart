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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
  String get description => throw _privateConstructorUsedError;

  /// The product's amount in stock.
  int get stockAmount => throw _privateConstructorUsedError;

  /// The product's unit of measure.
  String get unit => throw _privateConstructorUsedError;

  /// The product's price per unit, in cents of US$.
  /// For example, 2550 means 25 US dollars and 50 cents.
  /// This is merely and example, and you should store monetary quantities
  /// according to what is most appropriate to your project.
  int get pricePerUnitCents => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      int stockAmount,
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? stockAmount = null,
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
      stockAmount: null == stockAmount
          ? _value.stockAmount
          : stockAmount // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$_ProductCopyWith(
          _$_Product value, $Res Function(_$_Product) then) =
      __$$_ProductCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int stockAmount,
      String unit,
      int pricePerUnitCents});
}

/// @nodoc
class __$$_ProductCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$_Product>
    implements _$$_ProductCopyWith<$Res> {
  __$$_ProductCopyWithImpl(_$_Product _value, $Res Function(_$_Product) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? stockAmount = null,
    Object? unit = null,
    Object? pricePerUnitCents = null,
  }) {
    return _then(_$_Product(
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
      stockAmount: null == stockAmount
          ? _value.stockAmount
          : stockAmount // ignore: cast_nullable_to_non_nullable
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
class _$_Product implements _Product {
  const _$_Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.stockAmount,
      required this.unit,
      required this.pricePerUnitCents});

  factory _$_Product.fromJson(Map<String, dynamic> json) =>
      _$$_ProductFromJson(json);

  /// The product's unique identifier.
  @override
  final String id;

  /// The product's readable name.
  @override
  final String name;

  /// A detailed description of the product.
  @override
  final String description;

  /// The product's amount in stock.
  @override
  final int stockAmount;

  /// The product's unit of measure.
  @override
  final String unit;

  /// The product's price per unit, in cents of US$.
  /// For example, 2550 means 25 US dollars and 50 cents.
  /// This is merely and example, and you should store monetary quantities
  /// according to what is most appropriate to your project.
  @override
  final int pricePerUnitCents;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, stockAmount: $stockAmount, unit: $unit, pricePerUnitCents: $pricePerUnitCents)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Product &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.stockAmount, stockAmount) ||
                other.stockAmount == stockAmount) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.pricePerUnitCents, pricePerUnitCents) ||
                other.pricePerUnitCents == pricePerUnitCents));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, description, stockAmount, unit, pricePerUnitCents);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProductCopyWith<_$_Product> get copyWith =>
      __$$_ProductCopyWithImpl<_$_Product>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProductToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  const factory _Product(
      {required final String id,
      required final String name,
      required final String description,
      required final int stockAmount,
      required final String unit,
      required final int pricePerUnitCents}) = _$_Product;

  factory _Product.fromJson(Map<String, dynamic> json) = _$_Product.fromJson;

  @override

  /// The product's unique identifier.
  String get id;
  @override

  /// The product's readable name.
  String get name;
  @override

  /// A detailed description of the product.
  String get description;
  @override

  /// The product's amount in stock.
  int get stockAmount;
  @override

  /// The product's unit of measure.
  String get unit;
  @override

  /// The product's price per unit, in cents of US$.
  /// For example, 2550 means 25 US dollars and 50 cents.
  /// This is merely and example, and you should store monetary quantities
  /// according to what is most appropriate to your project.
  int get pricePerUnitCents;
  @override
  @JsonKey(ignore: true)
  _$$_ProductCopyWith<_$_Product> get copyWith =>
      throw _privateConstructorUsedError;
}
