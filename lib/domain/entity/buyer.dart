import 'package:flutter_reference/domain/entity/playground_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "buyer.freezed.dart";
part "buyer.g.dart";

// Example of an entity that has a "simple" version that appears in lists, as
// well as a more detailed version that's fetched separately individually.
// This is applicable to cases where getting the "full" object is costly.

// Please, check the product.dart file for more details about
// how to write and use Freezed classes.

/// Represents a buyer. Very simplified example.
@freezed
class Buyer with _$Buyer implements PlaygroundEntity {
  const factory Buyer({
    /// The person or company's document.
    required String identification,

    /// The person or company's full name.
    required String fullName,
  }) = _Buyer;

  factory Buyer.fromJson(Map<String, Object?> json) => _$BuyerFromJson(json);
}

/// Details of a buyer. Instances of this entity are fetched individually.
@freezed
class BuyerDetails with _$BuyerDetails implements PlaygroundEntity {
  const factory BuyerDetails({
    /// The person or company's document.
    required String identification,

    /// The person or company's current address.
    required String address,

    /// The person or company's full name.
    required String fullName,

    /// E-mail address that this person or company uses.
    required String accountEmail,

    /// The person's birthdate, or the company's date of foundation.
    /// Has a date component only, without time.
    required DateTime birthdate,
  }) = _BuyerDetails;

  factory BuyerDetails.fromJson(Map<String, Object?> json) =>
      _$BuyerDetailsFromJson(json);
}
