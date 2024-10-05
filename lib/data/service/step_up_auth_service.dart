import 'package:flutter_reference/data/infra/interop_service.dart';
import 'package:flutter_reference/data/service/ui_modal_service.dart';
import 'package:flutter_reference/domain/error/playground_bridge_error.dart';
import 'package:flutter_reference/domain/error/playground_client_error.dart';
import 'package:flutter_reference/view/pages/step_up/step_up_modal.dart';
import 'package:flutter_reference_step_up_auth/flutter_reference_step_up_auth.dart';
import 'package:get_it/get_it.dart';

class StepUpAuthService extends InteropService {
  StepUpAuthService() : super("step-up") {
    // This method expects a String and returns either String (in case of
    // success) or null (in case of failure). The String in case of success is
    // the step-up authentication token. Errors are returned in the form of
    // thrown exceptions.
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
          case StepUpFailure(reason: StepUpFailureReason.networkError):
            throw const PlaygroundClientError(
              "SUP1030",
              "Step up failed with a network error.",
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
    final result = await GetIt.I
        .get<UiModalService>()
        .showModalPage<StepUpModalPageResult>(
          (_) => StepUpModalPage(sessionId: sessionId),
        );

    return result.fold(
      (l) => switch (l) {
        // A Left means the UiModalService failed because the user dismissed
        // the modal. It does not mean that the modal itself encountered a
        // problem.
        UiModalServiceFailureReason.userDismissed => const StepUpFailure(
            reason: StepUpFailureReason.userDismissed,
          ),
        _ => const StepUpFailure(reason: StepUpFailureReason.userDismissed),
      },
      (r) => switch (r) {
        StepUpModalPageResultSuccess(token: var authToken) => StepUpSuccess(
            authenticationToken: authToken,
            stepUpSessionId: sessionId,
          ),
        StepUpModalPageResultFailure(reason: var pageFailureReason) =>
          StepUpFailure(
            reason: switch (pageFailureReason) {
              StepUpPromptFailureReason.networkError =>
                StepUpFailureReason.networkError,
              StepUpPromptFailureReason.authServerConfigurationError =>
                StepUpFailureReason.serverAuthError,
              _ => StepUpFailureReason.unknown,
            },
          ),
      },
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
  networkError,
  serverAuthError,
  unknown,
}
