import 'package:flutter/widgets.dart';
import 'package:flutter_reference/view/templates/simple_template.dart';

/// Typically I don't add "Demo" in the name of this app's pages because the
/// whole app is made of demos, but in this case I thought it would be clearer
/// to specify that this is only a demonstration of how a login bloc can work,
/// and not a real login that affects other parts of the app.
///
/// This page doesn't demonstrate redirects. Login redirection in the widget
/// tree is useful, but this demo focuses instead on sharing information between
/// blocs. By showing all information at once, this page attemps to clearly
/// demonstrate how blocs can communicate with each other to share information
/// that is relevant app-wide.
///
/// Although this page uses a login bloc as its example, the logic demonstrated
/// here can be applied to any cases where inter-bloc communication is needed.
class LoginDemoPage extends StatelessWidget {
  const LoginDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleTemplate(
      title: "Login/logout demo",
      child: Text("TODO"),
    );
  }
}
