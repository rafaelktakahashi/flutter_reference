import 'package:flutter/material.dart';
import 'package:flutter_reference/domain/entity/buyer.dart';

/// One entry that is meant to render in a list, representing a buyer.
/// Touching this widget triggers a callback.
class BuyerEntry extends StatelessWidget {
  final Buyer buyer;
  final Function()? onPressed;

  const BuyerEntry({super.key, required this.buyer, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        height: 50,
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Text(
            buyer.fullName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
