import 'package:flutter/material.dart';
import 'package:flutter_reference/view/UI/molecules/text_over_color.dart';
import 'package:flutter_reference/view/templates/modal_template.dart';

class StepUpModalPage extends StatelessWidget {
  const StepUpModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModalTemplate(
      title: "Authentication",
      child: TextOverColor(
        largeText: "Step-up Authentication",
        smallText:
            "This modal page is being shown because the request you attempted requires additional verification."
            "\n"
            "Please press the big button to confirm your identity."
            "\n\n"
            "(In a real app, you'd receive an alphanumeric code to input here.)",
        backgroundColor: Colors.blue[300],
        extra: ElevatedButton(
          onPressed: () {
            // This page pops with the step-up authentication token that we're
            // pretending came from the backend auth service. In this demo app,
            // this is a fixed string that our mocked service is hardcoded to
            // accept.
            Navigator.of(context).pop("諸行無常 諸行是苦 諸法無我");
            // If the user pops the page in other ways (by dismissing the page),
            // then no value is passed back through the pop.
          },
          child: const Text("CONFIRM"),
        ),
      ),
    );
  }
}
