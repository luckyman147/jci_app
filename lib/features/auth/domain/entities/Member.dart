import 'package:equatable/equatable.dart';

class MemberSignUp extends Equatable {
  final String email;
  final String password;
  final String FirstName;
  final String LastName;
  final String confirmPassword;

 const MemberSignUp(
      {required this.email,
      required this.password,
      required this.FirstName,
      required this.LastName,required this.confirmPassword});

  static const  empty = MemberSignUp(email: '', password: '', FirstName: '', LastName: '', confirmPassword: '');

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, FirstName, LastName];}