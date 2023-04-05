import 'package:flutter_reference/domain/entity/playground_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "life.freezed.dart";
part 'life.g.dart';

/// Entities for the life page, that implements
/// Conway's game of life.

@freezed
class LifeBoard with _$LifeBoard implements PlaygroundEntity {
  const factory LifeBoard({
    /// Two-dimensional array of cells in the board.
    ///
    /// The matrix is first indexed by row (zero-indexed vertical coordinate)
    /// and secondly indexed by column (zero-indexed horizontal coordinate).
    required List<List<LifeCell>> cells,
    required int height,
    required int width,
  }) = _LifeBoard;

  const LifeBoard._();

  factory LifeBoard.fromJson(Map<String, Object?> json) =>
      _$LifeBoardFromJson(json);

  /// Gets a cell at a specific location, or null if the coordinates point
  /// outside the board.
  ///
  /// Both [columnIndex] and [rowIndex] are 0-indexed.
  LifeCell? cellAt({required int columnIndex, required int rowIndex}) {
    if (columnIndex < 0 ||
        columnIndex >= width ||
        rowIndex < 0 ||
        rowIndex >= height) {
      // Cell outside of the board.
      return null;
    } else {
      return cells[rowIndex][columnIndex];
    }
  }

  // Normally you could place all logic of Conway's game in the classes of this
  // file, for example to copy this board with the rules applied once.
  // However, in this project the implementation of Conway's game of life
  // focuses on showcasing the implementation of rules in the bloc.
}

@freezed
class LifeCell with _$LifeCell implements PlaygroundEntity {
  const factory LifeCell({
    /// Whether or not this cell is alive.
    required bool alive,
  }) = _LifeCell;

  factory LifeCell.fromJson(Map<String, Object?> json) =>
      _$LifeCellFromJson(json);
}
