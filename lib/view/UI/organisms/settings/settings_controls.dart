import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/settings/settings_bloc.dart';
import 'package:flutter_reference/view/UI/molecules/settings_header.dart';
import 'package:flutter_reference/view/UI/molecules/settings_item.dart';

/// Settings for the app.
///
/// This is a fixed list of settings.
class SettingsControls extends StatelessWidget {
  const SettingsControls({super.key});

  final settingsAbcOptions = const ['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
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
              control: Switch(
                value: state.values[SettingsState.settingOneKey],
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingEvent(
                          settingKey: SettingsState.settingOneKey,
                          newValue: value,
                        ),
                      );
                },
              ),
            ),
            SettingsItem(
              mainLabel: "Setting Two",
              subLabel: "Explanation of setting two",
              control: Switch(
                value: state.values[SettingsState.settingTwoKey],
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingEvent(
                          settingKey: SettingsState.settingTwoKey,
                          newValue: value,
                        ),
                      );
                },
              ),
            ),
            SettingsItem(
              mainLabel: "Setting Three",
              control: Switch(
                value: state.values[SettingsState.settingThreeKey],
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingEvent(
                          settingKey: SettingsState.settingThreeKey,
                          newValue: value,
                        ),
                      );
                },
              ),
            ),
            const SettingsHeader(text: "Second Section"),
            SettingsItem(
              mainLabel: "What do you prefer?",
              control: ToggleButtons(
                // 'isSelected' expects a list like [false, true, false]
                isSelected: settingsAbcOptions
                    .map((e) => e == state.values[SettingsState.settingAbcKey])
                    .toList(),
                children: settingsAbcOptions.map((e) => Text(e)).toList(),
                onPressed: (index) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingEvent(
                          settingKey: SettingsState.settingAbcKey,
                          newValue: settingsAbcOptions[index],
                        ),
                      );
                },
              ),
            ),
            // There's an integer setting too, but I didn't write a control
            // for it.
          ],
        );
      },
    );
  }
}
