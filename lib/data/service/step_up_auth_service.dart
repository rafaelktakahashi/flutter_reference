import 'package:flutter_reference/data/infra/interop_service.dart';
import 'package:flutter_reference/data/service/ui_modal_service.dart';
import 'package:flutter_reference/domain/error/playground_bridge_error.dart';
import 'package:flutter_reference/domain/error/playground_client_error.dart';
import 'package:flutter_reference/view/pages/step_up/step_up_modal.dart';
import 'package:get_it/get_it.dart';

class StepUpAuthService extends InteropService {
  StepUpAuthService() : super("step-up") {
    // This method expects a String and returns either String (in case of
    // success) or null (in case of failure). The String in case of success is
    // the step-up authentication token.
    exposeMethod("showStepUpPrompt", (sessionId) async {
      if (sessionId is String) {
        final result = await displayStepUpRequest(sessionId);
        switch (result) {
          case StepUpSuccess(
              authenticationToken: final authToken,
              stepUpSessionId: _
            ):
            return authToken;
          case StepUpFailure(reason: StepUpFailureReason.userDismissed):
          case StepUpFailure(reason: StepUpFailureReason.ranOutOfAttempts):
            return null;
          case StepUpFailure(reason: StepUpFailureReason.unknown):
            throw const PlaygroundClientError(
              "SUP1030",
              "Step up failed with unknown reason.",
              responseStatus: "403",
            );
          case _:
            throw const PlaygroundBridgeError(
              "SUP0121",
              "Unknown error in showStepUpPrompt handler.",
            );
        }
      } else {
        throw const PlaygroundBridgeError(
          "SUP0120",
          "Wrong type received by StepUpAuthService.showStepUpPrompt (expected String).",
        );
      }
    });
  }

  /// Display the step-up request as a Flutter dialog.
  ///
  /// This relies on the Flutter View/Activity being topmost in the stack.
  ///
  /// Note: The session id is received as a parameter and also returned in the
  /// response only as a convenience for the native side; no decisions are made
  /// with it.
  Future<StepUpResult> displayStepUpRequest(String sessionId) async {
    final result = await GetIt.I.get<UiModalService>().showModalPage(
          (_) => StepUpModalPage(sessionId: sessionId),
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
