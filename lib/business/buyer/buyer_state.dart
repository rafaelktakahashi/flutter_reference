// Example of state classes defined in a separate file.
//
// When you need too many classes for the state (or for the events) of a bloc,
// you can declare these classes in separate files.
// You could even create multiple files. In this example, I could've written the
// four BuyerState classes here and the four BuyerDetailsState in a separate
// file.
//
// However, generally you should avoid creating files after the bloc has been
// written, because that requires editing the imports in other files. Usually
// that's fine, but you should be careful of merge conflicts.

import 'package:flutter_reference/business/buyer/buyer_bloc.dart';
import 'package:flutter_reference/domain/entity/buyer.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "buyer_state.freezed.dart";

/// State at the start of the application, when the list has not yet been
/// fetched. After making a request, the state will not return to idle again.
class BuyerStateIdle extends BuyerState {
  const BuyerStateIdle();
}

/// Means that the list is being fetched and the user must wait until the
/// operation is complete.
class BuyerStateLoading extends BuyerState {
  const BuyerStateLoading();
}

/// Means that an error occurred when fetching the list. The user should be
/// allowed to try again.
class BuyerStateError extends BuyerState {
  final PlaygroundError error;

  const BuyerStateError({required this.error});
}

/// Means that the list of buyers has been successfully fetched.
///
/// This class has a map of details that will be empty initially. The details
/// need to be fetched individually.
///
/// (This example is for when fetching details is a costly operation.)
@freezed
class BuyerStateSuccess extends BuyerState with _$BuyerStateSuccess {
  const factory BuyerStateSuccess({
    required List<Buyer> buyers,

    /// Map from the buyer identification to the details' state. The state may be
    /// loading, error or success. If it's null, it means that the event for
    /// fetching that buyer's details has not been emitted yet.
    required Map<String, BuyerDetailsState> details,
  }) = _BuyerStateSuccess;

  // The map uses BuyerDetailsState, not the BuyerDetails entity. This is
  // because we want to be able to represent the loading/error/success state for
  // each details object individually.
  // Generally speaking, you should do this whenever you need nested requests.
  // It requires a large amount of classes, but that's simply Dart's way of
  // representing states. You can declare classes in separate files if you think
  // there are too many.
  //
  // This state class uses Freezed to generate a copyWith() method conveniently.
  // Check the product.dart file for a better explanation about how to use
  // freezed classes.
}

/// State for the details of a buyer.
///
/// The buyer bloc lets you fetch details individually. These instances of state
/// don't contain the identifier, because they're values of a map whose key is
/// the identifier of each buyer.
abstract class BuyerDetailsState {
  const BuyerDetailsState();
}

/// Means that a specific object of details is loading.
class BuyerDetailsStateLoading extends BuyerDetailsState {
  const BuyerDetailsStateLoading();
}

/// Means that fetching details for a buyer has resulted in error. The user
/// should be allowed to try again.
class BuyerDetailsStateError extends BuyerDetailsState {
  final PlaygroundError error;

  const BuyerDetailsStateError({required this.error});
}

/// Means that fetching details for a buyer has succeeded and data is available.
class BuyerDetailsStateSuccess extends BuyerDetailsState {
  final BuyerDetails data;

  const BuyerDetailsStateSuccess({required this.data});
}
