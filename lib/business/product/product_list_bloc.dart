import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';
import 'package:get_it/get_it.dart';

///////////////
/// PREFACE ///
///////////////
/// At first sight, this may look like an excessive amount of code just for
/// a simple list. That's true because this app is a minimal sample for
/// showcasing a Flutter project structure. In reality, you could also add
/// much more logic here for filtering the list, selecting an item in the list
/// for showing its details in a separate page, firing custom actions for each
/// item like saving or adding to favorites, etc.
///
/// Any page in the application can use this bloc. The bloc is not "made for"
/// any specific page.

/////////////
/// EVENT ///
/////////////

abstract class ProductEvent {
  const ProductEvent();
}

/// Causes a remote request to fetch the list of products.
class FetchProductsEvent extends ProductEvent {
  const FetchProductsEvent();
}

/// Immediately add a product to the local bloc, without making requests.
/// Use this when a product has already been uploaded and needs to be added
/// to the local list. However, this will cause a remote request if a local
/// list isn't already available.
///
/// In either case, the product in this event will not be uploaded.
class AddProductEvent extends ProductEvent {
  final Product product;
  const AddProductEvent(this.product);
}

/////////////
/// STATE ///
/// /////////

/// This state uses the pattern of "1 abstract class, N implementations".
/// Each implementation represents a different state with different amounts
/// of information in it.
///
/// Look at the product form bloc for a different example.
abstract class ProductState {
  const ProductState();
}

class ProductStateEmpty extends ProductState {
  const ProductStateEmpty();
}

class ProductStateList extends ProductState {
  final List<Product> products;
  const ProductStateList(this.products);
}

class ProductStateLoading extends ProductState {
  const ProductStateLoading();
}

class ProductStateError extends ProductState {
  final PlaygroundError error;
  const ProductStateError(this.error);
}

////////////
/// BLOC ///
////////////

/// Bloc for just the list of products, displayed in the list of products.
class ProductListBloc extends Bloc<ProductEvent, ProductState> {
  ProductListBloc() : super(const ProductStateEmpty()) {
    // Register event handlers
    super.on<FetchProductsEvent>(_handleFetch);
    super.on<AddProductEvent>(_handleAdd);
  }

  /// Repository for fetching products.
  final ProductRepository _productRepository = GetIt.I.get<ProductRepository>();

  /// Handler for fetching products.
  void _handleFetch(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    // Immediately set the state to loading.
    emit(const ProductStateLoading());

    // Make the request, then emit the list or an error.
    (await _productRepository.fetchProduct()).fold(
      (l) => emit(ProductStateError(l)),
      (r) => emit(ProductStateList(r)),
    );
  }

  /// Handler for adding a product to the local list (does not upload the
  /// product to the server).
  void _handleAdd(AddProductEvent event, Emitter<ProductState> emit) async {
    // Only respond if the current state has a loaded list.
    // If it doesn't, then we add an event to load the list remotely.
    // (This is an example of a business rule. You'll have your own rules
    // to implement in your handlers.)
    ProductState currentState = state;
    if (currentState is! ProductStateList) {
      add(const FetchProductsEvent());
      return;
    }

    // Add the product to the local list. This causes no side effects.
    final newList = currentState.products.followedBy([event.product]);
    // Then emit a new state with the new list.
    emit(ProductStateList(newList.toList()));
  }
}
