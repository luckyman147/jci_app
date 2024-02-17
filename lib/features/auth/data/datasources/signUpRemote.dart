import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/env/urls.dart';
import 'package:jci_app/core/error/Exception.dart';

import '../models/signup/membersignup.dart';


abstract class SignUpRemoteDataSource {
  Future<Unit> signUp(MemberModelSignUp memberModelSignUp);
}
class SignUpRemoteDataSourceImpl implements SignUpRemoteDataSource {
  final http.Client client;

  SignUpRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> signUp(MemberModelSignUp memberModelSignUp)async {

    final body = jsonEncode(memberModelSignUp.toJson());
    final Response=await client.post(
      Uri.parse(SignUpUrl),

      headers: {"Content-Type": "application/json"},

        body: body,);
    print("haha"+Response.statusCode.toString());
    final response=jsonDecode(Response.body);
    print(response);
    if (Response.statusCode == 201) {
      print(response);
      return Future.value(unit);
    } else if (Response.statusCode==400){
      print(response);

      throw ServerException();
    }
    else if (Response.statusCode==409){
      print(response);

   throw IsEmailException();
    }
else{
  print('tetkouheb');
      throw ServerException();
    }

  }
  Map<String, dynamic> filterMap(Map<String, dynamic> user) {
    return user.containsKey('constraints')  ? user : {};
  }
}