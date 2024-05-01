part of 'reset_bloc.dart';

enum ResetPasswordStatus{initial,loading,error,Updated,verified,Sended}
class ResetPasswordState extends Equatable{
  const ResetPasswordState({
    this.confirmPassword = const ConfirmPassword.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.message = '',
    this.status = ResetPasswordStatus.initial,
  });

final ResetPasswordStatus status;
  final Email email;
  final String message;
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
    ResetPasswordStatus? status,

    Email? email,
    String? message,

    Password? password,
    ConfirmPassword? confirmPassword,
    bool? isValid,
  }) {
    return ResetPasswordState(
      message: message ?? this.message,
      status: status ?? this.status,
      confirmPassword: confirmPassword ?? this.confirmPassword  ,

      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
    );


  }

  @override
  List<Object> get props => [message, email,status, password,isValid,confirmPassword];
}
class ResetInitial extends ResetPasswordState{}

