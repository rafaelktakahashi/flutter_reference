import 'package:flutter/widgets.dart';
import 'package:flutter_reference/domain/error/playground_navigation_error.dart';
import 'package:flutter_reference/view/pages/counter/counter.dart';
import 'package:flutter_reference/view/pages/home/home.dart';
import 'package:flutter_reference/view/pages/life/life.dart';
import 'package:flutter_reference/view/pages/product/product_details.dart';
import 'package:flutter_reference/view/pages/product/product_list.dart';
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
            return const ProductListPage();
          },
        ),
        // To go here, use "/products/1".
        GoRoute(
          path: 'products/:productId',
          builder: (BuildContext context, GoRouterState state) {
            final productId = state.params['productId'];
            if (productId == null) {
              // This one is not supposed to be possible, because only our own
              // code decides the url of pages. If we ever get this kind of
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
          path: 'life',
          builder: (BuildContext context, GoRouterState state) {
            return const LifePage();
          },
        ),
      ],
    ),
  ],
);
