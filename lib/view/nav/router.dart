import 'package:flutter/widgets.dart';
import 'package:flutter_reference/view/pages/counter/counter.dart';
import 'package:flutter_reference/view/pages/home/home.dart';
import 'package:flutter_reference/view/pages/life/life.dart';
import 'package:flutter_reference/view/pages/product/product_list.dart';
import 'package:go_router/go_router.dart';

/// The exact way you configure navigation isn't actually important for this
/// architecture. This is provided as an example.

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
        GoRoute(
          path: 'products',
          builder: (BuildContext context, GoRouterState state) {
            return const ProductListPage();
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
