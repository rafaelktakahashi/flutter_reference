import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/page_link.dart';
import 'package:flutter_reference/view/templates/scrollable_template.dart';

/// Main menu of this sample application.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return ScrollableTemplate(
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
        const PageLink(url: '/products', text: 'Simple list with form'),
        const PageLink(url: '/buyers', text: 'List with details request'),
        const PageLink(url: '/interop', text: 'Interop bloc'),
        const PageLink(url: '/life', text: "Conway's game of life"),
        const PageLink(url: '/lifecycle', text: "App Lifecycle Listener"),
        const PageLink(url: '/settings', text: 'Settings with local storage'),
        const PageLink(url: '/random', text: "Random page"),
        PageLink(
          calculateRoutes: (context) {
            // This is one method of implementing redirects.
            // This callback in our PageLink widget should return a list of urls,
            // and each of them will be called in order, one after the other
            // without delay. This is useful for pushing multiple routes at once.
            // See the redirect_pages.dart files to see why we're doing this.

            // Here you can use the context to calculate which page(s) to push.
            // I'm always pushing these two, but you can return different things
            // and that'll be calculated on the spot.
            return ['/life', '/redirect_blue'];
          },
          text: "Life with modal redirect",
        ),
        const PageLink(
          // This is another example of redirection. See the redirect_pages.dart
          // file to see why we're doing this.
          url: '/life?redirect=orange',
          text: "Life with one-time redirect",
        ),
        const PageLink(
          // This is yet another way of implementing redirects or any other kind
          // of complicated navigation. It's the most recommended way, but few
          // pages need this. See the redirect_pages.dart file to see why we're
          // doing this.
          navCase: 'lifeWithGreenPage',
          text: "Life with added route",
        ),
        const PageLink(
          url: '/map',
          text: "Map with stuff over it",
        ),
      ],
    );
  }
}
