import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/domain/error/megastore_business_error.dart';
import 'package:flutter_reference/domain/error/megastore_error.dart';
import 'package:flutter_reference/domain/entity/product.dart';
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
/// This will cause validation data to appear in the state, so you probably
/// don't want to emit this event on every keypress, probably only on blur
/// when all fields have been visited.
/// Any field that is omitted will cause no changes in the state.
class UpdateProductFormFieldsEvent extends ProductFormEvent {
  final String? identifier;
  final String? name;
  final String? description;
  final int? stockAmount;
  final String? unit;
  const UpdateProductFormFieldsEvent({
    this.identifier,
    this.name,
    this.description,
    this.stockAmount,
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
    @Default(0) int stockAmount,
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
  void _handleUpdateForm(UpdateProductFormFieldsEvent event,
      Emitter<ProductFormState> emit) async {
    // First, we get a new form state and copy it with the data from
    // the event.
    final eventCopy = state.copyWith(
      identifier: event.identifier ?? state.identifier,
      name: event.name ?? state.name,
      description: event.description ?? state.description,
      stockAmount: event.stockAmount ?? state.stockAmount,
      unit: event.unit ?? state.unit,
      submitState: ProductFormSubmitState.idle,
      submitError: const None(),
    );
    // Now we need to compute any errors.
    // If you have many rules, you could place the handler in a separate file.
    final validationErrors = <String, String>{};
    if (int.tryParse(eventCopy.unit) == null) {
      validationErrors["stockAmount"] = "Stock amount can't be negative.";
    }

    if (validationErrors.isEmpty) {
      emit(eventCopy.copyWith(validationError: const None()));
    } else {
      emit(eventCopy.copyWith(validationError: Some(validationErrors)));
    }
  }

  /// Handler for submitting the form.
  /// This can fail if there's a validation error in the form.
  void _handleSubmitForm(
      SubmitProductFormEvent event, Emitter<ProductFormState> emit) async {
    // Cause an error (locally) if there's a validation error.
    if (state.validationError.isSome()) {
      emit(state.copyWith(
        submitState: ProductFormSubmitState.error,
        submitError: const Some(MegastoreBusinessError(
          "MGS-2001",
          "Form cannot be submitted while it has errors.",
          blocName: "product_form",
        )),
      ));
    }

    // Immediately set the state to submitting while the request happens.
    emit(state.copyWith(submitState: ProductFormSubmitState.submitting));
    (await _productRepository.saveProduct(Product(
      id: state.identifier,
      name: state.name,
      description: state.description,
      stockAmount: state.stockAmount,
      unit: state.unit,
    )))
        .fold(
      (l) => emit(
        state.copyWith(
            submitState: ProductFormSubmitState.error, submitError: Some(l)),
      ),
      (r) => emit(
        state.copyWith(
          submitState: ProductFormSubmitState.success,
        ),
      ),
    );
  }
}
