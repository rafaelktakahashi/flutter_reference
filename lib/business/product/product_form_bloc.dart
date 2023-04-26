import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:get_it/get_it.dart';

/////////////
/// EVENT ///
/////////////

abstract class ProductFormEvent {
  const ProductFormEvent();
}

class SubmitProductEvent extends ProductFormEvent {
  final Product newProduct;
  SubmitProductEvent(this.newProduct);
}

/////////////
/// STATE ///
/////////////

abstract class ProductFormState {
  const ProductFormState();
}

class ProductFormStateSuccess extends ProductFormState {
  const ProductFormStateSuccess();
}

class ProductFormStateSubmitting extends ProductFormState {
  const ProductFormStateSubmitting();
}

class ProductFormStateError extends ProductFormState {
  const ProductFormStateError();
  // You could also add an error message here.
}

/////////////
/// BLOC ///
/////////////
///
/// This bloc is pretty much the simplest possible example, because it contains
/// the logic for just one request, and only for displaying the current state
/// of that request.
///
/// This demonstrates that a bloc can be created for very simple use cases.
/// However, it would also be correct to merge multiple blocs if you believe
/// their logic belongs in the same place.
///
/// It's possible to put the form's data here, and then all the validation
/// logic would also occur in the bloc. This is advisable for complex forms
/// only, where using the Form's built-in validation is not sufficient.
///
/// Currently, this bloc is nothing more than a simple state machine with three
/// states.
class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  final productRepository = GetIt.I.get<ProductRepository>();

  // In this case the initial state doesn't matter, because the page that uses
  // this bloc will always be loaded when a request has just started. But you
  // can also create an "idle" state if you judge it useful.
  ProductFormBloc() : super(const ProductFormStateSuccess()) {
    on<SubmitProductEvent>((event, emit) async {
      // This is the bread-and-butter of all requests made in blocs.
      // Different blocs will have different details, but generally you'll
      // always follow the basic of setting the state to loading, then making
      // the request, then setting the state to success or error.
      emit(const ProductFormStateSubmitting());
      final result = await productRepository.saveProduct(event.newProduct);

      result.fold((l) {
        // I recommend putting the error in the state.
        // I should be doing that here.
        emit(const ProductFormStateError());
      }, (r) {
        emit(const ProductFormStateSuccess());
      });
    });
  }
}
