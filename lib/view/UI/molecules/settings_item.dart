import 'package:flutter/widgets.dart';

/// One item of many that render in a list when showing settings.
///
/// Each item has an interactive control on the right side, and a label on
/// the left side.
///
/// The interactive control must be provided by the parent. Accordingly, this
/// widget doesn't have callbacks.
class SettingsItem extends StatelessWidget {
  /// Text that appears to the left.
  final String mainLabel;

  /// Optionally, text that appears under the main text, in a smaller font.
  final String? subLabel;

  /// Interactive control (or any other widget) that appears right-aligned.
  final Widget control;

  const SettingsItem({
    super.key,
    required this.mainLabel,
    this.subLabel,
    required this.control,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: _SettingsText(
              mainLabel: mainLabel,
              subLabel: subLabel,
            ),
          ),
          control,
        ],
      ),
    );
  }
}

class _SettingsText extends StatelessWidget {
  final String mainLabel;
  final String? subLabel;

  const _SettingsText({super.key, required this.mainLabel, this.subLabel});

  @override
  Widget build(BuildContext context) {
    if (subLabel == null) {
      return Text(mainLabel, style: const TextStyle(fontSize: 16));
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mainLabel, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 3), // spacer
          Text(subLabel!, style: const TextStyle(fontSize: 11)),
        ],
      );
    }
  }
}
