import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/auth/data/models/MemberModel.dart';
import 'package:jci_app/features/auth/domain/usecases/SIgnIn.dart';

abstract class LoginRemoteDataSource {
  Future<Map<String,dynamic>> Login(MemberModelLogin memberModelLogin);
}const BASE_URL = "http://10.0.2.2:8000/auth/login/";
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;

  LoginRemoteDataSourceImpl({required this.client});
  @override
  Future<Map<String,dynamic>> Login(MemberModelLogin modelLogin)async {
    
    print(modelLogin.email);
    print(modelLogin.password);
    final body = {
      "email": modelLogin
          .email,
      "password":modelLogin.password,
      
    };
    print(body);

    final Response=await client.post(
      Uri.parse(BASE_URL),

      body: jsonEncode(body),);
    print("haha"+Response.statusCode.toString());
    final response=jsonDecode(Response.body);

    if (Response.statusCode == 201) {
      print(response);
      return {'message':response['message'],'AccessToken':response['AccessToken'], 'RefreshToken':response['RefreshToken']};
    } else if (Response.statusCode==400){
      print(response);
      return response;
    }
    else{
     
      throw ServerException();
    }

  }

}