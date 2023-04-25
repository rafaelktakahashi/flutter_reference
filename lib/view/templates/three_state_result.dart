import 'package:flutter/widgets.dart';

/// Page that receives three child widgets, and renders one of them depending
/// on the current state (loading, error or success).
///
/// Typically, this template will be used to display the progress of a request.
/// You can and should nest templates whenever necessary, because this one
/// doesn't do anything more complicated than choose one of three widgets.
///
/// This is meant to demonstrate how templates can abstract behavior to make
/// code more readable.
class ThreeStateResultTemplate extends StatelessWidget {
  final Widget whenLoading;
  final Widget whenSuccess;
  final Widget whenError;

  /// If 0, this template will render the loading widget.
  /// If more than 0, this template will render the success widget.
  /// If less than 0, this template will render the error widget.
  ///
  /// You may want to implement this with an enum in a real project, but here
  /// an integer is sufficient.
  final int state;

  const ThreeStateResultTemplate({
    super.key,
    required this.whenLoading,
    required this.whenSuccess,
    required this.whenError,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state == 0) {
      return whenLoading;
    } else if (state > 0) {
      return whenSuccess;
    } else {
      return whenError;
    }
  }
}
