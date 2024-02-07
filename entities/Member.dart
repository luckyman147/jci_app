import 'package:equatable/equatable.dart';

class Member extends Equatable {
  const Member( { required this.email, required this.password, required this.FirstName, required this.LastName});

 final String FirstName;
 final String LastName;
  final String email;
  final String password;

  @override
  List<Object> get props => [FirstName,LastName,email,password];

  static const empty = Member(email: '', password: '', FirstName: '', LastName: '');
}
