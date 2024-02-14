import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/auth/data/models/MemberModel.dart';
import 'package:shared_preferences/shared_preferences.dart';



abstract class LoginRemoteDataSource {
  Future<Unit> Login(MemberModel memberModelLogin);
}

const BASE_URL = "http://10.0.2.2:8080/auth/login/";

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;

  LoginRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> Login(MemberModel modelLogin) async {



    final body = modelLogin.toJson();
    print(body);

    final Response = await client.post(
      Uri.parse(BASE_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print("haha" + Response.statusCode.toString());
    final response = jsonDecode(Response.body);
    print(Response.statusCode);

    if (Response.statusCode == 200) {

      await Store.setTokens(response['refreshToken'],response['accessToken'] );

print("haha token store" );
print("haha token store" );



      print(response);
      return Future.value(unit);
    } else if (Response.statusCode == 400) {
      throw WrongCredentialsException();
    } else {
      throw ServerException();
    }
  }
}
