import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/address_lookup/address_lookup_bloc.dart';

class AddressLookup extends StatelessWidget {
  const AddressLookup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressLookupBloc, AddressLookupState>(
      builder: (context, state) {
        final addressLookupBloc = context.read<AddressLookupBloc>();

        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddressLookupForm(
                onSubmit: (cep) {
                  addressLookupBloc.add(AddressLookupEventCep(cep));
                },
              ),
              Text(addressLookupLabel(state)),
            ],
          ),
        );
      },
    );
  }
}

class AddressLookupForm extends StatefulWidget {
  const AddressLookupForm({super.key, required this.onSubmit});

  final Function(String) onSubmit;

  @override
  State<StatefulWidget> createState() {
    return _AddressLookupFormState();
  }
}

class _AddressLookupFormState extends State<AddressLookupForm> {
  // I've coded this form as if it had a lot of fields, but it only has one.
  // For a more complete example, check the product_form.dart file.
  final _cepController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  final _validators = {
    "cep": (String? value) {
      if (value == null || value == "") {
        return "Cannot be empty.";
      }
    },
  };

  Function()? _submitCallback;

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: () => setState(() {
        _submitCallback = _calculateButtonCallback();
      }),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: "CEP",
            ),
            controller: _cepController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _validators["cep"],
            onFieldSubmitted: (str) {
              // When submitted, call the same handler as the button.
              _submitCallback?.call();
            },
          ),
          TextButton(
            onPressed: _submitCallback,
            child: const Text("Search"),
          ),
        ],
      ),
    );
  }

  Function()? _calculateButtonCallback() {
    final validationErrors = [
      _validators["cep"]!(_cepController.text),
    ];

    if (validationErrors.any((element) => element != null)) {
      return null;
    }

    return _buttonCallbackWhenEnabled;
  }

  void _buttonCallbackWhenEnabled() {
    widget.onSubmit(_cepController.text);
  }
}

String addressLookupLabel(AddressLookupState state) {
  switch (state.runtimeType) {
    case AddressLookupStateEmpty:
      return "";
    case AddressLookupStateLoading:
      if ((state as AddressLookupStateLoading).previousResult != null) {
        return "Loading new result...\n${state.previousResult}";
      } else {
        return "Loading...";
      }
    case AddressLookupStateError:
      return "Error: ${(state as AddressLookupStateError).error.errorMessage()}";
    case AddressLookupStateSuccess:
      return (state as AddressLookupStateSuccess).result.toString();
    default:
      return "";
  }
}
