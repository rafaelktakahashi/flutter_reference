// This bloc is only used in the inter-bloc communications demo.
// The logic here is a simplified version of the product list bloc.
// This bloc produces a different list depending on whether the user is an
// admin or a regular user, and also automatically clears its contents when the
// user logs out.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:get_it/get_it.dart';

import '../../domain/error/playground_error.dart';

// EVENTS
abstract class Bloc1Event {
  const Bloc1Event();
}

class FetchProducts1Event extends Bloc1Event {
  const FetchProducts1Event();
}

// STATE
abstract class Bloc1State {
  const Bloc1State();
}

class Bloc1StateEmpty extends Bloc1State {
  const Bloc1StateEmpty();
}

class Bloc1StateList extends Bloc1State {
  final List<Product> products;
  const Bloc1StateList(this.products);
}

class Bloc1StateLoading extends Bloc1State {
  const Bloc1StateLoading();
}

class Bloc1StateError extends Bloc1State {
  final PlaygroundError error;
  const Bloc1StateError(this.error);
}

// BLOC

class Bloc1 extends Bloc<Bloc1Event, Bloc1State> {
  Bloc1() : super(const Bloc1StateEmpty()) {
    // Register event handlers
  }

  final ProductRepository _productRepository = GetIt.I.get<ProductRepository>();

  // Handler for fetching products.
  // We simulate fetching more items if the user is an admin.
  // We do that by simply removing all items but one if the user is a regular
  // user. The logic here isn't important.
  void _handleFetch(FetchProducts1Event event, Emitter<Bloc1State> emit) async {
    if (state is Bloc1StateLoading) {
      return;
    }

    emit(const Bloc1StateLoading());

    (await _productRepository.fetchProduct()).fold(
      (l) => emit(Bloc1StateError(l)),
      (r) {
        // TODO: Condition.
        // Ignore this code! I'm cutting the list unless the user is an admin,
        // to simulate a different list for different users.
        if (int.parse("1") == 1) {
          emit(Bloc1StateList(r.sublist(0, 1)));
        } else {
          emit(Bloc1StateList(r));
        }
      },
    );
  }
}
