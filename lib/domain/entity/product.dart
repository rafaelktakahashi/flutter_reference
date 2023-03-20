

import 'package:flutter_reference/domain/entity/megastore_entity.dart';

/// Represents a unique product along with its quantity in stock.
class Product extends MegastoreEntity {
  /// The product's unique identifier.
  final String id;
  /// The product's readable name.
  final String name;
  /// A detailed description of the product.
  final String description;
  /// The product's amount in stock.
  final int stockAmount;
  /// The product's unit of measure.
  final String unit;

  const Product(this.id, this.name, this.description, this.stockAmount, this.unit);
}