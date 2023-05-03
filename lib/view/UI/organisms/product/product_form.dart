import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reference/domain/entity/product.dart';

/// Form for a new product.
/// This widget _could_ connect to the bloc, but it doesn't need to in this
/// case. It always loads empty and doesn't automatically save anything in the
/// bloc.
class ProductForm extends StatefulWidget {
  /// Function called by this form's submit button.
  final Function(Product) onSubmit;

  const ProductForm({super.key, required this.onSubmit});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

/// This example uses controlled components (where the "live" data exists in
/// our own variables and are updated by the fields' callbacks). Your form does
/// not need to work like this if you prefer it some other way.
///
/// Among other things, this simplifies the business logic because we don't need
/// a bloc just for the form, but having a bloc would be preferrable if you
/// require complicated validation logic. Most of the things would remain the
/// same as in this example, except that the data and the logic would exist in
/// a bloc, rather than in a widget state.
///
/// Overall, there are different places where the form data can live:
/// 1. Only in the fields themselves. Very simple, hard to use conversions,
/// only recommended for simple cases, for example when your form has only one
/// or two fields.
/// 2. In a widget state, as in this example. Not very reusable, but simple to
/// write and understand when you don't need very much business logic in the
/// form.
/// 3. In a bloc. As with everything, you should put things in a bloc when you
/// want reusability, and also when the rules are relatively complicated and
/// closely related to the business. These benefits are real, but they come at
/// the cost of being more complicated to write and maintain, and may not be
/// worth it for simpler forms.
class _ProductFormState extends State<ProductForm> {
  final _descriptionController = TextEditingController(text: "");
  final _nameController = TextEditingController(text: "");
  final _stockAmountController = TextEditingController(text: "1");
  final _unitController = TextEditingController(text: "lb");
  final _priceController = TextEditingController(text: "");

  final _formKey = GlobalKey<FormState>();

  /// These are our validators. They're declared here, outside the form, because
  /// we use them in two places:
  /// - In the forms, to validate the inputs as the user types.
  /// - To decide whether to enable or disable the button when the form changes.
  ///
  /// You can find on the internet examples callilng
  /// `_formKey.currentState!.validate()` manually, but that causes validation
  /// errors to appear for inputs that they user may not have even touched.
  ///
  /// If your validation logic is in a bloc, you can export an object of this
  /// kind to be used in forms.
  final _validators = {
    "description": (String? value) {
      if (value == null || value == "") {
        return "Cannot be empty.";
      } else if (value.length > 40) {
        return "Please, limit the name to 40 characters.";
      }
      return null;
    },
    "name": (String? value) {
      if (value == null || value == "") {
        return "Cannot be empty.";
      } else if (value.length > 160) {
        return "Please, limit the description to 160 characters.";
      }
      return null;
    },
    "stockAmount": (String? value) {
      if (value == null || value == "") {
        return "Cannot be empty.";
      }
      final int? parsed = int.tryParse(value);
      if (parsed == null) {
        return "Please input a valid number.";
      } else if (parsed < 0) {
        return "Please input a non-negative number.";
      }
      return null;
    },
    "unit": (String? value) {
      return null;
    },
    "price": (String? value) {
      // It would be ideal to reuse this logic by making a separate monetary
      // field widget. That would avoid repeated code.
      if (value == null || value == "") {
        return "Cannot be empty.";
      }
      final double? parsed = double.tryParse(value.replaceAll(",", "."));
      if (parsed == null) {
        return "Please input a valid number.";
      } else if (parsed < 0) {
        return "Please input a non-negative number.";
      }
      return null;
    },
  };

  /// Callback for the submit button. When null, the button will be disabled.
  Function()? _submitCallback;

  @override
  void dispose() {
    // Don't forget this. Dispose of all controllers to avoid memory leaks.
    _descriptionController.dispose();
    _nameController.dispose();
    _stockAmountController.dispose();
    _unitController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The best way to build the form depends on the libraries you're using.
    // For example, here I'm using controlled components, but that may not be
    // recommended for the components of your project.
    return Form(
      key: _formKey,
      // Using automatic validation in the whole form may cause validation
      // errors in fields that the user hasn't touched yet (because they're empty).
      // It's better to enable automatic validation in each field individually,
      // so that the validation only runs after the user interacts with each
      // input.
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: () => setState(() {
        _submitCallback = _calculateButtonCallback();
      }),
      child: Column(
        children: [
          TextFormField(
            // This is the kind of component that would normally be a molecule
            // if you need a custom widget. In this case I'm using the one that
            // Flutter already gives us. You may want to use widgets from a
            // library.
            decoration: const InputDecoration(
              icon: Icon(Icons.abc),
              hintText: "Name of the product",
              labelText: "Name",
            ),
            controller: _nameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validators["name"],
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.edit_document),
              hintText: "Describe the product",
              labelText: "Description",
            ),
            controller: _descriptionController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validators["description"],
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.numbers),
              hintText: "Amount in stock",
              labelText: "Amount",
            ),
            controller: _stockAmountController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            validator: _validators["stockAmount"],
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.balance),
              hintText: "Unit of measurement",
              labelText: "Unit",
            ),
            controller: _unitController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validators["unit"],
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.euro),
              hintText: "Price per unit in euros",
              labelText: "Price",
            ),
            controller: _priceController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            validator: _validators["price"],
            inputFormatters: [_EuroInputFormatter()],
          ),
          TextButton(
            // If the validate() call returns false (meaning error), we use null
            // to make the TextButton render disabled.
            // The validate() function will be called every time this button
            // renders, so we shouldn't use computationally expensive validators.
            onPressed: _submitCallback,
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  /// Calculates the button callback.
  ///
  /// The purpose of this is to automatically enable/disable the button as the
  /// fields are edited. If some validation becomes computationally expensive,
  /// then it may not be worth it to have this automatic enable/disable.
  Function()? _calculateButtonCallback() {
    // You can find examples on the internet telling you to call
    // _formKey.currentState!.validate(), but that causes validation errors to
    // appear on screen. In this case, this is not what we want because this
    // function will be called whenever the form changes. This means that an
    // error could appear in fields that the user hasn't touched yet, and that's
    // a bad experience.

    // To know if there's a validation error, we call every validation manually.
    final validationErrors = [
      _validators["name"]!(_nameController.text),
      _validators["description"]!(_descriptionController.text),
      _validators["stockAmount"]!(_stockAmountController.text),
      _validators["unit"]!(_unitController.text),
      _validators["price"]!(_priceController.text),
    ];

    if (validationErrors.any((element) => element != null)) {
      // There are validation errors. Return null, because that'll make the
      // button render in its disabled state.
      return null;
    }

    // If there aren't any validation errors, we return a function.
    return _buttonCallbackWhenEnabled;
  }

  /// Only used in _buttonCallback().
  void _buttonCallbackWhenEnabled() {
    // The price is formatted with two decimal places and with a comma as the
    // decimal separator, such as "50,25".
    // We first replace the comma by a dot, and then parse it as a double. Then,
    // we multiply by 10, truncate the decimal part, and cast to int.
    // There may be an easier way to do this.

    final rawString = _priceController.text;
    // Adds ,00 if the text doesn't have a comma.
    final rawStringWithCents =
        rawString.contains(',') ? rawString : '$rawString,00';
    // "25,99" -> 25.99
    final priceAsDouble =
        double.tryParse(rawStringWithCents.replaceAll(",", ".")) ?? 0.00;
    // 25.99 -> 2599
    final priceAsCents = (priceAsDouble * 100).truncate();
    // We store the value as the integer 2599.

    final result = Product(
      id: const Uuid().v4(),
      name: _nameController.text,
      description: _descriptionController.text,
      stockAmount: int.tryParse(_stockAmountController.text) ?? 0,
      unit: _unitController.text,
      pricePerUnitCents: priceAsCents,
    );

    widget.onSubmit(result);
  }
}

/// Our custom currency formatter. Not intended to be used with other formatters.
class _EuroInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // oldValue is what is already in the field. newValue is what would appear
    // in the field as a result of what the user typed. We return what will
    // appear in the field.

    // Use 6 as the maximum length.
    // ex.: "120,99"
    if (newValue.text.length > 6) {
      // If the field would become too long, return the old value so that there
      // will be no change.
      return oldValue;
    }
    // Consequently, the value without a comma cannot exceed 3 digits. Forbid
    // the user from writing a fourth digit.
    // If you don't check for this, then the user would be able to insert too
    // many digits before the separator, and be left without the ability to
    // write the cents.
    // (The regex [\.,] means comma or period.)
    if (!newValue.text.contains(RegExp(r'[\.,]')) && newValue.text.length > 3) {
      return oldValue;
    }

    // Allow only new values that match this regex:
    //
    // ^\d*[\.,]?\d{0,2}$
    //
    // ^                     Start of string
    //  \d*                  Zero or more digits
    //     [\.,]             Followed by a dot or a comma (but not both)
    //          ?            ...or not
    //           \d{0,2}     Followed by up to two digits
    //                  $    End of string
    //
    // This matches strings that have a comma or a dot at the end, since the
    // user will be typing. It does not allow strings with more than two digits
    // after the comma or the dot, and also does not allow strings that have
    // both a comma and a dot.
    // This regex also matches the empty string, but that means the user can
    // insert strings that begin with the decimal separator.

    if (RegExp(r'^\d*[\.,]?\d{0,2}$').hasMatch(newValue.text)) {
      // Matches!

      // Return the new value with the comma as decimal separator. This way, the
      // user can also type a dot, but it'll be turned into a comma.
      final commaSeparated = newValue.text.replaceAll('.', ',');
      // And also, if the user typed a decimal separator at the start of the
      // string, add a 0 to the start and move the cursor forward one character.
      // (Dart can parse a string like ".50", but this is for the user.)
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
