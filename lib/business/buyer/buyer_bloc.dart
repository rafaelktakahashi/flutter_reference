import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/buyer/buyer_state.dart';
import 'package:flutter_reference/data/repository/buyer_repository.dart';
import 'package:get_it/get_it.dart';

// Bloc that shows how you can implement nested requests, with a nested state.
//
// If you're looking for a simpler example of how to use a bloc, check the
// product list bloc or the product form bloc.
// If you're looking for an example of how to use a bloc from native code, check
// the counter bloc.
// If you're looking for an example of how to implement complicated business
// logic with blocs, check the life bloc.

abstract class BuyerEvent {
  const BuyerEvent();
}

/// Fetches a list of buyers, with a limited amount of information. Detailed
/// information for each buyer needs to be fetched individually.
class BuyerEventFetchList extends BuyerEvent {
  /// If [true] (which is the default), causes the buyer details that have been
  /// fetched so far to be deleted when the bloc is already in the loaded state.
  /// After deleting the details, they'll need to be fetched again.
  final bool resetDetails;

  /// If [true], this event will be ignored if the list is already loaded in
  /// the bloc. The default is [false].
  final bool skipIfAlreadyLoaded;
  // It is recommended to always include this "skipIfAlreadyLoaded" in the event
  // whenever possible. Fetch events are typically emitted when a page is loaded
  // and it's useful to be able to skip redundant requests.

  const BuyerEventFetchList({
    this.resetDetails = true,
    this.skipIfAlreadyLoaded = false,
  });
}

/// Fetches the details for a specific buyer. Only works when the buyer bloc is
/// in the loaded state, otherwise this event will have no effect.
class BuyerEventFetchDetails extends BuyerEvent {
  final String identification;

  /// If [true], this event will be ignored if the bloc already has details for
  /// this buyer. The default is [false].
  final bool skipIfAlreadyLoaded;

  const BuyerEventFetchDetails({
    required this.identification,
    this.skipIfAlreadyLoaded = false,
  });
}

// NOTE: This file has an example of nested states, with a class hierarchy for
// the list of buyers and also for each buyer's details.
//
// The subclasses are defined in a separate file. This creates a cyclical
// import. This file imports buyer_state.dart to use the subclasses that are
// written there, and buyer_state.dart imports this class to use the abstract
// BuyerState class. This is okay, because both files are part of the same
// library (this library). Cyclical imports are not a problem in Dart, as long
// as you're not creating cycles with different libraries.

/// State of the buyer bloc. When it has data, it'll have a list of buyers and
/// a map of details.
abstract class BuyerState {
  const BuyerState();
}

/// The buyer bloc.
///
/// This is an example of nested requests; after the initial request for
/// fetching the list of buyers, additional events can be emitted to fetch
/// details for individual buyers.
class BuyerBloc extends Bloc<BuyerEvent, BuyerState> {
  BuyerBloc() : super(const BuyerStateIdle()) {
    // Register event handlers.

    // Handle fetch list: This will cause a new request, except when the state
    // is already loading (that means there's already a request being made).
    // In that case, the event has no effect.
    // We also check for a flag to save the map of details, but that only has
    // effect if the list is already loaded.
    on<BuyerEventFetchList>((event, emit) async {
      // 1. If the state is loading, it means there's already a request underway
      // and we should drop this event.
      if (state is BuyerStateLoading) {
        return;
      }

      // 2. Also end if the event says so.
      if (state is BuyerStateSuccess && event.skipIfAlreadyLoaded == true) {
        return;
      }

      // 3. Emit the loading state right away, before the request.
      emit(const BuyerStateLoading());

      // 4. If the state is success and the event is telling us to keep existing
      // details, then we store that information. Use an empty map otherwise.
      // This map will only be used if the request succeeds.
      final details = _detailsToKeep(event, state);

      // 5. Make the request, then set the state.
      final result = await buyerRepository.fetchBuyers();

      result.fold(
        (l) {
          emit(BuyerStateError(error: l));
        },
        (r) {
          emit(BuyerStateSuccess(buyers: r, details: details));
        },
      );
    });

    // Handle fetch details: This will only start when the list has already been
    // fetched, and will only affect the state if the list is still there by the
    // time the details request finishes.
    on<BuyerEventFetchDetails>((event, emit) async {
      // 1. Get the event at the start in order to check if it's loaded. We put
      // it in a different variable to get type inference.
      final stateAtStart = state;
      if (stateAtStart is! BuyerStateSuccess) {
        // Ignore this event. It only works when the list is already loaded.
        return;
      }

      // 2. Also ignore the event if the bloc is already fetching details for
      // this buyer.
      if (stateAtStart.details[event.identification]
          is BuyerDetailsStateLoading) {
        // Means that this request is already loading.
        return;
      }

      // 3. And also skip if the details already exist for the specified buyer
      // and the event tells us to skip if it's already loaded.
      if (stateAtStart.details[event.identification]
              is BuyerDetailsStateSuccess &&
          event.skipIfAlreadyLoaded) {
        return;
      }

      // 4. Now we're sure that we'll make the request. Emit a loading state,
      // but only change the details state, not the whole state.
      final Map<String, BuyerDetailsState> detailsCopy =
          Map.from(stateAtStart.details);
      // (Always make new maps. Don't mutate the existing state.)

      detailsCopy[event.identification] = const BuyerDetailsStateLoading();

      emit(stateAtStart.copyWith(details: detailsCopy));

      // 5. Make the request. At the end, set the new state in the map.
      final result =
          await buyerRepository.fetchBuyerDetails(event.identification);

      final detailsStateToEmit = result.fold(
        (l) => BuyerDetailsStateError(error: l),
        (r) => BuyerDetailsStateSuccess(data: r),
      );
      // However, we only set the state if the current state still has the
      // loaded list.
      // We can't reuse the stateAtStart variable. Time has passed since the
      // request, and the state could be different now. Remember that the
      // "state" property of a bloc is a getter. It may be different each time
      // you call it (and that's also why type inference doesn't work with it).
      final stateAtEnd = state;

      if (stateAtEnd is! BuyerStateSuccess) {
        // Immediately end the function, without setting the result.
        // We don't expect this to happen normally.
        return;
      }

      // Now we need to make a new state with the new details in it.
      final Map<String, BuyerDetailsState> newDetails =
          Map.from(stateAtEnd.details);

      // This can be an error or a success. This line of code does not know.
      newDetails[event.identification] = detailsStateToEmit;

      emit(stateAtEnd.copyWith(details: newDetails));
    });
  }

  final buyerRepository = GetIt.I.get<BuyerRepository>();
} // end bloc

Map<String, BuyerDetailsState> _detailsToKeep(
    BuyerEventFetchList event, BuyerState state) {
  if (event.resetDetails == true) {
    // When resetting details, use an empty map.
    return {};
  }

  if (state is BuyerStateSuccess) {
    // If we want to keep the map, we can only do so when the state already has
    // been loaded.
    return state.details;
  } else {
    return {};
  }
}
