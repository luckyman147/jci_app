import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/env/urls.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/features/auth/data/models/Member/AuthModel.dart';
import 'package:jci_app/features/auth/data/models/MemberLogin/MerberLogin.dart';

import 'authRemote.dart';





abstract class LoginRemoteDataSource {
  Future<Unit> Login(String email, String password);
}



class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;
  final AuthRemote auth;

  LoginRemoteDataSourceImpl({required this.client, required this.auth});
  @override
  Future<Unit> Login(String email,String password) async {







    final Response = await client.post(
      Uri.parse(LoginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email":email,"password":password}),
    );
    print("haha" + Response.statusCode.toString());

    final response = jsonDecode(Response.body);
    print("haha  ${response}"  );
    if (Response.statusCode == 200) {




        await Store.setTokens(response['refreshToken'],response['accessToken'] );
        log("[access: ${response['accessToken']}]");
        await Store.setLoggedIn(true);
        log("refreshToken: ${response['accessToken']}");

        List<String> stringList = (response['Permissions'] as List).map((element) => element.toString()).toList();
        await Store.setPermissions(stringList);
        log("refreshToken: ${response['accessToken']}");

        //await MemberStore.saveModel(MemberModel.fromJson(response['member']));
        return Future.value(unit);









    } else if (Response.statusCode == 400) {
      throw WrongCredentialsException();
    } else {
      throw ServerException();
    }
  }

}
