import 'package:flutter/material.dart';

/// Simple text that renders over a specified background color.
///
/// [largeText] and [smallText] are both optional. If both are specified,
/// [largeText] renders above and [smallText] under it (separately, not in a
/// stack). As the names imply, [largeText] renders with a bigger font size.
///
/// If specified, the [extra] widget renders under the text.
///
/// A [backgroundColor] may be specified, and is the theme's surface color by
/// default. The [foregroundColor] may also be specified, and by default it's
/// calculated to be either black or white depending on the background color.
class TextOverColor extends StatelessWidget {
  final String? largeText;
  final String? smallText;
  final Widget? extra;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const TextOverColor({
    super.key,
    this.largeText,
    this.smallText,
    this.extra,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).colorScheme.background;
    final fgColor = _calculateFgColor(bgColor);

    // List of widgets that will render from top to bottom.
    final List<Widget> textList = [];

    if (largeText != null) {
      textList.add(Text(
        largeText!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: fgColor,
        ),
      ));
    }
    if (largeText != null && smallText != null) {
      textList.add(const SizedBox(height: 7)); // Spacer
    }
    if (smallText != null) {
      textList.add(Text(
        smallText!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      ));
    }

    if (extra != null) {
      textList.add(const SizedBox(height: 7)); // Spacer
      textList.add(extra!);
    }

    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: textList,
          ),
        ),
      ),
    );
  }

  /// Either the foreground color from the constructor if one was specified, or
  /// black or white, automatically calculated from the background color's
  /// luminance.
  Color _calculateFgColor(Color bgColor) {
    // A color's luminance is closer to 0 when it's dark, and closer to 1 when
    // it's bright. Some colors contribute more than others to the subjective
    // perception of brightness.
    // Source for the formula: https://stackoverflow.com/a/3943023
    // This calculates whether the bgColor has more constrast against white, or
    // more constrast agains black, then returns whichever has higher contrast.
    final luminance =
        (bgColor.red * 0.299 + bgColor.green * 0.587 + bgColor.blue * 0.114);
    return luminance > 0.179 ? Colors.black : Colors.white;
  }
}
