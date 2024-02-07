import 'package:equatable/equatable.dart';

class LoginMember extends Equatable {
  final String email;
  final String password;


  const LoginMember(
      {required this.email,
        required this.password,
       });

  static const  empty = LoginMember(email: '', password: '',);

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, ];}