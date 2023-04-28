import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/organisms/product/product_list.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';
import 'package:go_router/go_router.dart';

/// Minimal example of a list page. In a real app, there's a number of clear
/// improvements one could make to this code.
///
/// The template provides no more than a title, a body and a FAB. Templates can
/// be more complicated, accepting widgets to render in different places, for
/// example floating buttons, footers, sidebars, etc. So in this case it would
/// be more useful to use the Scaffold directly, but the main idea is that your
/// templates can be as complicated as you want (for example, automatically
/// creating a header).
///
/// This page uses the simple template where the main body is the list of
/// products. Because the list is an organism that connects to the bloc, we
/// don't need to worry about providing its data here.
///
/// This page doesn't automatically load any data. All initialization logic is
/// in the bloc, and is triggered in the router. Thus, when the user arrives
/// here, the event for fetching data will already have been sent.
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});
  @override
  Widget build(BuildContext context) {
    // In this case, the Product List organism already knows how to connect
    // to the bloc, so we don't need to connect anything.
    return SimpleTemplate(
      title: "Playground Product List",
      floatingButton: FloatingActionButton(
        onPressed: () {
          context.push("/products/new");
        },
        child: const Icon(Icons.add),
      ),
      child: ProductList(
        onOpenDetails: (id) {
          // Generally you should avoid passing parameters to pages (because
          // doing so adds coupling). "Small" data like an id is typically ok.
          context.push('/products/details/$id');
        },
      ),
    );
  }
}
