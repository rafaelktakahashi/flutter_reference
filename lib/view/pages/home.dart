import 'package:flutter/material.dart';
import 'package:flutter_reference/view/pages/counter.dart';
import 'package:flutter_reference/view/pages/product_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter reference architecture")),
      body: Column(
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
        ],
      ),
    );
  }
}
