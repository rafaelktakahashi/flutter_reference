// This is an identical copy of Bloc1. For demonstration purposes only.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:get_it/get_it.dart';

import '../../domain/error/playground_error.dart';

// EVENTS
abstract class Bloc2Event {
  const Bloc2Event();
}

class FetchProducts2Event extends Bloc2Event {
  const FetchProducts2Event();
}

// STATE
abstract class Bloc2State {
  const Bloc2State();
}

class Bloc2StateEmpty extends Bloc2State {
  const Bloc2StateEmpty();
}

class Bloc2StateList extends Bloc2State {
  final List<Product> products;
  const Bloc2StateList(this.products);
}

class Bloc2StateLoading extends Bloc2State {
  const Bloc2StateLoading();
}

class Bloc2StateError extends Bloc2State {
  final PlaygroundError error;
  const Bloc2StateError(this.error);
}

// BLOC

class Bloc2 extends Bloc<Bloc2Event, Bloc2State> {
  Bloc2() : super(const Bloc2StateEmpty()) {
    // Register event handlers
  }

  final ProductRepository _productRepository = GetIt.I.get<ProductRepository>();

  // Handler for fetching products.
  // We simulate fetching more items if the user is an admin.
  // We do that by simply removing all items but one if the user is a regular
  // user. The logic here isn't important.
  void _handleFetch(FetchProducts2Event event, Emitter<Bloc2State> emit) async {
    if (state is Bloc2StateLoading) {
      return;
    }

    emit(const Bloc2StateLoading());

    (await _productRepository.fetchProduct()).fold(
      (l) => emit(Bloc2StateError(l)),
      (r) {
        // TODO: Condition.
        // Ignore this code! I'm cutting the list unless the user is an admin,
        // to simulate a different list for different users.
        if (int.parse("1") == 1) {
          emit(Bloc2StateList(r.sublist(0, 1)));
        } else {
          emit(Bloc2StateList(r));
        }
      },
    );
  }
}
