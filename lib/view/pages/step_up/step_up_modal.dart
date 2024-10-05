import 'package:flutter/material.dart';
import 'package:flutter_reference/view/templates/modal_template.dart';
import 'package:flutter_reference_step_up_auth/flutter_reference_step_up_auth.dart';

/// Modal that simply shows a widget from another library for obtaining a
/// certain token for retrying a failed request.
/// When requests fail due to a step-up authentication being required, the app
/// shows this widget in order to obtain the token to be included in the
/// retry request's header.
///
/// Attention to the return type of the navigation; the pop will return
/// an instance of StepUpModalPageResult: either a StepUpModalPageResultSuccess
/// or a StepUpModalPageResultFailure.
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
          Navigator.of(context).pop(StepUpModalPageResultSuccess(token));
        },
        onFailure: (cause) {
          // The cause tells us the reason for failure.
          Navigator.of(context).pop(StepUpModalPageResultFailure(cause));
        },
      ),
    );
  }
}

sealed class StepUpModalPageResult {
  const StepUpModalPageResult();
}

class StepUpModalPageResultSuccess extends StepUpModalPageResult {
  const StepUpModalPageResultSuccess(this.token);
  final String token;
}

class StepUpModalPageResultFailure extends StepUpModalPageResult {
  const StepUpModalPageResultFailure(this.reason);
  final StepUpPromptFailureReason reason;
}
