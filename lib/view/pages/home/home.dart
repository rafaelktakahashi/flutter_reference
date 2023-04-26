import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SimpleTemplate(
      title: "Flutter reference architecture",
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Center(
                child: TextButton(
              onPressed: () {
                // You could also fetch data here, but in our case we're doing
                // that in the router's builder.
                // Loading data in the bloc _before_ navigation is a common
                // practice, but putting it in the router's builder ensures that
                // you won't forget to load data, no matter where the page is
                // being called from.
                // In any case, these options are better than loading data in
                // the page itself. It simplifies initialization logic and lets
                // the pages be stateless widgets that don't do anything special
                // the first time they appear.
                context.push("/products");
              },
              child: const Text("Simple list"),
            )),
          ),
          SizedBox(
            height: 50,
            child: Center(
                child: TextButton(
              onPressed: () {
                context.push("/interop");
              },
              child: const Text("Interop bloc"),
            )),
          ),
          SizedBox(
            height: 50,
            child: Center(
                child: TextButton(
              onPressed: () {
                context.push("/life");
              },
              child: const Text("Conway's game of life"),
            )),
          ),
        ],
      ),
    );
  }
}
