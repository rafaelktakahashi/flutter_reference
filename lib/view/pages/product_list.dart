import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/product/product_list_bloc.dart';

// TODO: Refactor this page to follow the principles of atomic design.

// TODO: Add a form to the list.

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, ProductState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Mega-Store Product List"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _chooseList(context, state),
              TextButton(
                onPressed: () => context.read<ProductListBloc>().add(
                      const FetchProductsEvent(),
                    ),
                child: const Text("Fetch"),
              ),
            ],
          ),
        );
      },
    );
  }

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

  // Normally, the list itself should be
  Widget _renderList(BuildContext context, ProductStateList state) {
    return ListView(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      children: state.products
          .map(
            (e) => Container(
              height: 50,
              color: Theme.of(context).colorScheme.surface,
              child:
                  Center(child: Text("${e.name}, ${e.stockAmount} ${e.unit}")),
            ),
          )
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
