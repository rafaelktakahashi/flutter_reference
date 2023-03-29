// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_form_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProductFormState {
  String get identifier => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get stockAmount => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  Option<PlaygroundError> get submitError => throw _privateConstructorUsedError;
  Option<Map<String, String>> get validationError =>
      throw _privateConstructorUsedError;
  ProductFormSubmitState get submitState => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProductFormStateCopyWith<ProductFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductFormStateCopyWith<$Res> {
  factory $ProductFormStateCopyWith(
          ProductFormState value, $Res Function(ProductFormState) then) =
      _$ProductFormStateCopyWithImpl<$Res, ProductFormState>;
  @useResult
  $Res call(
      {String identifier,
      String name,
      String description,
      int stockAmount,
      String unit,
      Option<PlaygroundError> submitError,
      Option<Map<String, String>> validationError,
      ProductFormSubmitState submitState});
}

/// @nodoc
class _$ProductFormStateCopyWithImpl<$Res, $Val extends ProductFormState>
    implements $ProductFormStateCopyWith<$Res> {
  _$ProductFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? name = null,
    Object? description = null,
    Object? stockAmount = null,
    Object? unit = null,
    Object? submitError = null,
    Object? validationError = null,
    Object? submitState = null,
  }) {
    return _then(_value.copyWith(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
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
      submitError: null == submitError
          ? _value.submitError
          : submitError // ignore: cast_nullable_to_non_nullable
              as Option<PlaygroundError>,
      validationError: null == validationError
          ? _value.validationError
          : validationError // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, String>>,
      submitState: null == submitState
          ? _value.submitState
          : submitState // ignore: cast_nullable_to_non_nullable
              as ProductFormSubmitState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProductFormStateCopyWith<$Res>
    implements $ProductFormStateCopyWith<$Res> {
  factory _$$_ProductFormStateCopyWith(
          _$_ProductFormState value, $Res Function(_$_ProductFormState) then) =
      __$$_ProductFormStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String identifier,
      String name,
      String description,
      int stockAmount,
      String unit,
      Option<PlaygroundError> submitError,
      Option<Map<String, String>> validationError,
      ProductFormSubmitState submitState});
}

/// @nodoc
class __$$_ProductFormStateCopyWithImpl<$Res>
    extends _$ProductFormStateCopyWithImpl<$Res, _$_ProductFormState>
    implements _$$_ProductFormStateCopyWith<$Res> {
  __$$_ProductFormStateCopyWithImpl(
      _$_ProductFormState _value, $Res Function(_$_ProductFormState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? name = null,
    Object? description = null,
    Object? stockAmount = null,
    Object? unit = null,
    Object? submitError = null,
    Object? validationError = null,
    Object? submitState = null,
  }) {
    return _then(_$_ProductFormState(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
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
      submitError: null == submitError
          ? _value.submitError
          : submitError // ignore: cast_nullable_to_non_nullable
              as Option<PlaygroundError>,
      validationError: null == validationError
          ? _value.validationError
          : validationError // ignore: cast_nullable_to_non_nullable
              as Option<Map<String, String>>,
      submitState: null == submitState
          ? _value.submitState
          : submitState // ignore: cast_nullable_to_non_nullable
              as ProductFormSubmitState,
    ));
  }
}

/// @nodoc

class _$_ProductFormState
    with DiagnosticableTreeMixin
    implements _ProductFormState {
  const _$_ProductFormState(
      {this.identifier = "",
      this.name = "",
      this.description = "",
      this.stockAmount = 0,
      this.unit = "",
      this.submitError = const None(),
      this.validationError = const None(),
      this.submitState = ProductFormSubmitState.idle});

  @override
  @JsonKey()
  final String identifier;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int stockAmount;
  @override
  @JsonKey()
  final String unit;
  @override
  @JsonKey()
  final Option<PlaygroundError> submitError;
  @override
  @JsonKey()
  final Option<Map<String, String>> validationError;
  @override
  @JsonKey()
  final ProductFormSubmitState submitState;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductFormState(identifier: $identifier, name: $name, description: $description, stockAmount: $stockAmount, unit: $unit, submitError: $submitError, validationError: $validationError, submitState: $submitState)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductFormState'))
      ..add(DiagnosticsProperty('identifier', identifier))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('stockAmount', stockAmount))
      ..add(DiagnosticsProperty('unit', unit))
      ..add(DiagnosticsProperty('submitError', submitError))
      ..add(DiagnosticsProperty('validationError', validationError))
      ..add(DiagnosticsProperty('submitState', submitState));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProductFormState &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.stockAmount, stockAmount) ||
                other.stockAmount == stockAmount) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError) &&
            (identical(other.validationError, validationError) ||
                other.validationError == validationError) &&
            (identical(other.submitState, submitState) ||
                other.submitState == submitState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, identifier, name, description,
      stockAmount, unit, submitError, validationError, submitState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProductFormStateCopyWith<_$_ProductFormState> get copyWith =>
      __$$_ProductFormStateCopyWithImpl<_$_ProductFormState>(this, _$identity);
}

abstract class _ProductFormState implements ProductFormState {
  const factory _ProductFormState(
      {final String identifier,
      final String name,
      final String description,
      final int stockAmount,
      final String unit,
      final Option<PlaygroundError> submitError,
      final Option<Map<String, String>> validationError,
      final ProductFormSubmitState submitState}) = _$_ProductFormState;

  @override
  String get identifier;
  @override
  String get name;
  @override
  String get description;
  @override
  int get stockAmount;
  @override
  String get unit;
  @override
  Option<PlaygroundError> get submitError;
  @override
  Option<Map<String, String>> get validationError;
  @override
  ProductFormSubmitState get submitState;
  @override
  @JsonKey(ignore: true)
  _$$_ProductFormStateCopyWith<_$_ProductFormState> get copyWith =>
      throw _privateConstructorUsedError;
}
