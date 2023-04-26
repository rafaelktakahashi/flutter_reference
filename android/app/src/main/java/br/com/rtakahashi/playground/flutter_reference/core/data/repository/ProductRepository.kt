package br.com.rtakahashi.playground.flutter_reference.core.data.repository

import br.com.rtakahashi.playground.flutter_reference.core.data.repository.infra.InteropRepository
import br.com.rtakahashi.playground.flutter_reference.core.domain.entity.Product
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import org.json.JSONObject
import java.util.concurrent.TimeUnit

class ProductRepository : InteropRepository("product") {

    init {
        super.exposeMethod("fetchProducts") { _ -> fetchProducts() }
        // Be careful here. In Android, objects received from Flutter are instances of
        // JsonObject. In iOS, they're Dictionaries just like the objects send to Flutter.
        super.exposeMethod("addProduct") { params -> addProduct((params as JSONObject)["product"] as JSONObject) }
    }

    private var products: MutableList<Product> = mutableListOf(
        Product(
            "0001",
            "Powder computer",
            "Finely ground computer",
            3,
            "g",
        ),
        Product(
            "0090",
            "Paperback",
            "The backside of a sheet of paper (front side purchased separately).",
            5,
            "unit",
        ),
        Product(
            "0022",
            "Green ideas",
            "Thought, concept or mental impression of the green variety.",
            8,
            "unit",
        ),
    );

    // Normally a repository would also have methods to be used by Android code,
    // but this one is merely an example of an interop repository that exposes
    // its methods to the Flutter side.
    // In real code, you would also have methods returning Flows, or Eithers, or
    // whatever is your return type of choice.

    /**
     * Method exposed to the other side of the bridge.
     * Stuff like Flow is difficult to serialize, so we use separate functions
     * like these that throw on error.
     *
     * Be absolutely sure to only expose maps, not Kotlin/Java objects. Objects
     * get turned to strings using their implementation of toString(), which is
     * pretty much useless for us.
     */
    private suspend fun fetchProducts(): List<Map<String,Any>> {
        delay(1500)
        return products.map { it.toMap() }
    }

    /**
     * Method exposed to the other side of the bridge.
     * This receives a product as a JsonObject, and adds it to the list.
     */
    private suspend fun addProduct(productMap: JSONObject) {
        delay(1500)
        products.add(Product(productMap))
    }

}