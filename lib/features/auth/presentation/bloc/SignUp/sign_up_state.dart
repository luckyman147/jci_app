part of 'sign_up_bloc.dart';
enum SignUpStatus{Initial,
  EmailSuccessState,MessageSignUp,Loading,ErrorSignUp,RegisterGoogle
}
class SignUpState extends Equatable {
  const SignUpState({
      this.status = FormzSubmissionStatus.initial,


    this.firstname = const Firstname.pure(),
    this.lastname = const Lastname.pure(),
    this.isValid = false,
    this.email = const Email.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.password = const Password.pure(),
    this.signUpStatus= SignUpStatus.Initial
,this.message=""
  ,this.isLoading=false
  });
final SignUpStatus signUpStatus;
  final FormzSubmissionStatus status;
final String message;
  final Firstname firstname;
  final Lastname lastname;
  final bool isValid;
  final bool  isLoading ;


  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;


  SignUpState copyWith({
    bool?isLoading,

    SignUpStatus?signUpStatus,
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
String?message,
    Firstname? firstname,
    Lastname? lastname,
    bool? isValid,

    ConfirmPassword? confirmPassword,

  }) {
    return SignUpState(
      isLoading: isLoading??this.isLoading,
      signUpStatus: signUpStatus??this.signUpStatus,
      status: status ?? this.status,
      email: email ?? this.email,
      message: message??this.message,
      password: password ?? this.password,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      isValid: isValid ?? this.isValid,

confirmPassword: confirmPassword??this.confirmPassword
    );
  }
  factory SignUpState.initial() {
    return const  SignUpState(
      isLoading: false,
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
      [status, email,message, password, firstname, lastname, confirmPassword,signUpStatus,isLoading];


}
class SignUpInitial extends SignUpState{}


