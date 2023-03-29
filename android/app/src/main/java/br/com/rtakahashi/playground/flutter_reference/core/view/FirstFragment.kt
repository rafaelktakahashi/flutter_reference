package br.com.rtakahashi.playground.flutter_reference.core.view

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.fragment.findNavController
import br.com.rtakahashi.playground.flutter_reference.core.bloc.CounterBlocAdapter
import br.com.rtakahashi.playground.flutter_reference.core.bloc.CounterState
import br.com.rtakahashi.playground.flutter_reference.core.bloc.CounterStateError
import br.com.rtakahashi.playground.flutter_reference.core.bloc.CounterStateNumber
import br.com.rtakahashi.playground.flutter_reference.core.injection.Injector
import br.com.rtakahashi.playground.flutter_reference.databinding.FragmentFirstBinding
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class FirstFragment : Fragment() {

    private lateinit var _counterBlocAdapter: CounterBlocAdapter;

    private var _binding: FragmentFirstBinding? = null

    private var _blocListenerHandle: String? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Don't pay attention to this. In a real project, you'd get instances of the bloc adapters
        // using a real dependency-injection library.
        _counterBlocAdapter = Injector.read("counterBlocAdapter");

        _binding = FragmentFirstBinding.inflate(inflater, container, false)

        return binding.root

    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.buttonAddOne.setOnClickListener {
            _counterBlocAdapter.incrementBy(1);
        };
        binding.buttonAddFive.setOnClickListener {
            _counterBlocAdapter.incrementBy(5);
        };
        binding.buttonDouble.setOnClickListener {
            _counterBlocAdapter.multiplyBy(2);
        };
        binding.buttonTriple.setOnClickListener {
            _counterBlocAdapter.multiplyBy(3);
        };
        binding.buttonReset.setOnClickListener {
            _counterBlocAdapter.reset();
        };

        _blocListenerHandle = _counterBlocAdapter.listen() { value -> updateOnscreenText(value) }

        // Initialize the text with whatever state exists in the adapter.
        updateOnscreenText(_counterBlocAdapter.currentState());

    }

    private fun updateOnscreenText(state: CounterState) {
        if (state is CounterStateNumber) {
            binding.textviewFirst.text = state.value.toString();
        } else if (state is CounterStateError) {
            binding.textviewFirst.text = state.errorMessage;
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
        if (_blocListenerHandle != null) _counterBlocAdapter.clearListener(_blocListenerHandle as String);
    }
}