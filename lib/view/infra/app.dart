import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/themes/theme_data.dart';
import 'package:flutter_reference/view/nav/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter sample architecture',
      theme: informativeTheme,
      routerConfig: router,
    );
  }
}
