part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}
final class SignUpEmailnameChanged extends SignUpEvent {
  const SignUpEmailnameChanged(this.email);

  final String  email;

  @override
  List<Object> get props => [email];
}

final class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}
final class FirstNameChanged extends SignUpEvent {
  const FirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}
final class LastNameChanged extends SignUpEvent {
  const LastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}final class ConfirmPasswordChanged extends SignUpEvent {
  const ConfirmPasswordChanged(this.confirmPassword);

  final String confirmPassword;

  @override
  List<Object> get props => [confirmPassword];
}


final class SignUpSubmitted extends SignUpEvent{
final SignField signField;

  const SignUpSubmitted({required this.signField});
  @override
  List<Object> get props => [signField,];
}
class ResetForm extends SignUpEvent {
  const ResetForm();
}

class SendVerificationEmailEventOrRegister extends SignUpEvent{
  final String email;
  final bool isGoogle;
  final Member? member;
  const SendVerificationEmailEventOrRegister(this.isGoogle, this.member, {required this.email});
  @override
  List<Object> get props => [email,isGoogle];

}