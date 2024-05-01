import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';


import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/uploadImage.dart';
import '../../../../../core/config/services/verification.dart';
import '../../../../../core/error/Exception.dart';
import '../../../domain/entities/Activity.dart';
import '../../model/events/EventModel.dart';
import '../activities/ActivityRemote.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEvents();
  Future<EventModel> getEventById(String id);
  Future<List<EventModel>> getEventsOfTheWeek();
  Future<List<EventModel>> getEventsOfTheMonth();
  Future<Unit> createEvent(EventModel event);
  Future<Unit> updateEvent(EventModel event);
  Future<Unit> deleteEvent(String id);

  Future<Unit> leaveEvent(String id);
  Future<Unit> participateEvent(String id);

}

class EventRemoteDataSourceImpl implements EventRemoteDataSource{
  final http.Client client;

  EventRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> createEvent(EventModel event)async  {
final body =event.toJson();
final token = await getTokens();

    return client.post(
      Uri.parse(createEventUrl),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${token[1]}"

      },
      body: json.encode(body),
    ).then((response) async {
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;


        final upload_response=await uploadImages(decodedJson['_id'], event.CoverImages.first,getEventsUrl,"CoverImages");
        if (upload_response.statusCode==200){
          return Future.value(unit);
        }
        else if (upload_response.statusCode==400){

          deleteEvent(decodedJson["_id"]);
          throw EmptyDataException();

        }else {
          throw ServerException();
        }

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
  Future<Unit> deleteEvent(String id)async {
    final token = await getTokens();
    final response = await client.delete(

      Uri.parse(getEventsUrl+"$id"),
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
  Future<List<EventModel>> getAllEvents()async  {
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response = await client.post(

      Uri.parse(getEventsUrl),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode({"id": memberId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('events')) {
        final List<EventModel> eventModels = (decodedJson['events'] as List)
            .map<EventModel>((jsonPostModel) =>
            EventModel.fromJson(jsonPostModel))
            .toList();
        EventStore.saveEventPermissions((decodedJson['Permissions'] as List).map((e) => e.toString()).toList());

        return eventModels;
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
  Future<EventModel> getEventById(String id)async {
    final member = await MemberStore.getModel();

 final response =  await client.post(
      Uri.parse(getEventsUrl + 'get/$id'),

      headers: {"Content-Type": "application/json"},
      body:jsonEncode({"id": member!.id}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;

        final EventModel eventModel = EventModel.fromJson(decodedJson);
        return eventModel;

    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<EventModel>> getEventsOfTheMonth() async{
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response =  await client.post(
      Uri.parse(getEventByMonth),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode({"id": memberId}),
    );
print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('events')) {
        final List<EventModel> eventModels = (decodedJson['events'] as List)
            .map<EventModel>((jsonEventModel) =>
            EventModel.fromJson(jsonEventModel))
            .toList();

        return eventModels;
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
  Future<List<EventModel>> getEventsOfTheWeek()async  {
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response = await client.post(
      Uri.parse(getEventByWeek),
      headers: {"Content-Type": "application/json"},
      body:jsonEncode({"id": memberId}),
    );
print(response.statusCode);
print("object");
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('events')) {
        final List<EventModel> eventModels = (decodedJson['events'] as List)
            .map<EventModel>((jsonEventModel) =>
            EventModel.fromJson(jsonEventModel))
            .toList();
print(eventModels.first.name);
        return eventModels;
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
  Future<Unit> leaveEvent(String id)async  {
    return leaveActivity(id, client, getEventsUrl);

  }

  @override
  Future<Unit> participateEvent(String id)async {
    return await ParticiActivity(id, client, getEventsUrl);

  }

  @override
  Future<Unit> updateEvent(EventModel event) async {
    final body =event.toJson();

    return await EditFunction(event, body,getEventsUrl+event.id+"/edit",getEventsUrl,client);
  }


}