import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Link that opens a new Flutter page (not an http url).
///
/// The url is always opened using GoRouter's push method.
class PageLink extends StatelessWidget {
  final String url;
  final String text;
  const PageLink({
    super.key,
    required this.url,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: TextButton(
          onPressed: () {
            context.push(url);
          },
          child: Text(text),
        ),
      ),
    );
  }
}
