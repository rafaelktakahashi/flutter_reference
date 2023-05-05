import 'package:flutter/material.dart';
import 'package:flutter_reference/domain/entity/buyer.dart';

/// Renders some text with a buyer's details. If the specified [buyer] is null,
/// then this card will render with a loading indicator.
class BuyerDetailsCard extends StatelessWidget {
  final BuyerDetails? buyer;

  const BuyerDetailsCard({super.key, required this.buyer});

  @override
  Widget build(BuildContext context) {
    // If the buyer is null, this card renders with a loading indicator.
    if (buyer == null) {
      return const Card(
        child: Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Card(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _formattedText(
                "${buyer!.identification} — ${buyer!.fullName}",
                Theme.of(context).colorScheme.onSurface,
                28,
                FontWeight.bold,
              ),
              _formattedText(
                buyer!.accountEmail,
                Theme.of(context).colorScheme.onSurface,
                18,
              ),
              _formattedText(
                "Birthdate: ${buyer!.birthdate.day}/${buyer!.birthdate.month}/${buyer!.birthdate.year}",
                Theme.of(context).colorScheme.secondary,
                22,
              ),
              _formattedText(
                "Address: ${buyer!.address}",
                Theme.of(context).colorScheme.onSurface,
                16,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _formattedText(String text, Color color, double size,
      [FontWeight weight = FontWeight.normal]) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: size,
            color: color,
            fontWeight: weight,
          ),
        ),
      ),
    );
  }
}
