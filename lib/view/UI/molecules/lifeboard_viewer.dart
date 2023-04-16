import 'package:flutter/material.dart';
import 'package:flutter_reference/domain/entity/life.dart';

/// Molecule that displays the state of a Conway's game of life board.
///
/// I'm unsure if this should be receiving an instance of [LifeBoard] directly,
/// but it seems unnecessarily restrictive to convert it to a boolean matrix
/// first. And also the cells individually didn't make sense as atoms.
///
/// This molecule doesn't provide any actions. It's a scrollable component that
/// renders the life board that is given to it.
class LifeBoardViewer extends StatelessWidget {
  final LifeBoard board;

  const LifeBoardViewer({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: board.cells.map((e) => _buildRow(e)).toList(),
        ),
      ),
    );
  }

  Widget _buildRow(List<LifeCell> row) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: row
          .map(
            (e) => Container(
              height: 15,
              width: 15,
              // Technically these cells should be atoms, but they're so
              // specific to this purpose that it doesn't seem right to make
              // them reusable.
              decoration: BoxDecoration(
                color: e.alive ? Colors.green[400] : Colors.grey[300],
                border: Border.all(color: Colors.black45),
              ),
            ),
          )
          .toList(),
    );
  }
}
