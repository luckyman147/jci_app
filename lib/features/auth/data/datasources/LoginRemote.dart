import 'dart:convert';
import 'package:dartz/dartz.dart';

import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/env/urls.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/auth/data/models/AuthModel/AuthModel.dart';
import 'package:jci_app/features/auth/data/models/login/MemberModel.dart';




abstract class LoginRemoteDataSource {
  Future<Unit> Login(MemberModel memberModelLogin);
  Future<Unit> getUserProfile();
}



class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;

  LoginRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> Login(MemberModel modelLogin) async {



    final body = modelLogin.toJson();
    print(body);

    final Response = await client.post(
      Uri.parse(LoginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print("haha" + Response.statusCode.toString());

    final response = jsonDecode(Response.body);
    print("haha  ${response}"  );
    if (Response.statusCode == 200) {




        await Store.setTokens(response['refreshToken'],response['accessToken'] );
        return Future.value(unit);









    } else if (Response.statusCode == 400) {
      throw WrongCredentialsException();
    } else {
      throw ServerException();
    }
  }
  @override
  Future<Unit> getUserProfile() async {

    final tokens=await Store.GetTokens();
    if (tokens[1] == null  || tokens[1].toString().isEmpty) {
      print('famech token');
      throw EmptyCacheException();

    }

    // replace with your API endpoint
    final  AccessToken =  tokens[1]; // replace with your actual access token
print("Access token");
print(AccessToken);
    try {
      final Response = await client.get(
        Uri.parse(getUserProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
        },

      );
      print(" ya get ${Response.statusCode}");
      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);
        print("response ${response}");
        final  modelAuth member=modelAuth.fromJson(response);
       await  Store.saveModel(member);
       print('member ${member.email}');

        return Future.value(unit);
      }


      else {
        // Request failed
        print('Request failed with status: ${Response.statusCode}');
        print('Response body: ${Response.body}');
        throw ServerException();
      }
    } catch (e) {
      // Exception occurred during the request
      print('Exception during request: $e');
      throw ServerException();
    }


  }
}
