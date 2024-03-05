import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/env/urls.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/features/auth/data/models/Member/AuthModel.dart';
import 'package:jci_app/features/auth/data/models/MemberLogin/MerberLogin.dart';

import 'authRemote.dart';





abstract class LoginRemoteDataSource {
  Future<Unit> Login(MemberLogin memberModelLogin);
}



class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;
  final AuthRemote auth;

  LoginRemoteDataSourceImpl({required this.client, required this.auth});
  @override
  Future<Unit> Login(MemberLogin modelLogin) async {



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

await auth.getUserProfile();
        return Future.value(unit);









    } else if (Response.statusCode == 400) {
      throw WrongCredentialsException();
    } else {
      throw ServerException();
    }
  }

}
