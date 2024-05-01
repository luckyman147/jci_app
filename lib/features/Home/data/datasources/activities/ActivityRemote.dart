import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/config/services/verification.dart';
import '../../../../../core/error/Exception.dart';
import "package:http/http.dart" as http;
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
  debugPrint(tokens.toString());


  final Response = await client.post(
    Uri.parse("$geturl/$id/addParticipant"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokens[1]}',
    },

  );

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