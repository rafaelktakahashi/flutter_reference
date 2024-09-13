import 'package:flutter/widgets.dart';
import 'package:flutter_reference/view/UI/organisms/buyer/buyer_list.dart';
import 'package:flutter_reference/view/UI/organisms/buyer/buyer_settings.dart';
import 'package:flutter_reference/view/templates/scrollable_template.dart';
import 'package:go_router/go_router.dart';

/// List page that showcases a list whose details need to be fetched
/// individually. That is, when the user touches on an item, they're taken to
/// a separate page where another request occurs to fetch details for the item.
///
/// We keep all that information in a single bloc. One of the advantages is
/// being able to reuse data that has already been fetched. Using a second bloc
/// for the details would require redundant requests when the user opens the
/// same page multiple times.
///
/// See the product list page for a simpler example that does not need a second
/// request. The product list page also has an example for adding a new item
/// with a form.
///
/// Additionally, this page has a toggle for simulating a step-up authentication
/// request. That causes the http client to show a new page requesting a code
/// from the user when you tap an item to see details.
class BuyerListPage extends StatelessWidget {
  const BuyerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollableTemplate(
      title: "Playground Buyer List",
      children: [
        BuyerList(
          onOpenDetails: (id) {
            // Check the product_list_page.dart file for more considerations
            // about this.
            context.push('/buyers/details/$id');
          },
        ),
        const BuyerSettings(),
      ],
    );
  }
}
