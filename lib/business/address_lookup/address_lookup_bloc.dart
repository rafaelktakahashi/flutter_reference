import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/repository/address_repository.dart';
import 'package:flutter_reference/domain/entity/address.dart';
import 'package:flutter_reference/domain/error/playground_business_error.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';
import 'package:get_it/get_it.dart';

abstract class AddressLookupEvent {
  const AddressLookupEvent();
}

class AddressLookupEventCep extends AddressLookupEvent {
  final String cep;

  const AddressLookupEventCep(this.cep);
}

abstract class AddressLookupState {
  const AddressLookupState();
}

class AddressLookupStateEmpty extends AddressLookupState {
  const AddressLookupStateEmpty();
}

class AddressLookupStateLoading extends AddressLookupState {
  final Address? previousResult;
  const AddressLookupStateLoading([this.previousResult]);
}

class AddressLookupStateError extends AddressLookupState {
  final PlaygroundError error;
  const AddressLookupStateError(this.error);
}

class AddressLookupStateSuccess extends AddressLookupState {
  final Address result;
  const AddressLookupStateSuccess(this.result);
}

class AddressLookupBloc extends Bloc<AddressLookupEvent, AddressLookupState> {
  final AddressRepository addressRepository = GetIt.I.get<AddressRepository>();

  AddressLookupBloc() : super(const AddressLookupStateEmpty()) {
    // Event handlers:
    on<AddressLookupEventCep>((event, emit) async {
      final s = state;
      // If there was already a result loaded, keep it in the state as it loads.
      if (s is AddressLookupStateSuccess) {
        emit(AddressLookupStateLoading(s.result));
      } else {
        emit(const AddressLookupStateLoading());
      }

      // Make the request with the repository, then emit.
      final result = await addressRepository.lookupCep(event.cep);
      emit(
        result.fold(
          (l) => AddressLookupStateError(_handleRepositoryError(l)),
          (r) => AddressLookupStateSuccess(r),
        ),
      );
    });
  }
}

// Handle the error codes that need a special error message.
// When a client error is displayed to the end user, it shows a generic message.
// Here we can identify specific errors by code to wrap them and choose more
// helpful messages.
PlaygroundError _handleRepositoryError(PlaygroundError clientError) {
  switch (clientError.errorCode()) {
    case "viacep-002":
      return PlaygroundBusinessError(
        "address-lookup-server-down",
        "The lookup server is down. Please, try again later.",
        blocName: "address_lookup_bloc",
        nestedException: clientError.cause(),
      );
    case "viacep-003":
      return PlaygroundBusinessError(
        "address-lookup-postal-code-not-found",
        "The requested postal code was not found in the server.",
        blocName: "address_lookup_bloc",
        nestedException: clientError.cause(),
      );
    default:
      // Don't handle other errors (like viacep-004 parse error) because the
      // user can't do anything about it anyway. Doing this makes the client
      // error appear in the bloc state, and the client error always returns
      // a generic error message.
      return clientError;
  }
}
