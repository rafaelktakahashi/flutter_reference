import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/settings_header.dart';
import 'package:flutter_reference/view/UI/molecules/settings_item.dart';

/// Settings for the app.
///
/// This is a fixed list of settings.
class SettingsControls extends StatelessWidget {
  const SettingsControls({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Use scroll physics to explicitly specify how scrolling "feels".
      // By default, iOS uses bouncing physics, which allows the user to scroll
      // past the content, even when the content is smaller than the screen.
      // In Android, clamping physics is used by default.
      // The default iOS physics may be counterintuitive when you expect the
      // list to be relatively small.
      physics: const ClampingScrollPhysics(),
      children: [
        const SettingsHeader(text: "First Section"),
        SettingsItem(
          mainLabel: "Setting One",
          control: Switch(value: true, onChanged: (a) {}),
        ),
        SettingsItem(
          mainLabel: "Setting Two",
          subLabel: "Explanation of setting two",
          control: Switch(value: true, onChanged: (a) {}),
        ),
        SettingsItem(
          mainLabel: "Setting Three",
          control: Switch(value: true, onChanged: (a) {}),
        ),
        const SettingsHeader(text: "Second Section"),
        SettingsItem(
          mainLabel: "What do you prefer",
          control: ToggleButtons(
            isSelected: [true, false, false],
            children: [
              Text("A"),
              Text("B"),
              Text("C"),
            ],
            onPressed: (a) {},
          ),
        ),
      ],
    );
  }
}
