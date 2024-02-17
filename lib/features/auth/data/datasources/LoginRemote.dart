import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/env/urls.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/auth/data/models/AuthModel/AuthModel.dart';
import 'package:jci_app/features/auth/data/models/login/MemberModel.dart';




abstract class LoginRemoteDataSource {
  Future<Unit> Login(MemberModel memberModelLogin);
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


        final ModelAuth = modelAuth.fromJson(response);
        await Store.saveModel(ModelAuth);
        await Store.setTokens(response['refreshToken'],response['accessToken'] );
        return Future.value(unit);









    } else if (Response.statusCode == 400) {
      throw WrongCredentialsException();
    } else {
      throw ServerException();
    }
  }
}
