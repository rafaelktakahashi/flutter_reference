import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/repository/address_repository.dart';
import 'package:flutter_reference/domain/entity/address.dart';
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
          (l) => AddressLookupStateError(l),
          (r) => AddressLookupStateSuccess(r),
        ),
      );
    });
  }
}
