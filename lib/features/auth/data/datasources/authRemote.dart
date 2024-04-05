import 'dart:convert';

import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/features/auth/data/models/Member/AuthModel.dart';


import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/env/urls.dart';

import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';


import 'package:http/http.dart' as http;

import '../../../../core/config/services/verification.dart';
import '../../../../core/error/Failure.dart';

abstract class  AuthRemote {
  Future<bool>  signOut();
  Future<Either<Failure, MemberModel>> sendPasswordResetEmail(String email);
  Future<Either<Failure, MemberModel>> verifyEmail();
  Future<Unit> updatePassword(MemberModel member);
  Future<Unit> refreshToken();





}
class AuthRemoteImpl implements AuthRemote {

final http.Client client;
  String? accessToken;

  AuthRemoteImpl({required this.client});




  Future<Unit> refreshToken() async {

    final tokens=await Store.GetTokens();
    if (tokens[0] == null || tokens[0].toString().isEmpty ) {
      print('famech token');
throw EmptyCacheException();

    }
    final  refreshToken =  tokens[0]??""; // replace with your actual access token





    try {
      final Response = await client.post(
        Uri.parse(RefreshTokenUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokens[0]}'

        },

      );
print(Response.statusCode);
      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);

        // Request was successful

        Store.setTokens( response['refreshToken'],response['accessToken'] );
        return Future.value(unit);
      } else {
        // Request failed
        print('Request failed with status: ${Response.statusCode}');

        throw ExpiredException();
      }
    } catch (e) {

      // Exception occurred during the request
      print('Exception during request: $e');
    throw ServerException();
    }}


  @override
  Future<bool> signOut()async {

    final tokens=await Store.GetTokens();
    if (tokens[0] == null  || tokens[0].toString().isEmpty) {
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
        MemberStore.clearModel();
        return true;
      } else  if (Response.statusCode == 400 ){
        final Map<String, dynamic> response = jsonDecode(Response.body);
if (response['message']=='Already logged out'){
        throw AlreadyLogoutException();
      }
      else if ( Response.statusCode==401){
      throw UnauthorizedException()  ;
      }
      else {
        // Request failed
        print('Request failed with status: ${Response.statusCode}');
        print('Response body: ${Response.body}');
        throw ServerException();}
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
  Future<Either<Failure, MemberModel>> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }






  @override
  Future<Either<Failure, MemberModel>> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }










}