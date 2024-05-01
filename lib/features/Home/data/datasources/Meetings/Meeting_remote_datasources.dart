import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/MemberStore.dart';


import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/uploadImage.dart';
import '../../../../../core/config/services/verification.dart';
import '../../../../../core/error/Exception.dart';
import '../../model/meetingModel/MeetingModel.dart';
import '../activities/ActivityRemote.dart';

abstract class MeetingRemoteDataSource {
  Future<List<MeetingModel>> getAllMeetings();
  Future<MeetingModel> getMeetingById(String id);
  Future<List<MeetingModel>> getMeetingsOfTheWeek();


  Future<Unit> createMeeting(MeetingModel Meeting);

  Future<Unit> updateMeeting(MeetingModel Meeting);
  Future<Unit> deleteMeeting(String id);

  Future<Unit> leaveMeeting(String id);
  Future<Unit> participateMeeting(String id);

}

class MeetingRemoteDataSourceImpl implements MeetingRemoteDataSource{
  final http.Client client;

  MeetingRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> createMeeting(MeetingModel Meeting)async {
    final token = await getTokens();
final body = Meeting.toJson();
    return client.post(
      Uri.parse(createMeetingUrl),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${token[1]}"
      },
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 200) {


          return Future.value(unit);



      }
      else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      }
      else {
        throw ServerException();
      }
    });

  }

  @override
  Future<Unit> deleteMeeting(String id)async {
    final token = await getTokens();
    final response = await client.delete(

      Uri.parse(getMeetingsUrl+"$id"),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${token[1]}"

      },
    );
    if (response.statusCode==204){
      return Future.value(unit);
    }
    else{
      throw EmptyDataException();
    }
  }

  @override
  Future<List<MeetingModel>> getAllMeetings()async  {
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response = await client.post(

      Uri.parse(getMeetingsUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('meetings')) {
        final List<MeetingModel> MeetingModels = (decodedJson['meetings'] as List)
            .map<MeetingModel>((jsonPostModel) =>
            MeetingModel.fromJson(jsonPostModel))
            .toList();

        return MeetingModels;
      } else {
        throw EmptyDataException();
      }
    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<MeetingModel> getMeetingById(String id)async {

    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response =  await client.post(
      Uri.parse(getMeetingsUrl + 'get/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;

      final MeetingModel meetingModel = MeetingModel.fromJson(decodedJson);
      return meetingModel;

    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }


  @override
  Future<List<MeetingModel>> getMeetingsOfTheWeek()async  {
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response = await client.post(
      Uri.parse(getMeetingByWeek),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),

    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('meetings')) {
        final List<MeetingModel> MeetingModels = (decodedJson['meetings'] as List)
            .map<MeetingModel>((jsonMeetingModel) =>
            MeetingModel.fromJson(jsonMeetingModel))
            .toList();

        return MeetingModels;
      } else {
        throw EmptyDataException();
      }
    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<Unit> leaveMeeting(String id) async{
    return leaveActivity(id, client, getMeetingsUrl);

  }


  @override
  Future<Unit> participateMeeting(String id)async  {
    return await ParticiActivity(id, client, getMeetingsUrl);
  }

  @override
  Future<Unit> updateMeeting(MeetingModel Meeting)async  {
    final tokens= await getTokens();
    final body =Meeting.toJson();
    return client.patch(
      Uri.parse(getMeetingsUrl+Meeting.id+"/edit"),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${tokens[1]}"},
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;
         return Future.value(unit);

      }
      else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      }
      else {
        throw ServerException();
      }
    });
  }

}