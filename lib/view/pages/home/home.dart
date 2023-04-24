import 'package:flutter/material.dart';
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
