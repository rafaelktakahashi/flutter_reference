import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/life/life_bloc.dart';
import 'package:flutter_reference/view/UI/organisms/conways_game_of_life_ui.dart';

// In atomic design, I believe this would have a template, but I'm unsure if
// it's correct to have an extra layer that just passes on the bloc's properties
// to other widgets. Anyhow, reusable pages like error modals can use templates
// more easily.
class LifePage extends StatelessWidget {
  const LifePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LifeBloc, LifeState>(
      builder: (context, state) {
        final lifeBloc = context.read<LifeBloc>();
        return Scaffold(
          appBar: AppBar(title: const Text("Conway's game of life")),
          body: ConwaysGameOfLifeUI(
            board: state.board,
            toggleAutoplay: () {
              lifeBloc.add(LifeEventToggleAutostep());
            },
            step: () {
              lifeBloc.add(LifeEventStepOnce());
            },
            randomize: () {
              lifeBloc.add(LifeEventRandomize());
            },
          ),
        );
      },
    );
  }
}
