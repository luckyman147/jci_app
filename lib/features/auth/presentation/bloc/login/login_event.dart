part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginEmailnameChanged extends LoginEvent {
  const LoginEmailnameChanged(this.email);

  final String  email;

  @override
  List<Object> get props => [email];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class LoginSubmitted extends LoginEvent {
  final Member loginMember  ;
  const LoginSubmitted(this.loginMember);

  @override
  List<Object> get props => [loginMember];


}
class ResetForm extends LoginEvent {
  const ResetForm();
}