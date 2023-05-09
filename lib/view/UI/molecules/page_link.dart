import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Link that opens a new Flutter page (not an http url).
///
/// The url is always opened using GoRouter's push method. Either a [url] or
/// a [calculateRoutes] callback must be specified. If both are specified, the
/// [url] has priority and the callback will not be invoked.
///
/// Using the [calculateRoutes] callback allows for specifying a list of routes,
/// and each route will be called with push(), one after the other, without
/// delay. You can use this to push multiple routes at once.
class PageLink extends StatelessWidget {
  final String? url;
  final List<String> Function(BuildContext)? calculateRoutes;
  final String text;
  const PageLink({
    super.key,
    this.url,
    this.calculateRoutes,
    required this.text,
  }) : assert(url != null || calculateRoutes != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: TextButton(
          onPressed: () {
            if (url != null) {
              context.push(url!);
            } else if (calculateRoutes != null) {
              // The callback returns a list of routes to follow. Then we push
              // them one by one, without delay.
              final routes = calculateRoutes!.call(context);
              for (String route in routes) {
                context.push(route);
              }
            }
          },
          child: Text(text),
        ),
      ),
    );
  }
}
