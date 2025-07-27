part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}
class AppStartedEvent extends AuthEvent {
  const AppStartedEvent();

  @override
  List<Object?> get props => [];
}
class RefreshTokenEvent extends AuthEvent {
  const RefreshTokenEvent();

  @override
  List<Object?> get props => [];
}

class CheckIdUserExistedEvent extends AuthEvent {
  const CheckIdUserExistedEvent();

  @override
  List<Object?> get props => [];
}

class SignoutEvent extends AuthEvent {
  const SignoutEvent();

  @override
  List<Object?> get props => [];
}
//verify if loggedin
class IsLoggedInEvent extends AuthEvent {
  const IsLoggedInEvent();

  @override
  List<Object?> get props => [];
}


