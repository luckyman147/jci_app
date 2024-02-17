import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/env/urls.dart';

import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/auth/data/models/login/MemberModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/Failure.dart';
import '../../domain/entities/Member.dart';
abstract class  AuthRemote {
  Future<bool>  signOut();
  Future<Either<Failure, MemberSignUp>> sendPasswordResetEmail(String email);
  Future<Either<Failure, MemberSignUp>> verifyEmail();
  Future<Unit> updatePassword(MemberModel member);
  Future<bool> refreshToken();
  Future<Either<Failure, MemberSignUp>> deleteAccount();

}
class AuthRemoteImpl implements AuthRemote {

final http.Client client;
  String? accessToken;

  AuthRemoteImpl({required this.client});




  Future<bool> refreshToken() async {

    final tokens=await Store.GetTokens();
    if (tokens[0] == null ) {
      print('famech token');


    }
    // replace with your API endpoint
    final  accessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.post(
        Uri.parse(RefreshTokenUrl),
        headers: {
          'Content-Type': 'application/json',

        },
        body: jsonEncode({
          'refreshToken': '${tokens[0]}', // replace with your actual refresh token
        }),
      );
print(Response.statusCode);
      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);

        // Request was successful

        Store.setTokens( response['refreshToken'],response['accessToken'] );
        return true;
      } else {
        // Request failed
        print('Request failed with status: ${Response.statusCode}');

        throw ExpiredException();
      }
    } catch (e) {

      // Exception occurred during the request
      print('Exception during request: $e');
    throw ServerException();
    }
  }
  @override
  Future<Either<Failure, MemberSignUp>> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MemberSignUp>> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut()async {

    final tokens=await Store.GetTokens();
    if (tokens[0] == null ) {
      print('famech token');
      throw EmptyCacheException();

    }

    // replace with your API endpoint
    final  accessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.post(
        Uri.parse(LogoutUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'refreshToken': '${tokens[0]}', // replace with your actual refresh token
        }),
      );
      print(" ya bonay ${Response.statusCode}");
      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);

        Store.clear();
        return true;
      } else  if (Response.statusCode == 400 ){
        final Map<String, dynamic> response = jsonDecode(Response.body);
if (response['message']=='Already logged out'){
        throw AlreadyLogoutException();
      }
      else{
      throw UnauthorizedException()  ;
      }
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
    // ;
  }

  @override
  Future<Unit> updatePassword(MemberModel member)async {

  final body=jsonEncode(member.toJson());
  print("body");
  print(body);
    final Response = await client.patch(
      Uri.parse(ForgetPasswordUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (Response.statusCode == 200) {
      final Map<String, dynamic> response = jsonDecode(Response.body);
      print(response);
      return Future.value(unit);
    }
    else if (Response.statusCode==401){
        throw WrongCredentialsException();
    }

    else {
      // Request failed
      print('Request failed with status: ${Response.statusCode}');
      print('Response body: ${Response.body}');
      throw ServerException();
    }
  }

  @override
  Future<Either<Failure, MemberSignUp>> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }
}