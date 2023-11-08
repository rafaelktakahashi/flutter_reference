import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/login_demo/bloc1.dart';
import 'package:flutter_reference/business/login_demo/bloc2.dart';

/// Card that allows interaction with Bloc1, which is a simplified copy of
/// the product bloc. Bloc1 knows about the user through the AppDataService
/// and also gets notified of logouts by the global event stream.
class Bloc1DemoCard extends StatelessWidget {
  const Bloc1DemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc1, Bloc1State>(builder: (context, state) {
      return Card(
        color: Colors.blue[200],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  "Bloc1",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Text(
                _extractStateContent(state),
                textAlign: TextAlign.center,
              ),
            ),
            FilledButton(
              onPressed: () {
                BlocProvider.of<Bloc1>(context).add(
                  const FetchProducts1Event(),
                );
              },
              child: const Text("Load items"),
            ),
          ],
        ),
      );
    });
  }

  String _extractStateContent(Bloc1State state) {
    if (state is Bloc1StateEmpty) {
      return "(no items)";
    }
    if (state is Bloc1StateError) {
      return "Error: ${state.error.errorMessage()}";
    }
    if (state is Bloc1StateLoading) {
      return "Loading...";
    }
    if (state is Bloc1StateList) {
      return state.products.map((p) => p.toString()).join("\n\n");
    }

    return "Unexpected state.";
  }
}

/// Identical copy of the Bloc1 card.
class Bloc2DemoCard extends StatelessWidget {
  const Bloc2DemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc2, Bloc2State>(builder: (context, state) {
      return Card(
        color: Colors.blue[200],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  "Bloc2",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Text(
                _extractStateContent(state),
                textAlign: TextAlign.center,
              ),
            ),
            FilledButton(
              onPressed: () {
                BlocProvider.of<Bloc2>(context).add(
                  const FetchProducts2Event(),
                );
              },
              child: const Text("Load items"),
            ),
          ],
        ),
      );
    });
  }

  String _extractStateContent(Bloc2State state) {
    if (state is Bloc2StateEmpty) {
      return "(no items)";
    }
    if (state is Bloc2StateError) {
      return "Error: ${state.error.errorMessage()}";
    }
    if (state is Bloc2StateLoading) {
      return "Loading...";
    }
    if (state is Bloc2StateList) {
      return state.products.map((p) => p.toString()).join("\n\n");
    }

    return "Unexpected state.";
  }
}
