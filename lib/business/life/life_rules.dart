import 'dart:math';

import 'package:flutter_reference/domain/entity/life.dart';

/// Generates a new board where each cell has a 50% chance of being alive.
///
/// In traditional object-oriented programming, this would definitely be a
/// method in a class representing the board. However, here we're working with
/// blocs and a more FP-based approach where the main logic lives in functions
/// without side-effects. When writing tests, you test the function themselves.
LifeBoard randomizeBoard(int width, int height) {
  makeRandomCell(_) => LifeCell(alive: Random().nextBool());

  makeRandomRow(_) => List.generate(width, makeRandomCell);

  final randomMatrix = List.generate(height, makeRandomRow);

  return LifeBoard(cells: randomMatrix, height: height, width: width);
}

/// Gets the set of neighbors of a certain cell in the board. This is expected
/// to contain at last 3 elements (for the neighbors of a cell in the corner
/// of the board) and at most 8 elements (for the neighbors of a cell that's
/// neither in the corner nor at the edge of the board).
///
/// The current implementation does not consider a board that wraps around.
int countNeighbors(
    {required LifeBoard board,
    required int rowIndex,
    required int columnIndex}) {
  // In Conway's game of life, a cell has at most eight neighbors.

  int count = 0;
  // This loops through the eight spaces around the cell, skipping the cell
  // itself.
  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      if (i == 0 && j == 0) {
        continue; // skip the cell itself
      }
      final cell =
          board.cellAt(columnIndex: columnIndex + i, rowIndex: rowIndex + j);
      if (cell != null && cell.alive) {
        count++;
      }
    }
  }
  return count;
}

/// Apply the rules of Conway's game of life to obtain a new board.
LifeBoard stepForward(LifeBoard currentBoard) {
  // Function that applies the rule to a single cell to obtain the cell at the
  // same location but at the next step of the game.
  makeCellOfRow(int rowIndex, int columnIndex) {
    final currentCell =
        currentBoard.cellAt(columnIndex: columnIndex, rowIndex: rowIndex)!;
    final int numberOfLiveNeighbors = countNeighbors(
      board: currentBoard,
      rowIndex: rowIndex,
      columnIndex: columnIndex,
    );
    // When a cell is alive, it only survives on to the next step of the game if
    // it has two or three alive neighbors. Living cells with fewer than two
    // neighbors die of loneliness, and living cells with four neighbors die
    // of overpopulation.
    if (currentCell.alive) {
      return LifeCell(
          alive: numberOfLiveNeighbors == 2 || numberOfLiveNeighbors == 3);
    } else {
      // When a cell is dead, it becomes alive when there are exactly three
      // living neighbors in the current step.
      return LifeCell(alive: numberOfLiveNeighbors == 3);
    }
  }

  // Function that generates one horizontal row of the new board.
  makeRowOfMatrix(int rowIndex) =>
      List.generate(currentBoard.width, (i) => makeCellOfRow(rowIndex, i));

  // List of rows, in other words the whole matrix of cells.
  final listOfRows =
      List.generate(currentBoard.height, (i) => makeRowOfMatrix(i));

  return currentBoard.copyWith(cells: listOfRows);
}
