// EVENTS

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/domain/entity/address.dart';
import 'package:flutter_reference/domain/entity/user.dart';
import 'package:flutter_reference/domain/error/playground_business_error.dart';
import 'package:flutter_reference/domain/error/playground_error.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class LoginWithPasswordEvent extends LoginEvent {
  final String username;
  final String password;
  const LoginWithPasswordEvent(this.username, this.password);
}

class VerifyFirstAccessEvent extends LoginEvent {
  final String code;
  const VerifyFirstAccessEvent(this.code);
}

class LogoutEvent extends LoginEvent {
  const LogoutEvent();
}

// STATE

abstract class LoginState {
  const LoginState();
}

class LoginStateLoggedOut extends LoginState {
  const LoginStateLoggedOut();
}

class LoginStateLoading extends LoginState {
  const LoginStateLoading();
}

class LoginStateFirstAccess extends LoginState {
  final User user;
  const LoginStateFirstAccess(this.user);
}

class LoginStateLoggedIn extends LoginState {
  final User user;
  const LoginStateLoggedIn(this.user);
}

class LoginStateFailure extends LoginState {
  final PlaygroundError error;
  const LoginStateFailure(this.error);
}

// BLOC

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginStateLoggedOut()) {
    // Register event handlers
    super.on<LoginWithPasswordEvent>(_handleLoginWithPassword);
    super.on<VerifyFirstAccessEvent>(_handleVerifyFirstAccess);
    super.on<LogoutEvent>(_handleLogout);
  }

  void _handleLoginWithPassword(
      LoginWithPasswordEvent event, Emitter<LoginState> emit) async {
    // Always succeed. This bloc is for demonstrations purposes only. In your
    // code, this is the place where you execute login logic.
    // Because login logic tends to be complicated, you can extract these methods
    // to a separate file if you want.
    await Future.delayed(const Duration(milliseconds: 500));
    switch (event.username) {
      case "bad@mail.com":
        emit(const LoginStateFailure(PlaygroundBusinessError(
          "login-001",
          "A",
          blocName: "login",
        )));
        break;
      case "rookie@mail.com":
        emit(const LoginStateFirstAccess(User(
            username: "rookie@mail.com",
            userRole: UserRole.user,
            name: PersonNameEnglish("Jonathan", "Edmonton", "Samson", "Rookie"),
            address: Address(
                postalCode: "60628",
                number: "1907",
                streetAddress: "S Halsted St",
                city: "Chicago",
                state: "IL",
                country: "USA"))));
        break;
      case "overlord@mail.com":
        emit(const LoginStateLoggedIn(User(
            username: "overlord@mail.com",
            userRole: UserRole.admin,
            name: PersonNameJapan(
                "菊地", "蒼空", "きくち", "そうすけ", "Kikuchi", "Sousuke"),
            address: Address(
                postalCode: "277-0841",
                streetAddress: "4-chome 10-8 Akebono",
                city: "Kashiwa",
                state: "Chiba",
                country: "Japan"))));
        break;
      case "joe@mail.com":
      default:
        emit(const LoginStateLoggedIn(User(
            username: "joe@mail.com",
            userRole: UserRole.user,
            name: PersonNameBrazil("Marcelo", ["Lopes", "de Almeida"]),
            address: Address(
                postalCode: "05077-050",
                number: "143",
                streetAddress: "R. Guararapes",
                city: "São Paulo",
                state: "SP",
                country: "Brasil"))));
    }

    // TODO: Store information in the app data service.
  }

  void _handleVerifyFirstAccess(
      VerifyFirstAccessEvent event, Emitter<LoginState> emit) async {
    // Mock. Always emit success when the current state is the correct one.
    var s = state;
    if (s is LoginStateFirstAccess) {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(LoginStateLoggedIn(s.user));
    }
  }

  void _handleLogout(LogoutEvent event, Emitter<LoginState> emit) async {
    emit(const LoginStateLoggedOut());
    // TODO: Store information in the app data service.
  }
}
