import 'package:flutter/material.dart';

class IconWithLabel extends StatelessWidget {
  final Icon icon;
  final String text;

  const IconWithLabel({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        Text(text),
      ],
    );
  }
}
