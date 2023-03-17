package br.com.rtakahashi.playground.flutter_reference.core.injection

import br.com.rtakahashi.playground.flutter_reference.core.bloc.CounterBlocAdapter

/**
 * This project isn't using a real dependency injection library.
 * Just pretend that this is real DI.
 */
object Injector {
    private val table: MutableMap<String, Any> = mutableMapOf();

    fun registerObject(name: String, value: Any) {
        table[name] = value;
    }

    fun <T>read(name: String): T {
        // This is unsafe. Presumably, a read DI library wouldn't have
        // this problem.
        return table[name] as T;
    }
}