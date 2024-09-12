import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/settings/settings_bloc.dart';
import 'package:flutter_reference/business/settings/settings_keys.dart';
import 'package:flutter_reference/view/UI/molecules/settings_item.dart';

/// Smaller version of SettingsControls just for one specific setting that
/// appears in the buyers page. This is a separate organism because it serves
/// a different purpose and could theoretically have a totally different
/// design. As it is, it's just a smaller copy of SettingsControls.
class BuyerSettings extends StatelessWidget {
  const BuyerSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            SettingsItem(
              mainLabel: "Simulate Step-up",
              subLabel:
                  "If set, a step-up authentication with a numeric code will be required for seeing details.",
              control: Switch(
                value: state.values[
                    SettingsKey.settingSimulateStepUpRequestOnBuyersListKey],
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingEvent(
                          settingKey: SettingsKey
                              .settingSimulateStepUpRequestOnBuyersListKey,
                          newValue: value,
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
