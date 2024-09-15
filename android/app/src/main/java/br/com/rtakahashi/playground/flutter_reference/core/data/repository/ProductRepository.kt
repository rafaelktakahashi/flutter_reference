package br.com.rtakahashi.playground.flutter_reference.core.data.repository

import br.com.rtakahashi.playground.flutter_reference.core.data.repository.infra.InteropRepository
import br.com.rtakahashi.playground.flutter_reference.core.data.service.LocalStorageService
import br.com.rtakahashi.playground.flutter_reference.core.data.service.StepUpPromptService
import br.com.rtakahashi.playground.flutter_reference.core.domain.entity.Product
import br.com.rtakahashi.playground.flutter_reference.core.domain.error.PlaygroundClientException
import br.com.rtakahashi.playground.flutter_reference.core.injection.Injector
import kotlinx.coroutines.delay
import org.json.JSONObject

class ProductRepository : InteropRepository("product") {

    init {
        super.exposeMethod("fetchProducts") { _ -> fetchProducts() }
        // Be careful here. In Android, objects received from Flutter are instances of
        // JsonObject. In iOS, they're Dictionaries just like the objects sent to Flutter.
        super.exposeMethod("addProduct") { params -> addProduct((params as JSONObject)["product"] as JSONObject) }
    }

    private var products: MutableList<Product> = mutableListOf(
        Product(
            "0001",
            "Powder computer",
            "Finely ground computer",
            3,
            "g",
            799, // 7,99 €
        ),
        Product(
            "0090",
            "Paperback",
            "The backside of a sheet of paper (front side purchased separately).",
            5,
            "unit",
            299,
        ),
        Product(
            "0022",
            "Green ideas",
            "Thought, concept or mental impression of the green variety.",
            8,
            "unit",
            2599,
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
    private suspend fun fetchProducts(): List<Map<String, Any>> {
        delay(1500)

        // Check if we're supposed to suspend execution and prompt the user for a
        // step-up authentication code.
        // This was added after the fact, and the main example is in the buyers
        // page, so check there first.
        val localStorageService = Injector.read<LocalStorageService>("localStorageService");

        try {
            val shouldRequireStepUpString = localStorageService.read(
                "SETTING_SIMULATE_STEP_UP_REQUEST_ON_NATIVE_PRODUCTS_LIST",
                default = "false"
            );

            val shouldRequireStepUp = when (shouldRequireStepUpString) {
                "true" -> true
                "false" -> false
                else -> false
            }

            if (shouldRequireStepUp) {
                val stepUpPromptService = Injector.read<StepUpPromptService>("stepUpPromptService");
                when (val result = stepUpPromptService.showStepUpPrompt("mock session id")) {
                    null -> {
                        // Unsuccessful: fail by throwing an error that simulates a failed request.
                        throw PlaygroundClientException(
                            errorCode = "PRODUCT-0095",
                            statusCode = "403",
                            developerMessage = "Step-up request was required but did not succeed."
                        )
                    }

                    else -> {
                        // Now we're supposed to check if the code is correct. You would do that
                        // here by firing a second request with the token in a header.
                        // In this demo project, we just check that the token is the fixed string.
                        val stepUpAuthToken: String = result;
                        if (stepUpAuthToken != "諸行無常 諸行是苦 諸法無我") {
                            throw PlaygroundClientException(
                                errorCode = "PRODUCT-0096",
                                statusCode = "403",
                                developerMessage = "Step-up request was required but the token was not accepted."
                            )
                        }
                    }
                }
            }

        } catch (e: Exception) {
            println(e);
            throw e
        }

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