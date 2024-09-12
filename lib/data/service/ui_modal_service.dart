import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reference/view/nav/router.dart';

/// A service that shows a modal page on top of the UI using a cached navigator.
/// Uniquely, this lets a class from the data layer affect the UI. This is not
/// encouraged.
class UiModalService {
  Future<Either<UiModalServiceFailureReason, T>> showModalPage<T>(
    Widget Function(BuildContext) pageBuilder,
  ) async {
    final cachedContext = router.routerDelegate.navigatorKey.currentContext;

    if (cachedContext == null) {
      debugPrint(
        "Trying to navigate in Flutter without a context! This will not work!",
      );
      return const Left(UiModalServiceFailureReason.missingNavigator);
    }

    final result = await Navigator.of(cachedContext).push(
      MaterialPageRoute(
        builder: pageBuilder,
        fullscreenDialog: true,
        barrierDismissible: true,
      ),
    );

    if (result == null) {
      return const Left(UiModalServiceFailureReason.userDismissed);
    }

    if (result is T) {
      return Right(result);
    } else {
      return const Left(UiModalServiceFailureReason.typeMismatch);
    }
  }
}

enum UiModalServiceFailureReason {
  userDismissed,
  missingNavigator,
  typeMismatch
}
