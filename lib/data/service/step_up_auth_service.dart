import 'package:flutter_reference/data/infra/interop_service.dart';
import 'package:flutter_reference/data/service/ui_modal_service.dart';
import 'package:flutter_reference/view/pages/step_up/step_up_modal.dart';
import 'package:get_it/get_it.dart';

class StepUpAuthService extends InteropService {
  StepUpAuthService() : super("step-up");

  /// Display the step-up request as a Flutter dialog.
  ///
  /// This relies on the Flutter View/Activity being topmost in the stack.
  ///
  /// Note: The session id is received as a parameter and also returned in the
  /// response only as a convenience for the native side; no decisions are made
  /// with it.
  Future<StepUpResult> displayStepUpRequest(String sessionId) async {
    final result = await GetIt.I.get<UiModalService>().showModalPage(
          (_) => const StepUpModalPage(),
        );

    return result.fold(
      (l) => switch (l) {
        UiModalServiceFailureReason.userDismissed => const StepUpFailure(
            reason: StepUpFailureReason.userDismissed,
          ),
        _ => const StepUpFailure(reason: StepUpFailureReason.unknown),
      },
      (r) => StepUpSuccess(authenticationToken: r, stepUpSessionId: sessionId),
    );
  }
}

abstract class StepUpResult {
  const StepUpResult();
}

class StepUpSuccess extends StepUpResult {
  /// Token that's valid only for the request that triggered the step-up request.
  final String authenticationToken;

  /// Session id for which the token is valid once.
  final String stepUpSessionId;

  const StepUpSuccess({
    required this.authenticationToken,
    required this.stepUpSessionId,
  });
}

class StepUpFailure extends StepUpResult {
  final StepUpFailureReason reason;

  const StepUpFailure({
    required this.reason,
  });
}

enum StepUpFailureReason {
  userDismissed,
  ranOutOfAttempts,
  unknown,
}
