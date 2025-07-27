part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.IsLoading = false,
    this.phone = const PhoneNumber.pure(),
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final PhoneNumber phone;
  final bool IsLoading ;
  final bool isValid;
  factory LoginState.initial() {
    return const  LoginState(
      IsLoading: false,
      status: FormzSubmissionStatus.initial,
      email: Email.pure(),
      password: Password.pure(),
      phone: PhoneNumber.pure(),

      isValid: false,


    );
  }

  LoginState copyWith({
    bool? IsLoading,

    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    bool? isValid,
    PhoneNumber? phone,
  }) {
    return LoginState(
      IsLoading: IsLoading ?? this.IsLoading,
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      phone: phone ?? this.phone,
    );


  }

  @override
  List<Object> get props => [status, email, password, isValid,phone,IsLoading];
}
class LoginInitial extends LoginState{}
class LoadingLogin extends LoginState
{}
class LoadingLoginWithEmail extends LoginState
{}
class ErrorLogin extends LoginState{
  final String message;
   const ErrorLogin({ required this.message});
  @override
  List<Object> get props =>
      [message];


}
class RegisterGoogle extends LoginState{
  final User user;

  const RegisterGoogle({required this.user});
  @override
  List<Object> get props =>
      [user];
}
class MessageLogin extends LoginState{
  final String message;
  const MessageLogin({ required this.message});
  @override
  List<Object> get props =>
      [message];


}
class GetUserEmailState extends LoginState{
  final String emai;
  const GetUserEmailState({ required this.emai});
  @override
  List<Object> get props =>
      [email];
}
class GetUserProfileState extends LoginState{}
