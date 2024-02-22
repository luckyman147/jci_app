import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/env/urls.dart';
import 'package:jci_app/features/Home/data/model/EvenetOfTheWeekModel.dart';

import 'package:jci_app/features/Home/data/model/EventModel.dart';
import 'package:http/http.dart' as http;
import 'package:jci_app/features/Home/data/model/EventOtheMonthModel.dart';

import '../../../../../core/error/Exception.dart';
abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEvents();
  Future<EventModel> getEventById(String id);
  Future<List<EventOftheWeekModel>> getEventsOfTheWeek();
  Future<List<EventOftheMonthModel>> getEventsOfTheMonth();

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
  Future<EventModel> getEventById(String id) {
    // TODO: implement getEventById
    throw UnimplementedError();
  }

  @override
  Future<List<EventOftheMonthModel>> getEventsOfTheMonth() async{
    final response =  await client.get(
      Uri.parse(getEventByMonth),
      headers: {"Content-Type": "application/json"},
    );
print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('events')) {
        final List<EventOftheMonthModel> eventModels = (decodedJson['events'] as List)
            .map<EventOftheMonthModel>((jsonEventModel) =>
            EventOftheMonthModel.fromJson(jsonEventModel))
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
  Future<List<EventOftheWeekModel>> getEventsOfTheWeek()async  {
    final response = await client.get(
      Uri.parse(getEventByWeek),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('events')) {
        final List<EventOftheWeekModel> eventModels = (decodedJson['events'] as List)
            .map<EventOftheWeekModel>((jsonEventModel) =>
            EventOftheWeekModel.fromJson(jsonEventModel))
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