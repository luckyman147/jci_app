part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class RefreshTokenEvent extends AuthEvent {
  const RefreshTokenEvent();

  @override
  List<Object?> get props => [];
}


