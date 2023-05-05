import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/buyer/buyer_bloc.dart';
import 'package:flutter_reference/business/buyer/buyer_state.dart';
import 'package:flutter_reference/view/UI/molecules/buyer_entry.dart';

// Adjacent strings are combined. This is an alternative to using multiline
// strings (multiline strings start and end with three quotes).
const message = "Touch an item to open details."
    "\n"
    "Details require an additional request."
    " "
    "Redundant requests are skipped (when the data is already in the bloc).";

/// List that is specifically for buyers.
///
/// This list knows how to render the items, and only has an event for when the
/// user presses on an item. The page should provide the handler.
class BuyerList extends StatelessWidget {
  final Function(String id)? onOpenDetails;

  const BuyerList({super.key, this.onOpenDetails});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerBloc, BuyerState>(builder: (context, state) {
      // Most of this was copied from the product_list.dart file.
      // If you find that you have many organisms that are the same kind of
      // list, it may be worth considering creating a generic list widget. Keep
      // in mind that doing that would make the code harder to maintain because
      // changes would be reflected everywhere. Depending on the app's
      // requirements, it may make more sense to keep organisms separate even if
      // they're similar, because that lets you change their code independently
      // more easily.
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(5),
            child: Text(message),
          ),
          _chooseList(context, state),
        ],
      );
    });
  }

  Widget _chooseList(BuildContext context, BuyerState state) {
    if (state is BuyerStateIdle) {
      return _renderEmpty(context);
    } else if (state is BuyerStateError) {
      return _renderError(context, state);
    } else if (state is BuyerStateLoading) {
      return _renderLoadingList(context);
    } else if (state is BuyerStateSuccess) {
      return _renderList(context, state);
    } else {
      return const Text("Unexpected type of BuyerState!");
    }
  }

  Widget _renderList(BuildContext context, BuyerStateSuccess state) {
    return ListView(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      // For each buyer in the list, make an entry.
      children: state.buyers
          .map((e) => BuyerEntry(
                buyer: e,
                onPressed: () => onOpenDetails?.call(e.identification),
              ))
          .toList(),
    );
  }

  Widget _renderLoadingList(BuildContext context) {
    // In practice, you may prefer to render a list with animated placeholders,
    // but that's more work, of course. You'd need a molecule that knows how
    // to render itself as a placeholder without data.
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

  Widget _renderError(BuildContext context, BuyerStateError state) {
    // You don't need to render the error inside the list. Typically you'd want
    // a modal or a redirect. You'd use a bloc listener for that.
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          color: Theme.of(context).colorScheme.surface,
          child: Text(
            state.error.errorMessage(),
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
        ),
      ],
    );
  }

  Widget _renderEmpty(BuildContext context) {
    return Container();
  }
}
