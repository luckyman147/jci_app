import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String email;
  final String password;


  const Member(
      {required this.email,
        required this.password,
       });

  static const  empty = Member(email: '', password: '',);

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, ];}