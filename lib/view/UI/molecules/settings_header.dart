import 'package:flutter/material.dart';

/// Header of a section in a list of settings.
class SettingsHeader extends StatelessWidget {
  final String text;
  const SettingsHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Container(height: 5, color: Theme.of(context).colorScheme.primary),
      ],
    );
  }
}
