import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';
import 'package:flutter_reference/view/UI/molecules/product_entry.dart';

/// List that is specifically for products.
///
/// This list knows how to render with items or with placeholders, and also
/// displays a button for adding a new product.
///
/// This component uses an `onOpenDetails` callback because organisms aren't
/// supposed to know what page they're in. In fact, an organism could
/// theoretically exist in any page.
class ProductList extends StatelessWidget {
  final Function(String id)? onOpenDetails;

  // Organisms can use blocs to perform tasks. They're self-contained pieces
  // of the app. In this case, this is a list of products that knows how to
  // render items from the bloc.
  //
  // Note that an organism doesn't have any obligation to do _everything_
  // related to a feature; for example, "adding a new product" can be in a
  // separate button somewhere else in the page, outside of this organism.
  const ProductList({super.key, this.onOpenDetails});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, ProductState>(
        builder: (context, state) {
      // In a real project, you should probably organize this as a container and
      // not just a column; this example is pretty simple.
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "Touch an item to open details. Use the floating button down below to add a new item.",
            ),
          ),
          _chooseList(context, state),
          TextButton(
            onPressed: () => context.read<ProductListBloc>().add(
                  const FetchProductsEvent(),
                ),
            child: const Text("Refetch"),
          ),
        ],
      );
    });
  }

  // The following functions are the organism's internal logic. That's allowed.

  Widget _chooseList(BuildContext context, ProductState state) {
    if (state is ProductStateEmpty) {
      return _renderEmpty(context);
    } else if (state is ProductStateError) {
      return _renderError(context, state);
    } else if (state is ProductStateLoading) {
      return _renderLoadingList(context);
    } else if (state is ProductStateList) {
      return _renderList(context, state);
    } else {
      return const Text("Unexpected type of ProductState!");
    }
  }

  // Normally, the list itself should be a molecule. I'm skipping that step
  // because it's very simple.
  Widget _renderList(BuildContext context, ProductStateList state) {
    return ListView(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      // For each product in the state, make a product entry.
      children: state.products
          .map((e) => ProductEntry(
                product: e,
                onPressed: (product) {
                  onOpenDetails?.call(product.id);
                },
              ))
          .toList(),
    );
  }

  Widget _renderLoadingList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      children: <Widget>[
        Container(
          height: 50,
          color: Theme.of(context).colorScheme.surface,
          child: const Center(child: Text('Loading...')),
        ),
      ],
    );
  }

  Widget _renderError(BuildContext context, ProductStateError state) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          color: Theme.of(context).colorScheme.surface,
          child: Text(state.error.errorMessage(),
              style: TextStyle(color: Theme.of(context).colorScheme.onError)),
        ),
      ],
    );
  }

  Widget _renderEmpty(BuildContext context) {
    return Container();
  }
}
