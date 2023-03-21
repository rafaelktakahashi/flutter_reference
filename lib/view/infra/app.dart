import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/business/product/product_form_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/view/UI/themes/theme_data.dart';
import 'package:flutter_reference/view/pages/home.dart';
import 'package:get_it/get_it.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter sample architecture',
      theme: informativeTheme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CounterBloc>(
            // All interop blocs need to be singletons.
            // Other blocs can be created normally.
            create: (BuildContext context) => GetIt.I.get<CounterBloc>(),
          ),
          BlocProvider<ProductListBloc>(
            // These blocs will be created when needed.
            // If a bloc needs to exist since startup, then it
            // should be placed in GetIt.
            create: (BuildContext context) => ProductListBloc(),
          ),
          BlocProvider<ProductFormBloc>(
            create: (BuildContext context) => ProductFormBloc(),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}
