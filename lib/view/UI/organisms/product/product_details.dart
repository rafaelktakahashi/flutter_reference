import 'package:flutter/material.dart';
import 'package:flutter_reference/domain/entity/product.dart';

/// Renders some text with the details of a product.
/// This example just renders text, but in a real project you'd probably use a
/// card and some nicer formatting.
class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Don't add padding here. Padding and margins are added by the parent
    // component, because different spacing is needed in different places.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Product name: ${product.name}"),
        Text("Product description: ${product.description}"),
        Text("Amount in stock: ${product.stockAmount} ${product.unit}"),
      ],
    );
  }
}
