part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final bool isValid;
  factory LoginState.initial() {
    return const  LoginState(
      status: FormzSubmissionStatus.initial,
      email: Email.pure(),
      password: Password.pure(),

      isValid: false,

    );
  }

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    bool? isValid,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
    );


  }

  @override
  List<Object> get props => [status, email, password];
}
class LoginInitial extends LoginState{}
class LoadingLogin extends LoginState
{}
class ErrorLogin extends LoginState{
  final String message;
   ErrorLogin({ required this.message});
  @override
  List<Object> get props =>
      [message];


}
class RegisterGoogle extends LoginState{
  final User user;

  RegisterGoogle({required this.user});
  @override
  List<Object> get props =>
      [user];
}
class MessageLogin extends LoginState{
  final String message;
  MessageLogin({ required this.message});
  @override
  List<Object> get props =>
      [message];


}
class GetUserProfileState extends LoginState{}
