import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/product/product_form_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/view/UI/molecules/icon_with_label.dart';
import 'package:flutter_reference/view/templates/fullscreen_message.dart';
import 'package:flutter_reference/view/templates/three_state_result.dart';
import 'package:go_router/go_router.dart';

/// Shows a loading screen while the new product is being saved, and then
/// switches to a success page or an error page.
class ProductResultPage extends StatelessWidget {
  const ProductResultPage({super.key});

  Widget _withListener(Widget child) {
    // This is an example of using a listener in a bloc to cause a change in
    // another bloc.
    //
    // In this example, the product form bloc adds a new product, but it doesn't
    // know how to tell the product list bloc that it should update its list.
    // So we use a listener here to trigger a fetch.
    // This is better than making one bloc add events in another. Doing so would
    // add coupling and make them harder to test.
    return BlocListener<ProductFormBloc, ProductFormState>(
      listener: (context, state) {
        // When the new state is a success, it means that a new product exists and
        // now the list in the product list bloc needs to be updated.
        // This happens when the list of products isn't even on screen (because
        // it's in another page), but that doesn't matter. Any page can use any
        // bloc.
        if (state is ProductFormStateSuccess) {
          context.read<ProductListBloc>().add(const FetchProductsEvent());
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Here I'm using a Template that renders one of three possible bodies.
    // This is one of many examples in this project where the solution doesn't
    // look very efficient, but that's simply because the examples are simple.
    //
    // This is meant to illustrate one way that templates can have layout logic.
    // In this case, the "layout logic" isn't just the location of widgets in
    // the page, but also logic for deciding which widgets to show.
    //
    // Also, remember that templates are for common logic. If there's logic
    // that only happens once in the entire app, then it might not be worth the
    // effort to put that in a template. Always observe the common layout
    // elements in your pages and extract them into templates.
    //
    // In this example, a "ThreeStateResultTemplate" would make sense for you
    // if you want to have many pages that switch between three possible states.
    return _withListener(
      BlocBuilder<ProductFormBloc, ProductFormState>(
        builder: (context, state) {
          return ThreeStateResultTemplate(
            whenLoading: const FullscreenMessageTemplate(
              centerWidget: IconWithLabel(
                icon: Icon(Icons.hourglass_bottom, color: Color(0xff919191)),
                text: "Submitting...",
              ),
              backgroundColor: Color(0xfffffea6),
            ),
            whenError: FullscreenMessageTemplate(
              centerWidget: const IconWithLabel(
                icon: Icon(Icons.error, color: Color(0xffdb0000)),
                text: "Something went wrong",
              ),
              backgroundColor: const Color(0xffff8a8a),
              actionButton: ElevatedButton(
                onPressed: () {
                  context.go('/products');
                },
                child: const Text("Back", style: TextStyle(fontSize: 20)),
              ),
            ),
            whenSuccess: FullscreenMessageTemplate(
              centerWidget: const IconWithLabel(
                icon: Icon(Icons.check_circle, color: Color(0xff21a600)),
                text: "Produced added!",
              ),
              backgroundColor: const Color(0xffa9ebaf),
              actionButton: ElevatedButton(
                onPressed: () {
                  context.go('/products');
                },
                child: const Text("Back", style: TextStyle(fontSize: 20)),
              ),
            ),
            state: state is ProductFormStateError
                ? -1
                : state is ProductFormStateSuccess
                    ? 1
                    : 0,
          );
        },
      ),
    );
  }
}
