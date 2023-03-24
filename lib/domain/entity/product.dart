import 'package:flutter_reference/domain/entity/megastore_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "product.freezed.dart";

/// Represents a unique product along with its quantity in stock.
@freezed
class Product extends MegastoreEntity with _$Product {
  const factory Product({
    /// The product's unique identifier.
    required String id,

    /// The product's readable name.
    required String name,

    /// A detailed description of the product.
    required String description,

    /// The product's amount in stock.
    required int stockAmount,

    /// The product's unit of measure.
    required String unit,
  }) = _Product;
}

/// This class uses freezed. If you don't know how to use it, read the
/// official documentation first; note that these classes reference code
/// generated by freezed, so the first time you write a class, your editor
/// will tell you that there are errors. You have to run
/// `flutter pub run build_runner build` in the terminal.
/// The important parts are: include the "part" statement at the top (you'll
/// have to write the name by hand without autocomplete the first time
/// because the file won't exist yet); add "with _Class" after the class
/// declaration, and then write a factory constructor with "= _Class" after it.
/// Classes created this way will be immutable.