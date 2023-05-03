import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/settings/settings_bloc.dart';
import 'package:flutter_reference/view/UI/molecules/settings_header.dart';
import 'package:flutter_reference/view/UI/molecules/settings_item.dart';

/// Settings for the app.
///
/// This is a fixed list of settings. Its main purpose is to showcase the
/// settings bloc, but things that are written to local storage don't
/// necessarily need to be through
class SettingsControls extends StatelessWidget {
  const SettingsControls({super.key});

  final settingsAbcOptions = const ['A', 'B', 'C'];
  final settingsNumberOptions = const [20, 40, 60];

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
            const Padding(
              padding: EdgeInsets.all(5),
              child: Text("These settings are stored in the local storage."),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "You can close the app, open it again, and the data will be as you left it.",
              ),
            ),
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
            SettingsItem(
              mainLabel: "Choose a number:",
              control: ToggleButtons(
                isSelected: settingsNumberOptions
                    .map(
                      (e) => e == state.values[SettingsState.settingNumberKey],
                    )
                    .toList(),
                children: settingsNumberOptions.map((e) => Text("$e")).toList(),
                onPressed: (index) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingEvent(
                          settingKey: SettingsState.settingNumberKey,
                          newValue: settingsNumberOptions[index],
                        ),
                      );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
