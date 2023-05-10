import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/life/life_rules.dart';
import 'package:flutter_reference/domain/entity/life.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "life_bloc.freezed.dart";

abstract class LifeEvent {}

/// Event that makes the board advance one step.
class LifeEventStepOnce extends LifeEvent {}

/// Event that starts the board's autoplay.
class LifeEventStartAutostep extends LifeEvent {}

/// Event that stops the board's autoplay.
class LifeEventStopAutostep extends LifeEvent {}

/// Event that starts the board's autoplay if it's not autoplaying, and
/// stops the board's autoplay if it's autoplaying.
class LifeEventToggleAutostep extends LifeEvent {}

/// Event that randomizes the board's cells.
class LifeEventRandomize extends LifeEvent {}

@freezed
class LifeState with _$LifeState {
  const factory LifeState({
    required LifeBoard board,

    /// When true, this means the life board is automatically advancing its state.
    required bool isAutostepping,
  }) = _LifeState;
}

const height = 24;
const width = 48;

/// This bloc is provided as a demo of business rules living in the bloc.
/// Strictly speaking, you could hardly call Conway's game of life a set of
/// "business rules", but they're here as an example of rules that are
/// relatively easy to understand but just complicated enough that putting
/// everything in the bloc itself would make it hard to read.
///
/// Some key points are:
/// - The bloc isn't just for storing the game board. It's also responsible for
/// containing the logic of how the game works.
/// - The model itself (that is, the classes for the board and the cells) are
/// not responsible for containing those rules. That would be typical for a more
/// traditional object-oriented model where the model is the logic, but here
/// all the rules live in the bloc.
/// - Rules don't need to exist in the Bloc's class necessarily, but from the
/// outside, only the bloc is exposed. You can put handlers and other methods
/// in other files, but ultimately the bloc itself is the only point of contact
/// with classes outside of the business layer.
class LifeBloc extends Bloc<LifeEvent, LifeState> {
  LifeBloc()
      : super(LifeState(
          board: randomizeBoard(width, height),
          isAutostepping: false,
        )) {
    on<LifeEventStepOnce>((event, emit) {
      // Emit a new state having applied the rules to the board once.
      emit(state.copyWith(board: stepForward(state.board)));
    });

    on<LifeEventStartAutostep>((event, emit) {
      emit(state.copyWith(isAutostepping: true));
    });

    on<LifeEventStopAutostep>((event, emit) {
      emit(state.copyWith(isAutostepping: false));
    });

    on<LifeEventToggleAutostep>((event, emit) {
      // Don't repeat logic. Emit an event here.
      // In this case, this doesn't save any code, but it avoids implementing
      // the same thing in multiple places.
      if (state.isAutostepping) {
        add(LifeEventStopAutostep());
      } else {
        add(LifeEventStartAutostep());
      }
    });

    on<LifeEventRandomize>((event, emit) {
      emit(state.copyWith(board: randomizeBoard(width, height)));
    });

    // Setup the timer to be always ticking. It'll advance the board state if
    // the corresponding flag is set.
    // This implementation is a minimal example of the game of life; you could
    // put more information in the state and control it from the widgets.
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (state.isAutostepping) {
        // Don't repeat the logic here, send an event.
        add(LifeEventStepOnce());
      }
    });
  }
}
