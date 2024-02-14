part of 'reset_bloc.dart';
class ResetPasswordState extends Equatable{
  const ResetPasswordState({
    this.confirmPassword = const ConfirmPassword.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
  });


  final Email email;
  final Password password;
  final bool isValid;
  final ConfirmPassword confirmPassword;
  factory ResetPasswordState.initial() {
    return const  ResetPasswordState(

      email: Email.pure(),
      password: Password.pure(),
      confirmPassword: ConfirmPassword.pure(),
      isValid: false,

    );
  }

  ResetPasswordState copyWith({

    Email? email,

    Password? password,
    ConfirmPassword? confirmPassword,
    bool? isValid,
  }) {
    return ResetPasswordState(
      confirmPassword: confirmPassword ?? this.confirmPassword  ,

      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
    );


  }

  @override
  List<Object> get props => [ email, password,isValid,confirmPassword];
}
class ResetInitial extends ResetPasswordState{}
class LoadingReset extends ResetPasswordState
{}
class ErrorReset extends ResetPasswordState {
  final String message;

  ErrorReset({ required this.message});

  @override
  List<Object> get props =>
      [message];

}
class MessageReset extends ResetPasswordState{
  final String message;
  MessageReset({ required this.message});
  @override
  List<Object> get props =>
      [message];
}
