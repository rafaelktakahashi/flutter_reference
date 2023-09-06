import 'package:flutter/widgets.dart';
import 'package:flutter_reference/view/UI/molecules/demo_card.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

class _CardInfo {
  final String header;
  final String textCenterOne;
  final String? textCenterTwo;
  final String textRight;

  const _CardInfo(
    this.header,
    this.textCenterOne,
    this.textCenterTwo,
    this.textRight,
  );
}

const List<_CardInfo> _cardInfo = [
  _CardInfo("Title", "Main content", "Subcontent", "Secondary content"),
  _CardInfo("Title", "Call these whatever you want", "etc", "Secondary"),

  // When there's no subcontent, it does not render.
  _CardInfo("The Title doesn't matter", "No subcontent", null, "Secondary"),

  // In the real world, you should limit the title to one line only. This is
  // simulating what would happen if the user's font was very very large. The
  // remaining content would overflow, but wouldn't fail catastrophically
  // because there's a Wrap around the card's content that fails silently when
  // the content's height exceeds its parent.
  _CardInfo(
      "This title is longer than it should be but doesn't cause errors thanks to a Wrap around the content's column",
      "Top center",
      "             ",
      "Secondary"),

  // Main content by itself can use two lines.
  _CardInfo("Title", "Consider always limiting text by amount of lines", "   ",
      "`>.<´"),

  _CardInfo("Title", "maxLines is 2 here :)", " ", "maxLines is 2 here :)"),

  _CardInfo("maxLines is not set here", "maxLines is 1", "maxLines is 1",
      "maxLines is 2 here :)"),

  // Text will use ellipsis (...) when it doesn't fit.
  _CardInfo("Title", "Very very long content text that will probably overflow",
      "Bottom center", "Long secondary content"),

  // Not using a subcontent means there's more space for the main content.
  _CardInfo(
      "Title",
      "Card with one content that's long and will probably wrap and overflow too",
      null,
      "Long secondary content"),

  // If both the content and the secondary content want more space, the main
  // content has priority. Secondary content gets what's left.
  _CardInfo("Title", "Content has priority, so subcontent may shrink", "   ",
      "Long secondary content"),

  // The secondary content to the right cannot take space from the main content.
  // Only the main content can take space from the secondary content.
  // The main content's constraints are calculated at runtime, and the secondary
  // content gets the remaining space.
  _CardInfo("Title", ":)", ":)", "This can't expand much"),

  _CardInfo("Title", "Try setting font size to maximum, it should not break",
      "", "`>.<´"),

  _CardInfo("Title", "Flutter has emoji 😙", "  ", "`>.<´"),
];

class CardsDemoPage extends StatelessWidget {
  const CardsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTemplate(
      title: "Text in Card demo",
      child: ListView.separated(
        separatorBuilder: (_, __) => _spacer(),
        padding: const EdgeInsets.all(15),
        itemCount: _cardInfo.length,
        itemBuilder: (context, i) => DemoCard(
          title: _cardInfo[i].header,
          content: _cardInfo[i].textCenterOne,
          subContent: _cardInfo[i].textCenterTwo,
          secondary: _cardInfo[i].textRight,
        ),
        shrinkWrap: true,
      ),
    );
  }

  Widget _spacer() {
    return SizedBox.fromSize(
      size: const Size.square(10),
    );
  }
}
