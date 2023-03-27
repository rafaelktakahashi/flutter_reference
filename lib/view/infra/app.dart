import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/business/product/product_form_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/view/UI/themes/theme_data.dart';
import 'package:flutter_reference/view/nav/router.dart';
import 'package:flutter_reference/view/pages/home.dart';
import 'package:get_it/get_it.dart';

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
