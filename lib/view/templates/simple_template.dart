import 'package:flutter/material.dart';

/// Very simple page that renders with a title, a back button and a content.
/// Accepts only one widget for the content, which may be unbounded like a
/// column or a list.
///
/// Pages that don't need any special structure in particular should use this
/// simple template. Often, that's going to be useful for when a page is made up
/// of a single organism.
///
/// Templates should never connect to blocs; they provide layout only.
class SimpleTemplate extends StatelessWidget {
  final String title;
  final Widget child;

  const SimpleTemplate({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
    );
  }
}
