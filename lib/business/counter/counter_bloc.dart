import 'package:flutter_reference/business/infra/interop_bloc.dart';

// A note on subclasses and Freezed union types:
//
// The data stored in a bloc is basically a state machine. This is different
// from many other frameworks, like Redux, where the type of the state is always
// the same.
// The data in a bloc is in one of multiple states, and the fields present in
// the bloc are different depending on the state. The "state" is implemented
// using subclasses.
//
// You can also implement these states using union types. In some programming
// languages, union types are available by default (especially in functional
// programming languages). Here, we can write union types using Freezed.
//
// There are some pros and cons to using Freezed's union types:
// 1 - Freezed is cool (heh), and union types have a nice syntax, but it doesn't
// offer that much extra functionality over subclasses. It also comes with the
// cost of having to know how to use the package well. It's true that Freezed
// lets you write less code; but you might find situations where you don't know
// the best implementation for something and you end up writing extra code
// anyway. Union types with other union types inside may be especially tricky
// to write and maintain.
// 2 - Freezed union types have a few drawbacks; instead of if/elses checking
// for types, you're supposed to use functional-style maps and whens. However,
// it's difficult to follow different asynchronous paths in each branch of the
// map/when. This means that it's difficult to, for example, return right away
// when the state is a specific type, and continue executing other code when
// it's a different type. You might end up writing extra code because of that.
// 3 - The InteropBloc should work just fine if you choose to use union types,
// because the message and event conversions are synchronous. However, keep in
// mind that you will lose Freezed's type safety anyway, and you'll have to
// write the conversion manually. Just like with subclasses, serialization will
// not work by default, and you have to implement the conversions the same way
// in both sides of the bridge.
// 4 - Even if you don't use Freezed union types, you can still use regular
// Freezed classes and get serialization and an implementation of copyWith().
//
// Overall, I chose to not use Freezed union types in this example project, but
// you can use them if you believe the code will be simpler that way. You should
// find no technical problems using union types with the InteropBloc or with the
// widgets.
// Avoid switching implementations (between subclasses and union types) after
// the bloc has already been written, because they're used in different ways.
//
// It's not ideal to use subclasses in some blocs and union types in other
// blocs, but that's permissible because different blocs may have different
// problems that are best solved in different ways. Blocs don't "suffer" very
// much from this kind of inconsistency because each bloc is an isolated piece
// of logic.

abstract class CounterEvent {
  const CounterEvent();
}

class CounterEventIncrement extends CounterEvent {
  final int step;

  const CounterEventIncrement.by(this.step);
}

class CounterEventMultiply extends CounterEvent {
  final int factor;

  const CounterEventMultiply.by(this.factor);
}

class CounterEventReset extends CounterEvent {}

class _CounterEventSetError extends CounterEvent {
  final String errorMessage;

  const _CounterEventSetError(this.errorMessage);
}

abstract class CounterState {
  const CounterState();
}

class CounterStateNumber extends CounterState {
  final int value;

  const CounterStateNumber(this.value);

  CounterStateNumber add(int offset) {
    return CounterStateNumber(value + offset);
  }

  CounterStateNumber multiply(int factor) {
    return CounterStateNumber(value * factor);
  }
}

class CounterStateError extends CounterState {
  final String errorMessage;

  const CounterStateError(this.errorMessage);
}

/// Our counter bloc that extends from our InteropBloc.
/// The InteropBloc provides extra functionality for automatically making this
/// bloc usable from the native side, but requires the subclass to implement
/// a few methods.
class CounterBloc extends InteropBloc<CounterEvent, CounterState> {
  CounterBloc() : super("counter", const CounterStateNumber(0)) {
    // Register event handlers.
    // These handlers handle events regardless of whether they were
    // added by Flutter components or by events coming from native
    // code.
    on<CounterEventIncrement>((event, emit) {
      var currentState = state;
      emit(currentState is CounterStateNumber
          ? currentState.add(event.step)
          : const CounterStateNumber(0));
    });
    on<CounterEventMultiply>((event, emit) {
      var currentState = state;
      emit(currentState is CounterStateNumber
          ? currentState.multiply(event.factor)
          : const CounterStateNumber(0));
    });
    on<CounterEventReset>((_, emit) => emit(const CounterStateNumber(0)));
  }

  @override
  CounterEvent messageToEvent(dynamic message) {
    // Interpret a message that came from the native bloc adapter.
    // Optionally, you can standardize this with a serializer, but be careful
    // with polymorphic events and states.
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
