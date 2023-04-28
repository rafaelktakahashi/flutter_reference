import 'package:flutter/widgets.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

/// Simple template that renders multiple children, one above the other.
///
/// This widget demonstrates that one template can refer to another to avoid
/// repeated code. This one uses the SimpleTemplate, specifying a scrollview
/// as the body.
class ScrollableTemplate extends StatelessWidget {
  final String title;
  final CrossAxisAlignment? crossAxisAlignment;
  final List<Widget> children;

  const ScrollableTemplate({
    super.key,
    required this.title,
    this.crossAxisAlignment,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleTemplate(
      title: title,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
