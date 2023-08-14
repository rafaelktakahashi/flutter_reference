import 'package:flutter_reference/domain/entity/playground_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "address.freezed.dart";
part "address.g.dart";

@freezed
class Address with _$Address implements PlaygroundEntity {
  const factory Address({
    /// Postal code; format and name varies by country. Sometimes called
    /// "zip code", but generally speaking that's not correct because zip codes
    /// are a system used only by the United States Postal Service (USPS).
    ///
    /// The amount of information contained in the postal code varies by country
    /// and even varies by region in each country. Generally speaking, postal
    /// codes should not be considered sufficient to deduce an entire address.
    ///
    /// Examples:
    /// "48227" (Detroit, Michigan, USA)
    /// "13010-180" (Praça dos Ferroviários, Campinas, SP, Brazil)
    /// "849-0500" (Kohoku-machi, Kishima-gun, Saga-ken, Japan)
    ///
    /// This class is merely an example, and in your case you may only need to
    /// handle addresses in one or a few countries. This class assembles the
    /// address as is done in the US and the UK, with building number first,
    /// then street name, then city, state, postal code and country. Other
    /// countries follow their own schemes:
    /// - Brazilian addresses place the building number after the street name,
    /// and also include a neighborhood name (bairro) after the number. They
    /// also don't typically include the postal code (CEP) inside the written
    /// address.
    /// - Japanese addresses are written in order of largest unit to smallest,
    /// starting with the prefecture (todofuken), then a municipality (shi/ku/
    /// gun), followed by either the city (cho/machi) and district (chome) or
    /// aza, and then the building number (go). Addresses in Japan do not
    /// include the street name, and there are very many exceptions and special
    /// cases where a region may have its own address structure that deviates
    /// from the standard.
    required String postalCode,

    /// Most specific part of an address. Varies by country, but here it always
    /// covers everything that's more specific than the city.
    required String streetAddress,

    /// Number, which may contain non-numeric digits as well (ex.: "10b").
    /// If the address does not have a number, use null.
    String? number,

    /// Full name of the city.
    required String city,

    /// Name or abbreviation for the highest administrative division of the
    /// country, which may be a state, oblast, canton, prefecture, provice or
    /// region among many other names.
    /// Ex.: "SP" (State in Brazil), "MI" (State in the USA),
    /// "Черка́ська о́бласть" (Oblast in Ukraine), "沖縄県" (Prefecture in Japan)
    required String state,

    /// Localized name of the country, in the same language as the rest of the
    /// address. Ex.: "USA", "Brasil", "Ελλάδα"
    required String country,
  }) = _Address;

  const Address._();

  factory Address.fromJson(Map<String, Object?> json) =>
      _$AddressFromJson(json);

  @override
  String toString() {
    final str = "$streetAddress, $city, $state, $postalCode $country";
    return number != null ? "$number $str" : str;
  }
}
