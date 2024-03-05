part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}
class AuthLoading extends AuthState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class AuthFailureState extends AuthState {
  final String message;

  AuthFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}


class AuthSuccessState extends AuthState {
  @override
  List<Object?> get props => [];
}
class AuthLogoutState extends AuthState {
  @override
  List<Object?> get props => [];
}

