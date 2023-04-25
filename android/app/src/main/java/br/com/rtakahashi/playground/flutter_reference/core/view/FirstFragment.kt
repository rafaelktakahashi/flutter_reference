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

        // These listeners are merely sending events to the bloc.
        // What you should find interesting is that the bloc exists in Flutter code, but we
        // can use adapters to send events to them, and listen to state changes.

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

        binding.buttonMainMenu.setOnClickListener {
            // First, we navigate to the main menu page _inside_ the Flutter activity.
            InteropNavigator.navigateInFlutter("/", method = "replace")
            // Next, we go to the Flutter activity, where we expect the main menu
            // to already be loaded.
            // In this particular case, we only need to end the current activity, because
            // we know the Flutter activity is the previous one. Your circumstances
            // may differ, so adapt accordingly.
            activity?.finish()
        }

        // Here we use the adapter to listen to the bloc's state.
        // The bloc itself exists in Flutter. The adapter lets us listen to its state.
        // This listener is an example, and it has been implemented with a simple
        // callback function. In your project, you could also implement this with a
        // different strategy, such as a Flow.
        _blocListenerHandle = _counterBlocAdapter.listen() { value ->
            activity?.runOnUiThread { updateOnscreenText(value) }
        }

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