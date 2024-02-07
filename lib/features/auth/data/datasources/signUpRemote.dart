import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/auth/data/models/MemberModel.dart';

abstract class SignUpRemoteDataSource {
  Future<String> signUp(MemberModelSignUp memberModelSignUp);
}const BASE_URL = "http://10.0.2.2:8000/auth/signup/";
class SignUpRemoteDataSourceImpl implements SignUpRemoteDataSource {
  final http.Client client;

  SignUpRemoteDataSourceImpl({required this.client});
  @override
  Future<String> signUp(MemberModelSignUp memberModelSignUp)async {
    print(memberModelSignUp.FirstName);
    print(memberModelSignUp.LastName);
    print(memberModelSignUp.email);
    print(memberModelSignUp.password);
    final body = {
      "email": memberModelSignUp.email,
      "password":memberModelSignUp.password,
      "firstName": memberModelSignUp.FirstName,
      "lastName": memberModelSignUp.LastName
    };
    print(body);
    print(client);
    final Response=await client.post(
      Uri.parse(BASE_URL),

        body: body,);
    print("haha"+Response.statusCode.toString());
    final response=jsonDecode(Response.body);

    if (Response.statusCode == 201) {
      print(response);
      return response['message'];
    } else if (Response.statusCode==400){
      print(response);
      return response;
    }
else{
  print('tetkouheb');
      throw ServerException();
    }

  }

}