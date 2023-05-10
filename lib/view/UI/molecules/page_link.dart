import 'package:flutter/material.dart';
import 'package:flutter_reference/view/nav/nav_case_extension.dart';
import 'package:go_router/go_router.dart';

/// Link that opens a new Flutter page (not an http url).
///
/// You can specify the link in one of three ways:
/// 1. Specify a string [url]. The [url] specified this way will always be
/// opened using push().
/// 2. Specify the name of a [navCase]. The [navCase] specified this way must
/// have been registered with the navigation case provider (in the same place
/// as we register blocs).
/// 3. Specify a function named [calculateRoutes] that will return a list of
/// urls. All the urls will be opened using push(), one after the other without
/// delay.
///
/// If more than one of these is specified at the same time, [url] will take
/// precedence over [navCase] and [navCase] will take precedence over
/// [calculateRoutes]. If none of the three is specified, this will throw an
/// assertion error.
class PageLink extends StatelessWidget {
  final String? url;
  final String? navCase;
  final List<String> Function(BuildContext)? calculateRoutes;
  final String text;
  const PageLink({
    super.key,
    this.url,
    this.navCase,
    this.calculateRoutes,
    required this.text,
  }) : assert(url != null || navCase != null || calculateRoutes != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: TextButton(
          onPressed: () {
            if (url != null) {
              context.push(url!);
            } else if (navCase != null) {
              context.runNavigationCase(navCase!);
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
