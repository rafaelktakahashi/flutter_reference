import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/buyer/buyer_bloc.dart';
import 'package:flutter_reference/business/buyer/buyer_state.dart';
import 'package:flutter_reference/view/UI/organisms/buyer/buyer_details_card.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

/// Page for showing the details of a buyer.
///
/// This page is similar to the product details page. See that one for a few
/// comments.
class BuyerDetailsPage extends StatelessWidget {
  final String buyerId;

  const BuyerDetailsPage({super.key, required this.buyerId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerBloc, BuyerState>(
      builder: (context, state) {
        final BuyerDetailsState buyerDetailsState =
            _selectBuyerDetails(state, buyerId);

        return SimpleTemplate(
          title: _selectBuyerName(state, buyerId) ?? "Buyer's details",
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: switch (buyerDetailsState) {
              BuyerDetailsStateSuccess(data: var data) => BuyerDetailsCard(
                  buyer: data,
                ),
              BuyerDetailsStateLoading() => const BuyerDetailsCard(
                  buyer: null,
                ),
              BuyerDetailsStateError(error: var e) => Text(e.errorMessage()),
              (_) => const Text("An unknown error occurred."),
            },
          ),
        );
      },
    );
  }
}

// Gets a buyer's name, even before its details have been loaded. This is done
// by looking for the buyer in the list. The list doesn't have details, but has
// the buyer's full name.
String? _selectBuyerName(BuyerState state, String buyerId) {
  if (state is BuyerStateSuccess) {
    final buyer = state.buyers
        .firstWhereOrNull((element) => element.identification == buyerId);

    if (buyer != null) {
      return buyer.fullName;
    }
  }

  return null;
}

BuyerDetailsState _selectBuyerDetails(BuyerState state, String buyerId) {
  // The state contains a list of buyers, but we're not interested in it; we
  // want the map of buyer details. Both are only available when the bloc is in
  // the success state.
  if (state is BuyerStateSuccess) {
    // The map of details maps ids to buyer details. The details may be null, or
    // may be in an error, success or loading state.
    final buyerDetailsState = state.details[buyerId];
    return buyerDetailsState ?? const BuyerDetailsStateLoading();
  } else {
    // Unexpected. Don't show this page when the parent state isn't a success.
    return const BuyerDetailsStateLoading();
  }
}
