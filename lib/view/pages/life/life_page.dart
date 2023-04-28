import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/organisms/life/conways_game_of_life_ui.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

/// This is a super simple page that doesn't have any logic in it, because
/// everything that needs to be done here is done by the organism inside the
/// page.
///
/// We're using a template that renders only one child (just about the simplest
/// possible case).
/// In a more complicated page, you can define additional components like
/// floating buttons. Here, this widgets just says that the "LifePage page is
/// just the game of life organism."
class LifePage extends StatelessWidget {
  const LifePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleTemplate(
      title: "Conway's game of life",
      child: ConwaysGameOfLifeUI(),
    );
  }
}
