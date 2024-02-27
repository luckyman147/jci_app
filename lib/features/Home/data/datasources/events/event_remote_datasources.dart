import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;


import '../../../../../core/error/Exception.dart';
import '../../model/events/EventModel.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEvents();
  Future<EventModel> getEventById(String id);
  Future<List<EventModel>> getEventsOfTheWeek();
  Future<List<EventModel>> getEventsOfTheMonth();

  Future<Unit> createEvent(EventModel event);
  Future<Unit> updateEvent(EventModel event);
  Future<Unit> deleteEvent(String id);

  Future<bool> leaveEvent(String id);
  Future<bool> participateEvent(String id);

}

class EventRemoteDataSourceImpl implements EventRemoteDataSource{
  final http.Client client;

  EventRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> createEvent(EventModel event) {
    // TODO: implement createEvent
    throw UnimplementedError();
  }

  @override
  Future<Unit> deleteEvent(String id) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<List<EventModel>> getAllEvents()async  {
    final response = await client.get(

      Uri.parse(getEventsUrl),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('events')) {
        final List<EventModel> eventModels = (decodedJson['events'] as List)
            .map<EventModel>((jsonPostModel) =>
            EventModel.fromJson(jsonPostModel))
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
  Future<EventModel> getEventById(String id)async {
 final response =  await client.get(
      Uri.parse(getEventsUrl + '$id'),
      headers: {"Content-Type": "application/json"},
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
    final response =  await client.get(
      Uri.parse(getEventByMonth),
      headers: {"Content-Type": "application/json"},
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
    final response = await client.get(
      Uri.parse(getEventByWeek),
      headers: {"Content-Type": "application/json"},
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
  Future<bool> leaveEvent(String id) {
    // TODO: implement leaveEvent
    throw UnimplementedError();
  }

  @override
  Future<bool> participateEvent(String id) {
    // TODO: implement participateEvent
    throw UnimplementedError();
  }

  @override
  Future<Unit> updateEvent(EventModel event) {
    // TODO: implement updateEvent
    throw UnimplementedError();
  }
}