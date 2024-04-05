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
  final String email  ;
  final String password;
  const LoginSubmitted(this.email, this.password);

  @override
  List<Object> get props => [email, password];


}
class ResetForm extends LoginEvent {
  const ResetForm();
}
class GetUserEvent extends LoginEvent {
  const GetUserEvent();
}