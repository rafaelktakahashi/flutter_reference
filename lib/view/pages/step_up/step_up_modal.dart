import 'package:flutter/material.dart';
import 'package:flutter_reference/view/templates/modal_template.dart';
import 'package:flutter_reference_step_up_auth/flutter_reference_step_up_auth.dart';

/// Modal that simply shows a widget from another library for obtaining a
/// certain token for retrying a failed request.
/// When requests fail due to a step-up authentication being required, the app
/// shows this widget in order to obtain the token to be included in the
/// retry request's header.
class StepUpModalPage extends StatelessWidget {
  final String sessionId;

  const StepUpModalPage({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return ModalTemplate(
      title: "Authentication",
      child: StepUpPrompt(
        sessionId: sessionId,
        onSuccess: (token) {
          Navigator.of(context).pop(token);
        },
        onFailure: () {
          Navigator.of(context).pop(null);
        },
      ),
    );
  }
}
