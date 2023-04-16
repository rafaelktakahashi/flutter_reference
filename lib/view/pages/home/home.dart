import 'package:flutter/material.dart';
import 'package:flutter_reference/view/pages/counter/counter.dart';
import 'package:flutter_reference/view/pages/life/life.dart';
import 'package:flutter_reference/view/pages/product/product_list.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProductListPage(),
                  ),
                );
              },
              child: const Text("Simple list"),
            )),
          ),
          SizedBox(
            height: 50,
            child: Center(
                child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CounterPage(),
                  ),
                );
              },
              child: const Text("Interop bloc"),
            )),
          ),
          SizedBox(
            height: 50,
            child: Center(
                child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LifePage(),
                  ),
                );
              },
              child: const Text("Conway's game of life"),
            )),
          ),
        ],
      ),
    );
  }
}
