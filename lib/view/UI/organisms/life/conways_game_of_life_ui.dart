import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/life/life_bloc.dart';
import 'package:flutter_reference/view/UI/molecules/lifeboard_viewer.dart';

/// Organism that provides a visual interface for controlling the game of life.
/// Any page can display this, but it was made for the game of life page.
///
/// Organisms can connect to blocs and implement logic. This lets organisms
/// encapsulate logic conveniently, and that lets the pages focus on other
/// things. Also avoids the infamous "callback hell".
class ConwaysGameOfLifeUI extends StatelessWidget {
  const ConwaysGameOfLifeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LifeBloc, LifeState>(
      builder: (context, state) {
        final lifeBloc = context.read<LifeBloc>();

        return Column(
          children: [
            LifeBoardViewer(board: lifeBloc.state.board),
            TextButton(
              onPressed: () => lifeBloc.add(LifeEventToggleAutostep()),
              child: const Text("Start/stop autoplay"),
            ),
            TextButton(
              onPressed: () => lifeBloc.add(LifeEventStepOnce()),
              child: const Text("Step once"),
            ),
            TextButton(
              onPressed: () => lifeBloc.add(LifeEventRandomize()),
              child: const Text("Randomize"),
            ),
          ],
        );
      },
    );
  }
}
