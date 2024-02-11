import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/Failure.dart';
import '../../domain/entities/Member.dart';
abstract class  AuthRemote {
  Future<Either<Failure, MemberSignUp>> signOut();
  Future<Either<Failure, MemberSignUp>> sendPasswordResetEmail(String email);
  Future<Either<Failure, MemberSignUp>> verifyEmail();
  Future<Either<Failure, MemberSignUp>> updatePassword(String password);
  Future<bool> refreshToken();
  Future<Either<Failure, MemberSignUp>> deleteAccount();

}
class AuthRemoteImpl implements AuthRemote {

final http.Client client;
  String? accessToken;

  AuthRemoteImpl({required this.client});




  Future<bool> refreshToken() async {
    const String apiUrl = 'http://10.0.2.2:8080/auth/RefreshToken';
    final tokens=await Store.GetTokens();
    if (tokens[0] == null ) {
      print('famech token');
      throw EmptyCacheException();

    }
    // replace with your API endpoint
    final  accessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'refreshToken': '${tokens[0]}', // replace with your actual refresh token
        }),
      );
      final response = jsonDecode(Response.body);
      if (response.statusCode == 201) {
        // Request was successful
        print('Request successful: ${response.body}');
        Store.setTokens( response['refreshToken'],response['accessToken'] );
        return true;
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw ServerException();
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
  Future<Either<Failure, MemberSignUp>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MemberSignUp>> updatePassword(String password) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MemberSignUp>> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }
}