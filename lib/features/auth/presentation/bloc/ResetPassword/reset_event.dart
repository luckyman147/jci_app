part of 'reset_bloc.dart';

sealed class ResetEvent extends Equatable {
  const ResetEvent();

  @override
  List<Object> get props => [];
}
final class EmailnameChanged extends ResetEvent {
  const EmailnameChanged(this.email);

  final String  email;

  @override
  List<Object> get props => [email];
}

final class PasswordChanged extends ResetEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}final class ConfirPasswordChanged extends ResetEvent {
  const ConfirPasswordChanged(this.Confirmpassword);

  final String Confirmpassword;

  @override
  List<Object> get props => [Confirmpassword];
}

final class ResetPassForm extends ResetEvent {
  const ResetPassForm();
  @override
  List<Object> get props => [];
}
final class ResetSubmitted extends ResetEvent {
final ResetpasswordDtos member;
  const ResetSubmitted({required this.member});

  @override
  List<Object> get props => [member];
}
final class CheckOtpEvent extends ResetEvent {
  final String checkOTPDtos;

  const CheckOtpEvent({required this.checkOTPDtos});

  @override
  List<Object> get props => [checkOTPDtos];
}
final class sendResetPasswordEmailEvent extends ResetEvent {
  final String email;

  const sendResetPasswordEmailEvent({required this.email});

  @override
  List<Object> get props => [email];
}
final class ResetErrorEvent extends ResetEvent {


  const ResetErrorEvent();

  @override
  List<Object> get props => [];
}