import 'dart:convert';
import 'dart:developer';

import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/TeamStore.dart';
import 'package:jci_app/features/auth/data/models/Member/AuthModel.dart';


import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/env/urls.dart';

import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';


import 'package:http/http.dart' as http;

import '../../../../core/config/services/verification.dart';
import '../../../../core/error/Failure.dart';
import '../../domain/entities/Member.dart';
import '../models/MemberSIgnUP/MerberSignUp.dart';

abstract class  AuthRemote {
  Future<bool>  signOut();
  Future<Either<Failure, MemberModel>> sendPasswordResetEmail(String email);
  Future<Either<Failure, MemberModel>> verifyEmail();
  Future<Unit> updatePassword(MemberModel member);
  Future<Unit> refreshToken();

  Future<Unit> Login(String email,String password);
  Future<Unit> SendVerificationEmail(String email,bool isReset);

  Future<Unit> signUp(MemberModel memberModelSignUp);

}
class AuthRemoteImpl implements AuthRemote {

final http.Client client;


  AuthRemoteImpl({required this.client});




  Future<Unit> refreshToken() async {

    final tokens=await Store.GetTokens();
    if (tokens[0] == null || tokens[0].toString().isEmpty ) {

throw EmptyCacheException();

    }
    // replace with your actual access token

    try {
      final Response = await client.post(
        Uri.parse(RefreshTokenUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokens[0]}'

        },

      );

      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);



        Store.setTokens( response['refreshToken'],response['accessToken'] );
        return Future.value(unit);
      } else {
        // Request failed
      //  print('Request failed with status: ${Response.statusCode}');

        throw ExpiredException();
      }
    } catch (e) {


    throw ServerException();
    }}


  @override
  Future<bool> signOut()async {

    final tokens=await Store.GetTokens();






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

      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);
       await  Store.clear();
      await   MemberStore.clearModel();
     await    Store.setLoggedIn(false);
     await TeamStore.clearCache();
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

        throw ServerException();}
      }
      else {

        await    Store.setLoggedIn(false);

        throw ServerException();
      }
    } catch (e) {
      // Exception occurred during the request
      print('Exception during request: $e');
      await    Store.setLoggedIn(false);

      throw UnauthorizedException()  ;


    }

  }

  @override
  Future<Unit> updatePassword(MemberModel member)async {

  final body=jsonEncode(member.toJson());

    final Response = await client.patch(
      Uri.parse(ForgetPasswordUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (Response.statusCode == 200) {
      final Map<String, dynamic> response = jsonDecode(Response.body);

      return Future.value(unit);
    }
    else if (Response.statusCode==401){
        throw WrongCredentialsException();
    }

    else {

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



Future<Unit> Login(String email,String password) async {







  final Response = await client.post(
    Uri.parse(LoginUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"email":email,"password":password}),
  );


  final response = jsonDecode(Response.body);

  if (Response.statusCode == 200) {




    await Store.setTokens(response['refreshToken'],response['accessToken'] );

    await Store.setLoggedIn(true);

    List<String> stringList = (response['Permissions'] as List).map((element) => element.toString()).toList();
    await Store.setPermissions(stringList);


    //await MemberStore.saveModel(MemberModel.fromJson(response['member']));
    return Future.value(unit);









  } else if (Response.statusCode == 400) {
    throw WrongCredentialsException();
  } else {
    throw ServerException();
  }
}

@override
Future<Unit> signUp(MemberModel memberModelSignUp)async {

  final body = jsonEncode(memberModelSignUp.toJson());
  final Response=await client.post(
    Uri.parse(SignUpUrl),

    headers: {"Content-Type": "application/json"},

    body: body,);



  if (Response.statusCode == 201) {

    return Future.value(unit);
  } else if (Response.statusCode==400){


    throw ServerException();
  }
  else if (Response.statusCode==409){


    throw IsEmailException();
  }
  else{

    throw ServerException();
  }

}
Map<String, dynamic> filterMap(Map<String, dynamic> user) {
  return user.containsKey('constraints')  ? user : {};
}

  @override
  Future<Unit> SendVerificationEmail(String email,bool isReset) async {
    try{
    final Response = await client.post(
      Uri.parse(isReset?Urls.ResetPassword: Urls.mailVerify),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email,}),
    );


    final Map<String,dynamic> response  = jsonDecode(Response.body);

    if (Response.statusCode == 200) {
      log(response.toString());
      final  otp = response['otp'];
      log(otp.toString());
      await Store.setOtp(otp.toString());
      return Future.value(unit);
    }
    else if (Response.statusCode == 400) {
      throw WrongCredentialsException();
    }
    else if (Response.statusCode == 404) {
      throw WrongCredentialsException();
    }


    else {
      throw ServerException();
    }
  }
  catch(e){
    log(e.toString());
    throw ServerException();
    }}

}