import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/organisms/counter/counter_viewer.dart';
import 'package:flutter_reference/view/nav/interop_navigator.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

/// Page that contains a counter, with buttons for controlling the number.
/// This is not meant to be "interesting" on its own; it's a showcase of the
/// counter bloc.
///
/// The user can navigate to a native page that displays the same information,
/// and changing the counter in one page instantly updates it in the other,
/// even though one page is native and the other is Flutter. This is possible
/// thanks to our InteropBloc.
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});
  @override
  Widget build(BuildContext context) {
    // We could also have a different template here that specifically
    // renders a center-aligned list of children. Anything that exists in
    // many pages can be considered as a template, and you can choose to use
    // a template for anything that will save you time.
    return SimpleTemplate(
      title: "Counter",
      child: Center(
        child: CounterViewer(
          // Keep navigation logic in the page whenever possible, not in the
          // organism. Having navigation logic inside an organism makes it
          // harder to reuse.
          onNavigateToNative: () {
            // The interop navigator is used to navigate to a native page.
            // There's another interop navigator in native code that receives
            // this call.
            InteropNavigator.instance().navigate("counter");
          },
        ),
      ),
    );
  }
}
