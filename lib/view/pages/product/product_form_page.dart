import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/product/product_form_bloc.dart';
import 'package:flutter_reference/view/UI/organisms/product/product_form.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';
import 'package:go_router/go_router.dart';

/// Page for a form where the user fill in details to create a new product.
///
/// In this example, we're not supporting editing an existing product's data.
class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    // In this case, the form itself doesn't know how to save data. Instead,
    // the page is responsible for that, and we send the user to another page
    // to show the progress of the operation.
    // Note that even if we chose to connect to the bloc in the organism (the
    // form), the form itself wouldn't know anything about routes. Only pages
    // know about routes, because the same organisms can appear in different
    // pages with different routes.
    return SimpleTemplate(
      title: "New Product",
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ProductForm(
          onSubmit: (product) {
            context.read<ProductFormBloc>().add(SubmitProductEvent(product));
            // When the user presses the submit button, we send them to another
            // page to show the loading indicator and the result. There, in case
            // of success, we'll add the new item to the list.
            context.push("/products/new/result");
          },
        ),
      ),
    );
  }
}
