import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/domain/entity/product.dart';
import 'package:flutter_reference/view/UI/organisms/product/product_details.dart';
import 'package:flutter_reference/view/templates/fullscreen_error.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Obtain a product from the state.
    // At first glance, you may think it would be simpler if this widget
    // received an entire product. However, always keep in mind that there
    // exists **one** source of truth for each thing, and that's the bloc.

    return BlocBuilder<ProductListBloc, ProductState>(
        builder: (context, state) {
      final Product? product = _selectProduct(state);
      if (product != null) {
        return SimpleTemplate(
          title: "Details of ${product.name}",
          child: Container(
            margin: const EdgeInsets.all(10),
            child: ProductDetails(
              product: product,
            ),
          ),
        );
      } else {
        return const FullscreenErrorTemplate(message: "Product not found");
      }
    });
  }

  /// Private function to get the full product from the state. Returns null when
  /// the product is not found in the state, but if that happens, then there's
  /// a bug in the code.
  Product? _selectProduct(ProductState state) {
    if (state is ProductStateList) {
      return state.products.cast<Product?>().firstWhere(
            (element) => element?.id == productId,
            orElse: () => null,
          );
    }
    return null;
  }
}
