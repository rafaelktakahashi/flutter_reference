import 'package:flutter/material.dart';

class DemoCard extends StatelessWidget {
  const DemoCard({
    super.key,
    required this.title,
    required this.content,
    this.subContent,
    required this.secondary,
  });
  final String title;
  final String content;
  final String? subContent;
  final String secondary;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade100,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity, // Always use up all available x-space
          maxWidth: double.infinity,
          minHeight: 100, // Be no shorter than this
          maxHeight: 140, // Be no taller than this
          // (Height may need to increase when font is large)
          // (Height will maximimize if any children expand; don't do that)
          // (Minimum height of 100 means that this box's child will be at least
          // 100px tall, even if it wants to be smaller)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _buildCardContent(
            context,
            title,
            content,
            subContent,
            secondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(
    BuildContext context,
    String title,
    String content,
    String? subContent,
    String secondary,
  ) {
    final column = Column(
      // The minimum vertical size is to not automatically expand the card to
      // its maximum height. The card's height will only increase when this
      // column is forced to expand (for example, due to large font size), and
      // even then, it'll stop when it reaches the card's maximum height.
      mainAxisSize: MainAxisSize.min,
      // Top-align; the box that is parent to this column enforces minimum and
      // maximum heights, so the size of the content may not line up with its
      // container. Default to leaving empty space at the bottom.
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Fixed amount of children, only two:
        // First (top) is the header, second (bottom) is a row.
        // Second child will get all remaining space is some is left.
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 0, // Don't enforce width, only height
            maxWidth: double.infinity,
            minHeight: 80, // Be at least this tall
            maxHeight: double.infinity, // Max out to the paren't constraints
            // Contents may exceed minimum height when font is large.
            // This helps the row's alignment to be consistent from one card to
            // the next, otherwise the row could shrink when it doesn't nee to
            // use two lines for the content.
          ),
          child: _buildRow(context, content, subContent, secondary),
        ),
      ],
    );

    // The wrap helps with not causing errors when the content needs to overflow
    // despite the constraints, which can happen if the user's configured font
    // size is extremely large.
    // In this example app, this can also happen when the title is too long
    // because there isn't a limit to the amount of lines in the title, for
    // demonstration purposes.
    return Wrap(
      clipBehavior: Clip.hardEdge,
      children: [column],
    );
  }

  // Don't pay too much attention to this style. Use your own solution.
  TextStyle _contentStyle({Color? useColor}) {
    return TextStyle(
      // The background color is just for easily seeing where the text is.
      // backgroundColor: Colors.green.withAlpha(0x80),
      color: useColor, // foreground color, optionally
      fontSize: 18,
      fontWeight: FontWeight.w600, // Semi-bold if available
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildRow(
    BuildContext context,
    String content,
    String? subContent,
    String secondary,
  ) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints parentConstraints) {
        // There's a main content and a secondary content to the right.
        // We want the main content to always occupy at least 60% of the
        // available width, but it may occupy more if its text is long. We will
        // limit it to occupying at most 80% of available width, otherwise it
        // could squeeze the secondary content too much.
        // This means the content has a minimum width of 60% and a maximum width
        // of 80%. We calculate what those percentages are in px and give them
        // to the main content as a constrained box.
        // Lastly, the secondary content is wrapped in an Expanded so that its
        // size is calculated last.
        final double minimumContentWidth =
            parentConstraints.biggest.width * 0.6;
        final double maximumContentWidth =
            parentConstraints.biggest.width * 0.8;
        // You should choose these percentages depending on what needs to render
        // and make sure that neither the main content or the subcontent are too
        // restricted.
        // For example, if we chose 0.95 as the maximum content width, then the
        // subcontent could possibly be left with a very very small width to
        // render. 0.8 means the subcontent always has about 20% of the
        // remaining space, even when the content wants to expand more.

        return Row(
          // Cross-axis for a row is top-bottom; align contents in the middle.
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // This row has a fixed, constant amount of children.
            // First (left) is the content and subcontent, second (right) is the
            // secondary text.
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 0, // indifferent to height
                maxHeight: double.infinity,
                minWidth: minimumContentWidth,
                maxWidth: maximumContentWidth,
              ),
              child: _buildContent(context, content, subContent),
            ),
            const SizedBox(width: 5), // Horizontal spacer, constant width
            Expanded(
              child: Text(
                secondary,
                maxLines: 2,
                style: _contentStyle(useColor: Colors.indigo.shade700),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    String content,
    String? subContent,
  ) {
    if (subContent == null || subContent.trim().isEmpty) {
      // This branch is for when there's no subcontent.
      // If a string was passed as subcontent but it's empty or only contains
      // whitespaces, then we consider that there is no subcontent.

      // We allow the content to occupy at most two lines, using an ellipsis if
      // the text overflows.
      return Text(content, maxLines: 2, style: _contentStyle());
    } else {
      // This branch is for when there's subcontent.

      // We only let the content and the subcontent render in one line, using an
      // ellipsis if the text overflows.
      return Column(
        // Left-align
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content, maxLines: 1, style: _contentStyle()),
          Text(
            subContent,
            maxLines: 1,
            style: _contentStyle(useColor: Colors.black45),
          ),
        ],
      );
    }
  }
}
