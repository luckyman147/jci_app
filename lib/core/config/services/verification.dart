import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/config/services/uploadImage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import '../../../features/Home/domain/entities/Activity.dart';
import '../../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../error/Exception.dart';


void check(BuildContext context,bool mounted)async {
  final authBloc = BlocProvider.of<AuthBloc>(context);


  final authState = authBloc.state;
  final language = await Store.getLocaleLanguage();
  final token = await Store.GetTokens();
  final islooged = await Store.isLoggedIn();
  if (!mounted) return;   if (language == null) {

    context.go('/screen');}
 else  if (authState is AuthLogoutState || authState is AuthFailureState &&!islooged) {

    context.go('/login');
  }
 else if (islooged && token != null) {
    context.go('/home');
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

bool hasCommonElement(List<dynamic> list1, List<dynamic> list2) {
  // Convert one list to a set for efficient lookup
  Set<dynamic> set = list1.toSet();

  // Track the count of common elements found
  int commonCount = 0;

  // Check if any element from the second list exists in the set
  for (var element in list2) {
    if (set.contains(element)) {
      commonCount++;
      // If at least two common elements are found, return true
      if (commonCount >= 2) {
        return true;
      }
    }
  }

  // Return false if less than two common elements are found
  return false;
}

EditFunction(Activity event, Map<String, dynamic> body,String url ,String urlImage,http.Client client ) async {
  final token = await getTokens();

  return client.patch(
    Uri.parse(url),
    headers: {"Content-Type": "application/json",
      "Authorization":'Bearer ${token[1]}'

    },

    body: json.encode(body),
  ).then((response) async {
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;


      final update_response=await UpdateImage(decodedJson['_id'], event.CoverImages.first,urlImage);
      if (update_response.statusCode==200){
        return Future.value(unit);
      }
      else if (update_response.statusCode==400){

        throw EmptyDataException();

      }else {
        throw ServerException();
      }

    }
    else if (response.statusCode == 400) {
      throw WrongCredentialsException();
    }
    else if (response.statusCode==401){
      throw UnauthorizedException();
    }
    else {
      throw ServerException();
    }

  });
}
