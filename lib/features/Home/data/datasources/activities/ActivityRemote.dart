import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../core/config/env/urls.dart';
import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/verification.dart';
import '../../../../../core/error/Exception.dart';
import "package:http/http.dart" as http;

import '../../../domain/enums/ParticipantWithEvents.dart';



Future<Unit> ParticiActionActivity(String Eventid,PaticipantWithEventsAction action) async{
  try {
    final userId = await const Store().getUserId();
Logger().i('ParticiActionActivity: $Eventid');
Logger().i('ParticiActionActivity: $userId');
    final url = '${Urls.mainurl}/${action.name}?eventId=$Eventid&memberId=$userId';
    final response = await http.post(Uri.parse(url));
if (response.statusCode == 200) {
  Logger().i('ParticiActionActivity: $response');
      return Future.value(unit);
    } else if (response.statusCode == 400) {
      throw WrongCredentialsException();
    } else {
  Logger().e ('ParticiActionActivity: ${response.body}');
      throw NotVerifiedException();
    }


  } catch (e) {
    Logger().e('ParticiActionActivity: $e');
    throw ServerException();
  }
}