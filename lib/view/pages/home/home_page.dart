import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/page_link.dart';
import 'package:flutter_reference/view/templates/scrollable_template.dart';

/// Main menu of this sample application.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const ScrollableTemplate(
      title: "Flutter reference architecture",
      children: [
        // You could theoretically fetch data when navigating to a page, but
        // in our case we do that in the router's builder.
        //
        // Loading data in the bloc _before_ navigation is a common
        // practice, but putting it in the router's builder ensures that
        // you won't forget to load data, no matter where the page is
        // being called from.
        // In any case, these options are better than loading data in
        // the page itself. It simplifies initialization logic and lets
        // the pages be stateless widgets that don't do anything special
        // the first time they appear.
        PageLink(url: '/products', text: 'Simple list'),
        PageLink(url: '/interop', text: 'Interop bloc'),
        PageLink(url: '/life', text: "Conway's game of life"),
        PageLink(url: '/settings', text: 'Settings'),
        PageLink(url: '/random', text: "Random page"),
      ],
    );
  }
}
