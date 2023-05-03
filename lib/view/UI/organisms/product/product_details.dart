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
        _textWithPadding("Product name: ${product.name}"),
        _textWithPadding("Product description: ${product.description}"),
        _textWithPadding(
            "Amount in stock: ${product.stockAmount} ${product.unit}"),
        _textWithPadding(
            "Price per ${product.unit}: ${_formatEuros(product.pricePerUnitCents)}"),
      ],
    );
  }

  Widget _textWithPadding(String text) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Text(text),
    );
  }

  String _formatEuros(int cents) {
    // Formatting from the amount in cents.
    // This rule will depend on the currency and storage format that you use.
    int centsOnly = cents % 100;
    int eurosOnly = (cents / 100).truncate();

    return "$eurosOnly,$centsOnly €";
  }
}
