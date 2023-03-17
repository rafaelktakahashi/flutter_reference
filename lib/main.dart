import 'package:flutter_reference/business/counter/counter_bloc.dart';
import 'package:flutter_reference/business/infra/injector.dart';
import 'package:flutter_reference/view/nav/native_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var counterBloc = Injector.instance().counterBloc;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider.value(value: counterBloc, child: const CounterPage()),
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
