import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/buyer/buyer_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/domain/error/playground_navigation_error.dart';
import 'package:flutter_reference/view/pages/buyer/buyer_details_page.dart';
import 'package:flutter_reference/view/pages/buyer/buyer_list_page.dart';
import 'package:flutter_reference/view/pages/counter/counter_page.dart';
import 'package:flutter_reference/view/pages/home/home_page.dart';
import 'package:flutter_reference/view/pages/life/life_page.dart';
import 'package:flutter_reference/view/pages/product/product_details_page.dart';
import 'package:flutter_reference/view/pages/product/product_form_page.dart';
import 'package:flutter_reference/view/pages/product/product_list_page.dart';
import 'package:flutter_reference/view/pages/product/product_result_page.dart';
import 'package:flutter_reference/view/pages/redirect/redirect_pages.dart';
import 'package:flutter_reference/view/pages/settings/settings_page.dart';
import 'package:go_router/go_router.dart';

/// Router configuration that is provided as an example. You may choose to use
/// a different router library, or something else entirely.
///
/// Here, we're using GoRouter because that lets us refer to pages using urls,
/// and that's very useful for deep linking. It also lets native pages send
/// navigation calls to our InteropNavigator using urls.

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: [
        GoRoute(
          path: 'interop',
          builder: (BuildContext context, GoRouterState state) {
            return const CounterPage();
          },
        ),
        // To go here, use "/products".
        GoRoute(
          path: 'products',
          builder: (BuildContext context, GoRouterState state) {
            // You can run initialization logic in the pages before navigation
            // before calling push() or go()), or here. Doing it here ensures
            // you won't forget the call, no matter where the page is being
            // called from.
            // Both cases are better than leaving initialization logic in the
            // destination page. It lets the pages be stateless widgets that
            // don't do anything special on the first render.
            // Note that all the complicated logic should be in the blocs, so
            // this initialization logic is no more than emitting an event.
            context
                .read<ProductListBloc>()
                .add(const FetchProductsEvent(skipIfAlreadyLoaded: true));
            return const ProductListPage();
          },
        ),
        GoRoute(
          path: 'products/new',
          builder: (BuildContext context, GoRouterState state) {
            return const ProductFormPage();
          },
        ),
        GoRoute(
          path: 'products/new/result',
          builder: (BuildContext context, GoRouterState state) {
            return const ProductResultPage();
          },
        ),
        // To go here, use "/products/details/1".
        GoRoute(
          path: 'products/details/:productId',
          builder: (BuildContext context, GoRouterState state) {
            final productId = state.params['productId'];
            if (productId == null) {
              // This condition is not supposed to be possible, because only our
              // own code decides the url of pages. If we ever get this kind of
              // exception, that means that there's a bug that should be solved
              // in code.
              throw const PlaygroundNavigationError(
                "NAV-0110",
                readableErrorMessage:
                    "Navigating to the product details page without specifying an id.",
              );
            } else {
              return ProductDetailsPage(
                productId: productId,
              );
            }
          },
        ),
        GoRoute(
          path: "buyers",
          builder: (BuildContext context, GoRouterState state) {
            context.read<BuyerBloc>().add(
                  const BuyerEventFetchList(
                    resetDetails: false,
                    skipIfAlreadyLoaded: true, // avoid redundant requests
                  ),
                );
            return const BuyerListPage();
          },
        ),
        GoRoute(
          path: "buyers/details/:buyerId",
          builder: (BuildContext context, GoRouterState state) {
            final buyerId = state.params['buyerId'];
            if (buyerId == null) {
              throw const PlaygroundNavigationError(
                "NAV-0110",
                readableErrorMessage:
                    "Navigating to the buyer details page without specifying an id",
              );
            } else {
              // This details page uses a second request to fetch details. Thus,
              // we need to emit the event here too.
              context.read<BuyerBloc>().add(
                    BuyerEventFetchDetails(
                      identification: buyerId,
                      skipIfAlreadyLoaded: true,
                    ),
                  );
              return BuyerDetailsPage(buyerId: buyerId);
            }
          },
        ),
        GoRoute(
          path: 'life',
          builder: (BuildContext context, GoRouterState state) {
            return const LifePage();
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsPage();
          },
        ),
        GoRoute(
          path: 'random',
          builder: (BuildContext context, GoRouterState state) {
            // This random route demonstrates that a route doesn't have to
            // correspond to exactly one page. You can use redirects, or add
            // logic to a builder.
            //
            // This means you can add logic to decide where a page should go.
            // However, if you need more complicated logic, it's recommended to
            // put it in the page itself.
            switch (Random().nextInt(4)) {
              case 0:
                return const ProductListPage();
              case 1:
                return const LifePage();
              case 2:
                return const SettingsPage();
              case 3:
              default:
                return const CounterPage();
            }
          },
        ),
        GoRoute(
          path: 'redirect_orange',
          builder: (BuildContext context, GoRouterState state) =>
              const OrangePage(),
        ),
        GoRoute(
          path: 'redirect_blue',
          // Do this if you want a transparent route.
          // Transparent routes are useful for making modals.
          // The modal itself is a different page with its own route, but
          // the user can see the previous page behind it because the route
          // is transparent.
          pageBuilder: (BuildContext context, GoRouterState state) =>
              CustomTransitionPage(
            fullscreenDialog: true,
            opaque: false,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: BluePage(),
            ),
          ),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        // For demonstration purposes, any page can send the 'redirect' query
        // parameter.
        // For example, the url '/life?redirect=orange' will trigger this code.
        // Of course, that's not very realistic; it's an example of how you can
        // handle redirection. In a real app, you'd probably check for the rest
        // of the url too.
        // Example: You can check if a certain url is being accessed for the
        // first time (while a certain flag has not been set yet), and if so,
        // replace the route with a different one.
        //
        // Also see the redirect_pages.dart file for more details.

        if (state.queryParams["redirect"] == "orange") {
          // In this case, we want to go to a different page instead of the
          // original destination. Simply return its url.
          if (!_hasRedirectedToOrange) {
            _hasRedirectedToOrange = true;
            return "/redirect_orange";
          }
        }

        // Return null to not use redirects.
        return null;
      },
    ),
  ],
);

// Normally, you should store this variable in a bloc, and have the bloc
// store the variable in local storage.
// Check the settings bloc for an example of writing to local storage.
// This variable won't make sense without context. Check the redirect_pages.dart
// for details.
var _hasRedirectedToOrange = false;
