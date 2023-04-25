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
  final TextEditingController _descriptionController =
      TextEditingController(text: "");
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _stockAmountController =
      TextEditingController(text: "1");
  final TextEditingController _unitController =
      TextEditingController(text: "lb");

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Don't forget this. Dispose of all controllers to avoid memory leaks.
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The best way to build the form depends on the libraries you're using.
    // For examples, here I'm using controlled components, but that may not be
    // recommended for the components of your project.
    return Form(
      key: _formKey,
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
            validator: (String? value) {
              if (value == null || value == "") {
                return "Cannot be empty.";
              } else if (value.length > 40) {
                return "Please, limit the name to 40 characters.";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.edit_document),
              hintText: "Describe the product",
              labelText: "Description",
            ),
            controller: _descriptionController,
            validator: (String? value) {
              if (value == null || value == "") {
                return "Cannot be empty.";
              } else if (value.length > 160) {
                return "Please, limit the description to 160 characters.";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.numbers),
              hintText: "Amount in stock",
              labelText: "Amount",
            ),
            controller: _stockAmountController,
            validator: (String? value) {
              if (value == null || value == "") {
                return "Cannot be empty.";
              }
              final int? parsed = int.tryParse(value);
              if (parsed == null) {
                return "Please input a valid number.";
              } else if (parsed < 0) {
                return "Plase input a non-negative number.";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.balance),
              hintText: "Unit of measurement",
              labelText: "Unit",
            ),
            controller: _unitController,
            validator: (String? value) {
              return null;
            },
          ),
          TextButton(
            // If the validate() call returns false (meaning error), we use null
            // to make the TextButton render disabled.
            // The validate() function will be called every time this button
            // renders, so we shouldn't use computationally expensive validators.
            onPressed: _formKey.currentState!.validate()
                ? () {
                    // Create the product and call the callback.
                    final result = Product(
                      id: const Uuid().v4(),
                      name: _nameController.text,
                      description: _descriptionController.text,
                      stockAmount:
                          int.tryParse(_stockAmountController.text) ?? 0,
                      unit: _unitController.text,
                    );

                    widget.onSubmit(result);
                  }
                : null,
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
