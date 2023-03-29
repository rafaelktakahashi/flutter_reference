package br.com.rtakahashi.playground.flutter_reference.core.domain.entity

class Product(
    val id: String,
    val name: String,
    val description: String,
    val stockAmount: Int,
    val unit: String,
) : PlaygroundEntity {
    fun toMap(): Map<String, Any> {
        return mapOf(
            "id" to id,
            "name" to name,
            "description" to description,
            "stockAmount" to stockAmount,
            "unit" to unit,
        )
    }

    // You may also need a factory constructor to instantiate this from a map.
}