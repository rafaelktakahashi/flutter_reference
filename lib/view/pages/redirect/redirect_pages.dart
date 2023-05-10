import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/text_over_color.dart';
import 'package:flutter_reference/view/UI/themes/theme_data.dart';
import 'package:flutter_reference/view/templates/modal_template.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';
import 'package:go_router/go_router.dart';

// This page shows three possible types of redirection. They work in different
// ways, with their own advantages and disadvantages.
//
// In all cases, the redirect pages (the ones in this file) do not contain
// redirection logic. You can choose the option you prefer and that best aligns
// with the needs of your project.
//
// Option 1: Push an extra route.
// When you push a route to go to a certain page, you also push a second page
// on top of that one. Whichever widget contains the logic for pushing pages
// will also contain the logic to decide the routes.
// Advantages: You're able to use modals and transparent pages that show the
// original destination behind them. Going back from that page shows the
// original destination. This is similar to Option 3 but much easier to
// implement because you don't need any extra code.
// Disadvantages: Normally it's more recommended to put all routing logic in the
// router, but go_router does not support more than open page using one route.
// This means that the logic needs to be somewhere else:
// - If you place the redirection logic in the page that does the pushes, you'll
// have to replicate that logic in every page that needs the redirect. This adds
// complications if you need to reach the destination page from a native page.
// - If you place the redirection logic in a separate class (e.g. in a dedicated
// navigator), you will need additional code in a separate class, which hurts
// maintainability.
//
// Option 2: Use a router redirect.
// Add redirection logic in the router to replace the destination route with a
// different one based on certain conditions. If you don't need to push multiple
// routes at once, this is the recommended approach.
// Advantages: Pages only need to push the destination url, without worrying
// about redirection logic. Even native pages can reach the destination page
// and use the redirection logic.
// Disadvantages: You're not able to push multiple pages at once. Typically this
// limitation is not a problem, but it means you can't push a transparent route
// above the destination page.
//
// Option 3: Use navigation cases.
// Navigation cases are our own solution for navigating to one or more pages in
// a way that can be affected by bloc logic. Check the nav_case_extension.dart
// file for more details. Overall this is the most recommended way, because it
// allows for a lot of flexibility and keeps compatibility with native code, but
// requires additional code in order to work.
// Advantages: A navigation case is a function that can call push, pop, reset
// and any combination of navigation methods any number of times, and can also
// access bloc states to determine what routes to use. It's also not restricted
// to working with a specific framework (we use go_router, but navigation cases
// work in the same way with any other framework). Additionally, this works with
// the interop navigator, and native pages only need to specify the name of a
// navigation case.
// Disadvantages: Relatively complicated to implement. However, note that once
// the structural code has been written, it's not very complicated to write and
// call navigation cases. Usually, simple logic can be implemented in one of the
// other options instead, and that's typically easier. This option also requires
// you to handle parameters manually. In most cases, it's easier to use one of
// the two other options.
//
//
// In this project, we have an example of each option:
// The blue page is a modal that renders over the destination page. However, the
// home page itself needs to contain that logic.
// The orange page uses logic in the router to redirect the user once. This kind
// of redirection is not capable of using multiple pushes at once.
// The green page uses a navigation case to push an additional page when the
// life simulation is not running.
//
// Note that these are examples; it's possible to do a lot more with any of
// these methods, but each has their own limitations. You can (and should) use
// different options for different pages, because different redirects have
// their own requirements. As always, comment carefully what you're doing,
// because anything more complicated than a simple push() is not obvious for
// future developers reading the code.

/// Simple page with text that appears over another page.
///
/// This page gets pushed above the destination, so the user can go back to
/// where they intended to go initially.
class BluePage extends StatelessWidget {
  const BluePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: extraBrightTheme,
      child: ModalTemplate(
        title: "Redirection",
        child: TextOverColor(
          largeText: "Modal redirection",
          smallText: "You were redirected here."
              "\n"
              "This page exists above the route you intended to reach."
              " "
              "Just press back and you'll land there.",
          backgroundColor: Colors.blue[300],
        ),
      ),
    );
  }
}

/// Simple page with text where the user gets redirected only once per
/// execution.
/// The only-once logic is implemented in the router by using a flag.
///
/// This page does not contain the redirection logic. See the router.
/// It's worth noting that our redirection logic is very simple (it uses a
/// local variable), but in all likelihood you'll want to run some more
/// complicated business logic to decide whether to do the redirect or not.
/// In that case, you should put that information in a bloc.
class OrangePage extends StatelessWidget {
  const OrangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTemplate(
      title: "Redirection",
      hideBackButton: true,
      child: TextOverColor(
        largeText: "Replaced redirection",
        smallText: "You were redirected here."
            "\n"
            "This route has replaced your destination."
            " "
            "You may proceed to your destination using the button below,"
            " "
            "which will also replace this screen."
            " "
            "Then, you can go back directly to the home page."
            "\n"
            "\n"
            "This redirection only occurs once."
            " "
            "It will reset if you close the app and open it again.",
        extra: ElevatedButton.icon(
          onPressed: () {
            // Replace the current page.
            // Without the redirect, the user would've arrived in
            // the destination page directly. With the redirect, they
            // arrived here instead, so the destination does not exist under
            // this page.
            context.pushReplacement('/life');
          },
          icon: const Icon(Icons.arrow_circle_right),
          label: const Text("Continue"),
        ),
        backgroundColor: Colors.orange[300],
      ),
    );
  }
}

/// Simple page with text that appears over the destination page, and only when
/// the life page is not yet running (this is arbitrary and is merely an example
/// of how bloc logic can affect navigation).
///
/// This redirection happens with a navigation case. Navigation cases are our
/// own custom way of implementing complicated navigation logic. Not every page
/// needs a navigation case (most do not need them). This is only appropriate
/// for when you need to run code in order to decide where to send the user, and
/// also when you need to push multiple routes (pushing multiple routes is not
/// possible with go_router).
class GreenPage extends StatelessWidget {
  const GreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTemplate(
      title: "Redirection",
      hideBackButton: true,
      child: TextOverColor(
        largeText: "Added redirection",
        smallText: "You were redirected here."
            "\n"
            "This route has appeared on top of your destination."
            " "
            "This page appears when the life simulation is not running."
            " "
            "Try leaving the life simulation running, then using the link again."
            "\n"
            "\n"
            "This shows that a navigation case can use a bloc's state to determine redirection logic."
            " "
            "The navigation case has pushed multiple routes at once.",
        extra: ElevatedButton.icon(
          onPressed: () {
            // Remove this page, because the destination page already exists
            // under this. That's because the navigation case has pushed the
            // destination page, and then added this page on top.
            //
            // If you're using one-time flags to show a redirection page once,
            // you can set the flag here. In that case, you'd use a bloc event.
            context.pop();
          },
          icon: const Icon(Icons.arrow_circle_right),
          label: const Text("Dismiss"),
        ),
        backgroundColor: Colors.green[300],
      ),
    );
  }
}
