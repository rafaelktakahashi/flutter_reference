import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/organisms/product/product_list.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';
import 'package:go_router/go_router.dart';

/// Minimal example of a list page. In a real app, there's a number of clear
/// improvements one could make to this code.
///
/// The template provides no more than a title and a body. Templates can be
/// more complicated, accepting widgets to render in different places, for
/// example floating buttons, footers, sidebars, etc.
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});
  @override
  Widget build(BuildContext context) {
    // In this case, the Product List organism already knows how to connect
    // to the bloc, so we don't need to connect anything.
    return SimpleTemplate(
      title: "Playground Product List",
      child: ProductList(
        onOpenDetails: (id) {
          // Generally you should avoid passing parameters to pages (because
          // doing so adds coupling). "Small" data like an id is typically ok.
          context.push('/products/$id');
        },
      ),
    );
  }
}
