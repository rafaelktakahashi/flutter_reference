package br.com.rtakahashi.playground.flutter_reference.core.domain.entity

import org.json.JSONObject

class Product(
    val id: String,
    val name: String,
    val description: String,
    val stockAmount: Int,
    val unit: String,
    /**
     * Price per unit, in cents of Euros.
     *
     * The reason why this example uses Euros is to demonstrate formatting. Euros use the
     * comma as decimal separator.
     */
    val pricePerUnitCents: Int,
) : PlaygroundEntity {

    // Certainly there are safer ways to implement conversion to and from maps,
    // such as using a library, but this project just uses a simple example to convey
    // what is the thing you need.

    fun toMap(): Map<String, Any> {
        return mapOf(
            "id" to id,
            "name" to name,
            "description" to description,
            "stockAmount" to stockAmount,
            "unit" to unit,
            "pricePerUnitCents" to pricePerUnitCents
        )
    }

    constructor(map: JSONObject) : this(
        map["id"] as String,
        map["name"] as String,
        map["description"] as String,
        map["stockAmount"] as Int,
        map["unit"] as String,
        map["pricePerUnitCents"] as Int,
    )
}