import 'package:flutter_reference/business/infra/interop_bloc.dart';

abstract class CounterEvent {}

class CounterEventIncrement extends CounterEvent {
  int step;

  CounterEventIncrement.by(this.step);
}

class CounterEventMultiply extends CounterEvent {
  int factor;

  CounterEventMultiply.by(this.factor);
}

class CounterEventReset extends CounterEvent {}

class _CounterEventSetError extends CounterEvent {
  String errorMessage;

  _CounterEventSetError(this.errorMessage);
}

abstract class CounterState {}

class CounterStateNumber extends CounterState {
  int value;

  CounterStateNumber(this.value);

  CounterStateNumber add(int offset) {
    return CounterStateNumber(value + offset);
  }

  CounterStateNumber multiply(int factor) {
    return CounterStateNumber(value * factor);
  }
}

class CounterStateError extends CounterState {
  String errorMessage;

  CounterStateError(this.errorMessage);
}

/// Our counter bloc that extends from our InteropBloc.
/// The InteropBloc provides extra functionality for automatically making this
/// bloc usable from the native side, but requires the subclass to implement
/// a few methods.
class CounterBloc extends InteropBloc<CounterEvent, CounterState> {
  CounterBloc() : super("counter", CounterStateNumber(0)) {
    // Register event handlers.
    // These handlers handle events regardless of whether they were
    // added by Flutter components or by events coming from native
    // code.
    on<CounterEventIncrement>((event, emit) {
      var currentState = state;
      emit(currentState is CounterStateNumber
          ? currentState.add(event.step)
          : CounterStateNumber(0));
    });
    on<CounterEventMultiply>((event, emit) {
      var currentState = state;
      emit(currentState is CounterStateNumber
          ? currentState.multiply(event.factor)
          : CounterStateNumber(0));
    });
    on<CounterEventReset>((_, emit) => emit(CounterStateNumber(0)));
  }

  @override
  CounterEvent messageToEvent(dynamic message) {
    // Interpret a message that came from the native bloc adapter.
    switch (message["type"]) {
      case "INCREMENT":
        return CounterEventIncrement.by(message["step"]);
      case "MULTIPLY":
        return CounterEventMultiply.by(message["factor"]);
      case "RESET":
        return CounterEventReset();
      default:
        return _CounterEventSetError(
            "UNRECOGNIZED MESSAGE: ${message.toString()}");
    }
  }

  @override
  stateToMessage(CounterState state) {
    // Make a message for the native side, containing this bloc's
    // current state.
    if (state is CounterStateNumber) {
      return <String, dynamic>{
        "type": "NUMBER",
        "value": state.value,
      };
    } else if (state is CounterStateError) {
      return <String, dynamic>{
        "type": "ERROR",
        "errorMessage": state.errorMessage,
      };
    } else {
      return <String, dynamic>{
        "type": "ERROR",
        "errorMessage": "COULD NOT CREATE MESSAGE FROM STATE: $state",
      };
    }
  }
}
