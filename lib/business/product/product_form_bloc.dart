import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/domain/error/megastore_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

part "product_form_bloc.freezed.dart";

///////////////
/// PREFACE ///
///////////////
/// Bloc for a form.
/// Forms that use validation logic in the bloc should use controlled
/// components, frequently updating their state in order to run validation
/// logic in the bloc.

/////////////
/// EVENT ///
/////////////

abstract class ProductFormEvent {
  const ProductFormEvent();
}

/// Update this bloc with new data from the form.
/// This will cause validation data to appear in the state.
/// Any field that is omitted will cause no changes in the state.
class UpdateProductFormFieldsEvent extends ProductFormEvent {
  final String? identifier;
  final String? name;
  final String? description;
  final int? quantity;
  final String? unit;
  const UpdateProductFormFieldsEvent({
    this.identifier,
    this.name,
    this.description,
    this.quantity,
    this.unit,
  });
}

/// Attempt to submit the form. Check the "submitState" field for the status
/// on the attempt.
class SubmitProductFormEvent extends ProductFormEvent {
  const SubmitProductFormEvent();
}

/////////////
/// STATE ///
/////////////

/// State for the submission in the product form.
enum ProductFormSubmitState {
  idle,
  submitting,
  error,
  success,
}

/// This state uses the pattern of "1 state class" with all necessary data in
/// it, because this bloc doesn't have multiple states with different fields.
///
/// Look at the product list bloc for a different example.
///
/// Just like all entity classes, bloc state classes don't have any logic in
/// them. While we _could_ theoretically put the validation logic in a getter
/// here, that would be wrong place for it. All business logic (including
/// form validation) happens the bloc.
@freezed
class ProductFormState with _$ProductFormState {
  const factory ProductFormState({
    @Default("") String identifier,
    @Default("") String name,
    @Default("") String description,
    @Default(0) int quantity,
    @Default("") String unit,
    @Default(None()) Option<MegastoreError> submitError,
    @Default(None()) Option<Map<String, String>> validationError,
    @Default(ProductFormSubmitState.idle) ProductFormSubmitState submitState,
  }) = _ProductFormState;
}

////////////
/// BLOC ///
////////////

/// Bloc for the product form.
/// Currently, this sample app only supports adding new products, but if you
/// wanted to edit an existing item, you could reuse this bloc for that too.
/// Then you'd need a flag for when an existing item is being edited.
class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc() : super(const ProductFormState()) {
    // Register event handlers
    super.on<UpdateProductFormFieldsEvent>(_handleUpdateForm);
  }

  /// Repository for fetching a new product.
  final ProductRepository _productRepository = GetIt.I.get<ProductRepository>();

  /// Handler for updating this bloc with whatever exists in the event.
  /// The update will always be successful; if some invalid field is used,
  /// then a validation error will appear in the state.
  void _handleUpdateForm(
      UpdateProductFormFieldsEvent event, Emitter<ProductFormState> emit) {
    // First, we get a new form state.
  }

  /// Handler for submitting the form.
  /// This can fail if there's a validation error in the form.
  void _handleSubmitForm(
      SubmitProductFormEvent event, Emitter<ProductFormState> emit) {}
}
