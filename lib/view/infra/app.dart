import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/business/product/product_form_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/view/UI/themes/theme_data.dart';
import 'package:flutter_reference/view/nav/native_navigator.dart';
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
            create: (BuildContext context) => ProductListBloc(),
          ),
          BlocProvider<ProductFormBloc>(
            create: (BuildContext context) => ProductFormBloc(),
          ),
        ],
        child: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
        builder: (context, counterState) {
      var counterText = counterState is CounterStateNumber
          ? counterState.value.toString()
          : counterState is CounterStateError
              ? counterState.errorMessage
              : "";
      var counterBloc = context.read<CounterBloc>();
      return Scaffold(
        appBar: AppBar(
          title: const Text("Counter"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Bloc state:',
              ),
              Text(
                counterText,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () => counterBloc.add(CounterEventIncrement.by(1)),
                child: const Text("Add 1"),
              ),
              TextButton(
                onPressed: () => counterBloc.add(CounterEventIncrement.by(5)),
                child: const Text("Add 5"),
              ),
              TextButton(
                onPressed: () => counterBloc.add(CounterEventMultiply.by(2)),
                child: const Text("Double"),
              ),
              TextButton(
                onPressed: () => counterBloc.add(CounterEventMultiply.by(3)),
                child: const Text("Triple"),
              ),
              TextButton(
                onPressed: () => counterBloc.add(CounterEventReset()),
                child: const Text("Reset"),
              ),
              TextButton(
                onPressed: () => NativeNavigator.instance()
                    .navigate("[parameters not implemented]"),
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text("GO TO NATIVE PAGE"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
