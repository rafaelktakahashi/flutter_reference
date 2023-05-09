import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/text_over_color.dart';
import 'package:flutter_reference/view/UI/themes/theme_data.dart';
import 'package:flutter_reference/view/templates/modal_template.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';
import 'package:go_router/go_router.dart';

// This page shows two possible types of redirection. They work in different
// ways, with their own advantages and disadvantages.
//
// In both cases, the redirect pages (the ones in this file) do not contain
// redirection logic.
//
// Option 1: Push an extra route.
// When you push a route to go to a certain page, you also push a second page
// on top of that one. Whichever widget contains the logic for pushing pages
// will also contain the logic to decide if the
// Advantages: You're able to use modals and transparent pages that show the
// original destination behind them. Going back from that page shows the
// original destination.
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
//
// In this project, we have an example using Option 1 that always shows a
// blue popup, and an example using Option 2 that only redirects to an orange
// page once. See the router and the home page for more details.

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
