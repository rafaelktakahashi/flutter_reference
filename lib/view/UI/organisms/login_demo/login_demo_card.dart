import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/business/login_demo/login_bloc.dart';
import 'package:flutter_reference/domain/entity/user.dart';

/// Card that allows interaction with the login bloc, for the page that demoes
/// interbloc communication.
///
/// This isn't a good example of atomic design because I wrote it in a hurry.
class LoginDemoCard extends StatelessWidget {
  const LoginDemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Card(
        color: Colors.orange[200],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  "Login bloc",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Text(
                _extractStateContent(state),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15), // spacer
            Wrap(
              spacing: 15,
              children: [
                FilledButton(
                  onPressed: _logIn(context, state),
                  child: const Text("Log In"),
                ),
                FilledButton(
                  onPressed: _superLogIn(context, state),
                  child: const Text("Log In (admin)"),
                ),
                FilledButton(
                  onPressed: _newUserLogin(context, state),
                  child: const Text("Log In (first access)"),
                ),
                FilledButton(
                  onPressed: _verifyFirstLogin(context, state),
                  child: const Text("Verify first access"),
                ),
                FilledButton(
                  onPressed: _logOut(context, state),
                  child: const Text("Log Out"),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  String _extractStateContent(LoginState state) {
    if (state is LoginStateLoggedOut) {
      return "Not logged in.";
    }
    if (state is LoginStateFailure) {
      return "Error: ${state.error.errorMessage()}";
    }
    if (state is LoginStateFirstAccess) {
      return "User: ${state.user}\nFirst login, must verify.";
    }
    if (state is LoginStateLoading) {
      return "Loading...";
    }
    if (state is LoginStateLoggedIn) {
      var message = "";
      if (state.user.userRole == UserRole.admin) {
        message = "Logged in as admin.\n\n";
      } else {
        message = "Logged in.\n\n";
      }
      message = "$message${state.user}";
      return message;
    }

    return "Unexpected state.";
  }

  // The button handlers are functions or null, and when they're null, the
  // button is disabled. These functions below make the handler; that is, they
  // return a function or null.

  void Function()? _logIn(BuildContext context, LoginState state) {
    if (state is LoginStateLoggedOut || state is LoginStateFailure) {
      return () {
        BlocProvider.of<LoginBloc>(context).add(
          const LoginWithPasswordEvent("joe@mail.com", "any"),
        );
      };
    }
    return null;
  }

  void Function()? _superLogIn(BuildContext context, LoginState state) {
    if (state is LoginStateLoggedOut || state is LoginStateFailure) {
      return () {
        BlocProvider.of<LoginBloc>(context).add(
          const LoginWithPasswordEvent("overlord@mail.com", "any"),
        );
      };
    }
    return null;
  }

  void Function()? _newUserLogin(BuildContext context, LoginState state) {
    if (state is LoginStateLoggedOut || state is LoginStateFailure) {
      return () {
        BlocProvider.of<LoginBloc>(context).add(
          const LoginWithPasswordEvent("rookie@mail.com", "any"),
        );
      };
    }
    return null;
  }

  void Function()? _verifyFirstLogin(BuildContext context, LoginState state) {
    if (state is LoginStateFirstAccess) {
      return () {
        BlocProvider.of<LoginBloc>(context).add(
          const VerifyFirstAccessEvent("any"),
        );
      };
    }
    return null;
  }

  void Function()? _logOut(BuildContext context, LoginState state) {
    if (state is LoginStateLoggedIn) {
      return () {
        BlocProvider.of<LoginBloc>(context).add(
          const LogoutEvent(),
        );
      };
    }
    return null;
  }
}
