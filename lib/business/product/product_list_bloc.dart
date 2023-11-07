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
/// (this demo app doesn't use a real remote request for this, only a mock)
///
/// Normally, this always causes a fetch, regardless of whether there's data
/// loaded or not. However, the fetch will **always** be skipped if there's
/// already a fetch in progress. This means that sending this event multiple
/// times in sequence will not cause multiple requests.
///
/// Also, this will typically cause a new request even if there's already
/// some data loaded. Specifying [skipIfAlreadyLoaded] as true will make the
/// bloc ignore this event if the list is already loaded.
///
/// Please, always document your events and what they do.
class FetchProductsEvent extends ProductEvent {
  final bool skipIfAlreadyLoaded;
  const FetchProductsEvent({
    this.skipIfAlreadyLoaded = false,
  });
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
  }

  /// Repository for fetching products.
  final ProductRepository _productRepository = GetIt.I.get<ProductRepository>();

  /// Handler for fetching products.
  void _handleFetch(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    // As we describe in the documentation for the event, there are two cases
    // when we ignore the fetch:

    // 1. When there's already a fetch in progress.
    if (state is ProductStateLoading) {
      return;
    }

    // 2. When there's data already loaded and the event has a flag for not
    // refetching data.
    if (state is ProductStateList && event.skipIfAlreadyLoaded) {
      return;
    }

    // Immediately set the state to loading.
    emit(const ProductStateLoading());

    // Make the request, then emit the list or an error.
    (await _productRepository.fetchProduct()).fold(
      (l) => emit(ProductStateError(l)),
      (r) => emit(ProductStateList(r)),
    );
  }
}
