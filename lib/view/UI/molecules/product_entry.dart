import 'package:flutter/material.dart';
import 'package:flutter_reference/domain/entity/product.dart';

/// One entry that is meant to render inside a list.
/// Touching this widget triggers a callback.
class ProductEntry extends StatelessWidget {
  final Product product;
  final Function(Product)? onPressed;

  const ProductEntry({super.key, required this.product, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call(product);
      },
      child: Container(
        height: 50,
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child:
              Text("${product.name}, ${product.stockAmount} ${product.unit}"),
        ),
      ),
    );
  }
}
