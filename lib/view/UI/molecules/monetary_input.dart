import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// This is an example of a molecule that has a relatively large amount of
// internal logic.
// The main takeaway is that molecules can have complicated logic. This logic
// should be as reusable as possible, and the molecule should not be aware of
// the app's domain. This means that the molecule should not reference any blocs
// or domain entities. In theory, you could copy this widget and use it in any
// project.
// At the same time, this widget clearly has a use case (it's for inputting
// monetary values).
//
// -> A molecule that needs to be aware of the app's domain is not a molecule,
// but an organism.
// -> A molecule that doesn't have a clear use case is not a molecule, but an
// atom.

/// Input with a formatter for monetary values. It only allows values such as
/// "25,50", with a comma as decimal separator (the user can type a period, but
/// then it will be turned into a comma), and at most two digits after the
/// separator.
///
/// Specifically, this example only works with euros. I chose euros to
/// demonstrate formatting with the comma as decimal separator. Since the period
/// is the default in programming languages, using American dollars would've
/// been too easy, and not helpful for explaining formatting for currencies that
/// use the comma as decimal separator.
///
/// Of course, you should adapt this to your own needs. The intl package was not
/// used here, but it's recommended if you need more support for more locales
/// and masks.
///
/// This widget does not add a mask. It only restricts what the user can type
/// into the field. This uses a TextFormField internally, and many of its
/// properties are exposed.
class MonetaryInput extends StatelessWidget {
  // All these properties are exposed from TextFormField.
  // In React Native, you can simply expose all props and then pass them on to
  // a child using {...props}, but I do not know of an esier way to do this in
  // Dart.
  //
  // I'm only exposing the fields that we use, since the TextFormField widget
  // has many dozens. If you need anything else from TextFormField, just add it
  // here.
  final InputDecoration? decoration;
  final MonetaryTextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  /// Aside from the typical string, this callback also receives the parsed
  /// numerical value of the field.
  final Function(String, double)? onChanged;

  const MonetaryInput({
    super.key,
    this.decoration,
    this.controller,
    this.autovalidateMode,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: decoration,
      controller: controller,
      autovalidateMode: autovalidateMode,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: [_EuroInputFormatter()],
      onChanged: (str) {
        if (onChanged != null) {
          // When using this widget, you will also get the parsed value. Try to
          // reuse logic whenever possible.
          final asDouble = double.tryParse(str.replaceAll(',', '.')) ?? 0.00;
          onChanged?.call(str, asDouble);
        }
      },
    );
  }
}

/// ```
/// ^\d{0,3}([\.,]\d{0,2})?$
///
/// ^                         Beginning of string
///  \d{0,3}                  Zero to three digits
///         (            )?   Followed by an optional group
///          [\.,]            The group begins with a comma or a dot
///               \d{0,2}     Followed by zero to two digits
///                        $  End of string.
///
///       3 + 1 + 2 = Maximum length of 6 characters.
/// ```
///
/// Examples of values that match:
///           `"20"`,  `""`, `"25."`, `"25,"`, `"25,5"`,
///           `"25,50"`, `","`, `",99"`, `"0"`, `"999,2"`, etc.
///
/// Examples of values that do not match:
///           `"0.555"`, `"0,555"`, `"1000"`, `"0,"` etc.
///
/// This matches strings that have a comma or a dot at the end, since the
/// user will be typing. It does not allow strings with more than two digits
/// after the comma or the dot, and also does not allow strings that have
/// both a comma and a dot.
/// This regex also matches the empty string (if we don't, then the field
/// wouldn't allow for erasing the last digit), and also allows for typing
/// just the decimal separator without anything before it.
final _monetaryRegexp = RegExp(r'^\d{0,3}([\.,]\d{0,2})?$');

/// Our custom currency formatter.
/// Not intended to be used with other formatters.
class _EuroInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // oldValue is what is already in the field. newValue is what would appear
    // in the field as a result of what the user typed. We return what will
    // appear in the field.
    //
    // The returned value isn't just the text, but also the text selection and
    // the cursor's position.

    // See the comment over this regex's declaration for an explanation.
    if (_monetaryRegexp.hasMatch(newValue.text)) {
      // Matches!

      // Return the new value with the comma as decimal separator. This way, the
      // user can also type a dot, but it'll be turned into a comma.
      final commaSeparated = newValue.text.replaceAll('.', ',');
      // And also, if the user typed a decimal separator at the start of the
      // string, add a 0 to the start and move the cursor forward one character.
      // (Dart can parse a string like ".50" perfectly fine, but this formatting
      // is for the user, who may expect a leading 0.)
      if (commaSeparated.startsWith(',')) {
        return newValue.copyWith(
          text: "0$commaSeparated", // "," -> "0,"
          // Move the caret forward by adding one to both ends of the selection.
          // At this point, we expect the selection to be empty, so both
          // values should be the same. This doesn't change the overall logic.
          selection: newValue.selection.copyWith(
            baseOffset: newValue.selection.baseOffset + 1,
            extentOffset: newValue.selection.extentOffset + 1,
          ),
        );
      } else {
        return newValue.copyWith(text: commaSeparated);
      }
    } else {
      // Does not match. Return the old value.
      return oldValue;
    }
  }
}

/// Extension of [TextEditingController] specifically for use in our
/// [MonetaryInput]. This validates the initial value and exposes methods for
/// easily retrieving the numeric value in the field.
class MonetaryTextEditingController extends TextEditingController {
  // Call the super constructor, but ignore the text if it doesn't match our
  // regex.
  MonetaryTextEditingController({String? text})
      : super(
          text: text != null && _monetaryRegexp.hasMatch(text)
              ? text.startsWith(',')
                  ? "0$text"
                  : text
              : null,
        );

  // We're not exposing the `fromValue` constructor; we don't use it, and it has
  // the additional complication of validating the caret and possibly having to
  // add a leading zero, which requires offsetting the caret. Probably not worth
  // it doing all that.

  /// Gets the value as a double. For example, if the field contains the string
  /// `"84,99"`, then this will return the double `84.99`.
  double get valueAsDouble {
    final parsed = double.tryParse(text.replaceAll(',', '.'));
    return parsed ?? 0.00;
  }

  /// Gets the value as an integer amount of cents. For example, if the field
  /// contains the string `"84,99"`, then this will return the int `8499`.
  int get valueAsCents {
    return (valueAsDouble * 100).truncate();
  }
}
