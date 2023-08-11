import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/organisms/address_lookup/address_lookup_form.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

class AddressLookupPage extends StatelessWidget {
  const AddressLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleTemplate(
      title: "CEP Lookup",
      child: Center(
        child: AddressLookup(),
      ),
    );
  }
}
