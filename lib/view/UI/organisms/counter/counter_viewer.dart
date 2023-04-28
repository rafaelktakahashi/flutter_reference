import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/counter/counter_bloc.dart';

/// Renders a number from the counter bloc and many buttons under it, including
/// a button for navigating to a native page.
///
/// This component is not very realistic. It's meant as a showcase of an
/// InteropBloc. When the user navigates to the native page, they'll see the
/// same counter there, showing the same value. Changing the value in either
/// page instantly updates it in the other.
class CounterViewer extends StatelessWidget {
  // Of couse, this example is not very realistic; however, in any project,
  // I recommend using callbacks for anything that's related to navigation.
  // That's because navigation logic should be placed in the pages; putting
  // navigation logic in an organism makes it harder to reuse in other places.
  final Function onNavigateToNative;

  const CounterViewer({super.key, required this.onNavigateToNative});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, counterState) {
        // This is the text that appears in large letters showing a number.
        var counterText = counterState is CounterStateNumber
            ? counterState.value.toString()
            : counterState is CounterStateError
                ? counterState.errorMessage
                : "";
        var counterBloc = context.read<CounterBloc>();

        // In a real project, you should probably use a Container or a
        // scrollable widget; I admit that I didn't think too much about layout
        // here.
        return Column(
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
              onPressed: () => onNavigateToNative(),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text("GO TO NATIVE PAGE"),
            ),
          ],
        );
      },
    );
  }
}
