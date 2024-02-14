part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
      this.status = FormzSubmissionStatus.initial,


    this.firstname = const Firstname.pure(),
    this.lastname = const Lastname.pure(),
    this.isValid = false,
    this.email = const Email.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.password = const Password.pure(),

  });

  final FormzSubmissionStatus status;

  final Firstname firstname;
  final Lastname lastname;
  final bool isValid;


  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;


  SignUpState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,

    Firstname? firstname,
    Lastname? lastname,
    bool? isValid,

    ConfirmPassword? confirmPassword,

  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      isValid: isValid ?? this.isValid,

confirmPassword: confirmPassword??this.confirmPassword
    );
  }
  factory SignUpState.initial() {
    return const  SignUpState(
      status: FormzSubmissionStatus.initial,
      email: Email.pure(),
      password: Password.pure(),
      firstname: Firstname.pure(),
      lastname: Lastname.pure(),
      isValid: false,
      confirmPassword: ConfirmPassword.pure(),
    );
  }

  @override
  List<Object> get props =>
      [status, email, password, firstname, lastname, confirmPassword];


}
class SignUpInitial extends SignUpState{}
class LoadingSignUp extends SignUpState{}
class ErrorSignUp extends SignUpState{
  final String message;
  ErrorSignUp({ required this.message});
  @override
  List<Object> get props =>
      [message];


}class MessageSignUp extends SignUpState{
  final String message;
  MessageSignUp({ required this.message});
  @override
  List<Object> get props =>
      [message];


}
