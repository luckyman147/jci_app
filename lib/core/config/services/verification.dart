import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import '../../../features/Home/domain/entities/Activity.dart';
import '../../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../error/Exception.dart';

bool isTokenExpired(String token) {
  try {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    print("decodedToken");
    if (decodedToken.containsKey('exp')) {
      // 'exp' claim is present in the token
      int expirationTimestamp = decodedToken['exp'];


      // Get the current timestamp
      int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Check if the token has expired
      return expirationTimestamp < currentTimestamp;
    } else {
      print('token expired');
      // If 'exp' claim is not present, consider the token as expired
      return true;
    }
  } catch (e) {
    // Handle decoding errors
    print('Error decoding token: $e');
    return true; // Consider the token as expired in case of errors
  }
}
void check(BuildContext context)async {
  final authBloc = BlocProvider.of<AuthBloc>(context);

  if (bool.fromEnvironment("dart.vm.product")) {
    authBloc.add(RefreshTokenEvent());
  }

  final authState = authBloc.state;
  final language = await Store.getLocaleLanguage();
  final token = await Store.GetTokens();

  if (language == null) {
    context.go('/screen');
  } else if (authState is AuthSuccessState && token != null) {
    context.go('/home');
  }
  else if (authState is AuthLogoutState || authState is AuthFailureState) {
    context.go('/login');
  }
  else  {

    context.go('/Intro');
  }
}
Future<List<bool>> areMembersInParticipants(List<Activity> activities) async {
  final member = await MemberStore.getModel();
  final memberId = member!.id;
  return activities.map((activity) => activity.Participants.contains(memberId)).toList();
}
Future<List<String?>> getTokens() async {
  final tokens=await Store.GetTokens();
  if (tokens[1] == null  || tokens[1].toString().isEmpty) {
    print('famech token');
    throw EmptyCacheException();

  }
  return tokens;
}
Future<Unit> leaveActivity(String id,http.Client client ,String geturl) async{
  final tokens=await getTokens();
  try {
    final Response = await client.delete(
      Uri.parse("$geturl/$id/deleteParticipant"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokens[1]}',
      },
    );
    print(" ya get ${Response.statusCode}");
    if (Response.statusCode == 200) {
      return Future.value(unit);
    } else if (Response.statusCode == 400) {
      throw AlreadyParticipateException();
    } else {
      throw EmptyDataException();
    }}catch(e){
    throw ServerException();
  }
}
Future<Unit> ParticiActivity(String id,http.Client client ,String geturl) async{
  final tokens=await getTokens();
  debugPrint(id);


  final Response = await client.post(
    Uri.parse("$geturl/$id/addParticipant"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokens[1]}',
    },

  );
  print(" ya get ${Response.statusCode}");
  if (Response.statusCode == 200) {
    return Future.value(unit);
  } else if (Response.statusCode == 400) {
    throw AlreadyParticipateException();

  }
  else if (Response.statusCode == 401) {
    throw UnauthorizedException();
  }
  else {
    throw EmptyDataException();
  }
}