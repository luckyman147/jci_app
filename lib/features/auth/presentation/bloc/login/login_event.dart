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
final class SignInWithGoogleEvent extends LoginEvent {
  const SignInWithGoogleEvent();
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class LoginPhoneChanged extends LoginEvent {
  const LoginPhoneChanged(this.phone);

  final String phone;

  @override
  List<Object> get props => [phone];
}

final class LoginWithEmailSubmitted extends LoginEvent {
final LoginWithEmailDtos loginWithEmailDtos;
  const LoginWithEmailSubmitted(this.loginWithEmailDtos);

  @override
  List<Object> get props => [loginWithEmailDtos];


}
class ResetFormLogin extends LoginEvent {
  const ResetFormLogin();
}
class GetUserEvent extends LoginEvent {
  const GetUserEvent();
}
final class HandleUserEvent extends LoginEvent {

  const HandleUserEvent();
}
final class HandleUserEmail extends LoginEvent{
  const HandleUserEmail();
}