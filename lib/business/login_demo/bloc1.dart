import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/infra/global_event.dart';
import 'package:flutter_reference/data/repository/product_repository.dart';
import 'package:flutter_reference/data/service/app_data_service.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/domain/entity/user.dart';
import 'package:flutter_reference/domain/error/playground_business_error.dart';
import 'package:get_it/get_it.dart';
import '../../domain/error/playground_error.dart';

// This bloc is only used in the inter-bloc communications demo.
// The logic here is a simplified version of the product list bloc.
// This bloc produces a different list depending on whether the user is an
// admin or a regular user, and also automatically clears its contents when the
// user logs out.

// EVENTS
abstract class Bloc1Event {
  const Bloc1Event();
}

class FetchProducts1Event extends Bloc1Event {
  const FetchProducts1Event();
}

class Clear1Event extends Bloc1Event {
  const Clear1Event();
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

class Bloc1 extends Bloc<Bloc1Event, Bloc1State> with GlobalEventAware {
  Bloc1() : super(const Bloc1StateEmpty()) {
    // Register event handlers
    on<FetchProducts1Event>(_handleFetch);
    on<Clear1Event>(_handleClear);
    // Register global event handlers
    onGlobal<GlobalEventLogout>((_) => add(const Clear1Event()));
  }

  final AppDataService _appDataService = GetIt.I.get<AppDataService>();
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
        // Simulated code! I'm cutting the list unless the user is an admin,
        // to simulate a different list for different users.
        final user = _appDataService.readCurrentUser();
        if (user != null && user.userRole != UserRole.admin) {
          emit(Bloc1StateList(r.sublist(0, 1)));
        } else if (user != null) {
          emit(Bloc1StateList(r));
        } else {
          emit(
            const Bloc1StateError(
              PlaygroundBusinessError(
                "Bloc1-001",
                "Request failed: unauthenticated",
                blocName: "Bloc1",
              ),
            ),
          );
        }
      },
    );
  }

  // Clear the list in this bloc.
  void _handleClear(Clear1Event event, Emitter<Bloc1State> emit) async {
    // Your "clear" logic may be different depending on what your bloc does,
    // but here we simply reset the bloc's state.
    emit(const Bloc1StateEmpty());
  }
}
