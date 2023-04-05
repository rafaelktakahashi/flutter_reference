import 'package:flutter/material.dart';
import 'package:flutter_reference/domain/entity/life.dart';
import 'package:flutter_reference/view/UI/molecules/lifeboard_viewer.dart';

/// Organism that provides a visual interface for controlling the game of life.
/// Any page can display this, but it was made for the game of life page.
/// Organisms shouldn't know anything about blocs; they should be reusable
/// and independent of their context.
class ConwaysGameOfLifeUI extends StatelessWidget {
  final LifeBoard board;
  final void Function() toggleAutoplay;
  final void Function() randomize;
  final void Function() step;

  const ConwaysGameOfLifeUI({
    super.key,
    required this.board,
    required this.toggleAutoplay,
    required this.randomize,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LifeBoardViewer(board: board),
        TextButton(
          onPressed: () => toggleAutoplay(),
          child: const Text("Start/stop autoplay"),
        ),
        TextButton(
          onPressed: () => step(),
          child: const Text("Step once"),
        ),
        TextButton(
          onPressed: () => randomize(),
          child: const Text("Randomize"),
        ),
      ],
    );
  }
}
