import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:jci_app/core/config/env/Constants.dart';

import 'package:jci_app/core/config/env/urls.dart';

import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/uploadImage.dart';
import 'package:jci_app/core/config/services/verification.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/datasources/activities/ActivityRemote.dart';
import 'package:jci_app/features/Home/data/model/ActivityModel.dart';
import 'package:jci_app/features/Home/data/model/events/EventModel.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import '../../../../../auth/AuthWidgetGlobal.dart';
import '../../../../domain/entities/Activitys/Place.dart';
import '../../../../domain/enums/ParticipantWithEvents.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEvents();
  Future<EventModel> getEventById(String id);
  Future< List<Place>> getPlacesByName(String name);
  Future< Place> getPlaceDetail(Place place);

  Future<List<EventModel>> getEventsOfTheMonth();
  Future<List<ActivityModel>> GetactivityByName(String name, activity act);
  Future<EventModel> createEvent(EventModel event);
  Future<Unit> updateEvent(EventModel event);
  Future<Unit> deleteEvent(String id);

  Future<Unit> leaveEvent(String id);
  Future<Unit> participateEvent(String id);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final FirebaseFirestore firabaseFireStore;
  final Logger logger;
  final ActivityRemoteDataSource activityRemoteDataSource;

  final FirebaseImageUploader firebaseImageUploader;

  EventRemoteDataSourceImpl(
      this.firebaseImageUploader, this.activityRemoteDataSource,
      {required this.firabaseFireStore, required this.logger});

  /// This function is used to create an event
  /// It takes an event object as a parameter
  /// It returns a unit
  /// It throws a WrongCredentialsException if the status code is 400
  /// It throws a ServerException if the status code is not 200
  /// It throws a ServerException if the status code is not 400
  /// It throws a ServerException if the status code is not 204
  @override
  Future<EventModel> createEvent(EventModel event) async {
    final activitiesCollection = firabaseFireStore.collection('activities');

    try {
      await FirebaseMessaging.instance.subscribeToTopic("all_users");
      // Log the beginning of the addMeeting process
      logger.i("Starting the process to add a new event.");
      logger.i("Starting the process to add a new ${event.activityBasics.coverImages}.");

      final images =
          await firebaseImageUploader.uploadImagesToFirebase(event.activityBasics.coverImages);
      logger.i("Images uploaded successfully");
      // Create the main activity document
      DocumentReference activityDocRef = await activitiesCollection
          .add(EventModel.setImages(event: event, images: images).toJson());
      final documentId = activityDocRef.id;
      logger.i("Activity document created successfully with ID: $documentId");

      // Update the document with the generated document ID
      await activityDocRef.update({'activityBasics.id': documentId});
      logger.i("Activity document updated with the generated ID.");

      // return the document event
      return EventModel.fromJson(
          (await activityDocRef.get()).data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      throw handleErrors(e);
    } catch (e) {
      logger.e("An error occurred while adding the meeting: $e");
      throw ServerException();
    }
  }

  /// This function is used to delete an event
  /// It takes an event id as a parameter
  /// It returns a unit
  /// It throws a NotFoundException if the document does not exist
  ///

  @override
  Future<Unit> deleteEvent(String id) async {
    try {
      await firabaseFireStore.collection('activities').doc(id).delete();
      logger.i("Event deleted successfully with ID: $id");
      return Future.value(unit);
    } on FirebaseException catch (e) {
      logger.e("An error occurred while deleting the event: $e");
      throw handleErrors(e);
    } catch (e) {
      logger.e("An error occurred while deleting the event: $e");
      throw ServerException();
    }
  }

  /// This function is used to get all events
  /// It returns a list of events
  /// It throws a NotFoundException if the document does not exist
  /// It throws a ServerException if there is an error

  @override
  Future<List<EventModel>> getAllEvents() async {
    try {
      QuerySnapshot snapshot = await firabaseFireStore
          .collection('activities')
          .where('type', isEqualTo: 'Event')
          .orderBy('activityBasics.activityEndDate', descending: true)
          .get();

      List<EventModel> events = snapshot.docs.map((doc) {
        return EventModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return events;
    } on FirebaseException catch (e) {
      logger.e("An error occurred while fetching events: $e");
      return [];
    } catch (e) {
      logger.e("Error fetching events: $e");
      return [];
    }
  }

  @override
  Future<EventModel> getEventById(String id) async {
    try {
      DocumentSnapshot doc =
          await firabaseFireStore.collection('activities').doc(id).get();

      if (doc.exists) {
        logger.i("Event retrieved successfully with ID: $id");
        return EventModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        logger.w("No event found with ID: $id");
        throw NotFoundException();
      }
    } on FirebaseException catch (e) {
      logger.e("An error occurred while retrieving the event: $e");
      throw handleErrors(e);
    } catch (e) {
      logger.e("An error occurred while retrieving the event: $e");
      throw Exception("Server error");
    }
  }

  @override
  Future<List<EventModel>> getEventsOfTheMonth() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

    try {
      QuerySnapshot snapshot = await firabaseFireStore
          .collection('activities')
          .where('activityBasics.activityBeginDate',
              isLessThan: firstDayOfNextMonth) // Starts before next month
          .where('activityBasics.activityEndDate', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('type', isEqualTo: 'Event')
          // Ends after or on the first day of the month
          .get();

      List<EventModel> events = snapshot.docs.map((doc) {
        return EventModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return events;
    } on FirebaseException catch (e) {
      logger.e("An error occurred while fetching events: $e");
      return [];
    } catch (e) {
      logger.e("Error fetching events: $e");
      return [];
    }
  }

  @override
  Future<Unit> leaveEvent(String id) async {
    return activityRemoteDataSource.ParticiActionActivity(
        id, PaticipantWithEventsAction.removeParticipantFromEvent);
  }

  @override
  Future<Unit> participateEvent(String id) async {
    return activityRemoteDataSource.ParticiActionActivity(
        id, PaticipantWithEventsAction.addParticipantToEvent);
  }

  @override
  Future<Unit> updateEvent(EventModel event) async {
    try {
      logger.i("Updating event with ID: ");
      final images =
          await firebaseImageUploader.uploadImagesToFirebase(event.activityBasics.coverImages);
      logger.i("Images uploaded successfully");
      // Create the main activity document

      await firabaseFireStore
          .collection('activities')
          .doc(event.activityBasics.id)
          .update(EventModel.setImages(event: event, images: images).toJson());
      logger.i("Event updated successfully with ID: ");
      return Future.value(unit);
    } on FirebaseException catch (e) {
      logger.e("An error occurred while updating the event: $e");
      throw handleErrors(e);
    } catch (e) {
      logger.e("An error occurred while updating the event: $e");
      throw ServerException();
    }
  }

  @override
  Future<List<ActivityModel>> GetactivityByName(
      String name, activity act) async {
    try {
      logger.i("Fetching events by name: $name");
      QuerySnapshot snapshot = await firabaseFireStore
          .collection('activities')
          .where('activityBasics.name', isEqualTo: name)
          .where("activityBasics.name", isLessThan: '$name\uf8ff')
          // .where('type',isEqualTo: act.name.replaceAll('s', ''))
          .get();

      List<ActivityModel> events = snapshot.docs.map((doc) {
        return ActivityModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return events;
    } on FirebaseException catch (e) {
      logger.e("An error occurred while fetching events by name: $e");
      return [];
    } catch (e) {
      logger.e("Error fetching events by name: $e");
      return [];
    }
  }

  @override
  Future<Place> getPlaceDetail(Place place) async{
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=${place.placeId}&key=${Constants.API_KEY}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['result'];

      return Place(
        name: result['name'],
        address: place.address,
        lat: result['geometry']['location']['lat'],
        lng: result['geometry']['location']['lng'],
        placeId: place.placeId,
      );
    } else {
      throw Exception("Failed to load place details");
    }
  }

  @override
  Future<List<Place>> getPlacesByName(String name)async {

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$name&key=${Constants.API_KEY}&types=geocode&language=en";
    try {
      logger.i("Fetching places by name: $name");
      final response = await http.get(Uri.parse(url));
logger.i("Response status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        logger.i("Response body: ${json['predictions']}");
        final predictions = json['predictions'] as List;


        return predictions
            .map((p) =>
            Place(
              name: p['structured_formatting']['main_text'] ?? '',
              address: p['structured_formatting']['secondary_text'] ?? '',
              lat: 0,
              lng: 0,
              placeId: p['place_id'],
            ))
            .toList();
      }
      else if (response.statusCode == 400) {
        logger.e("Bad request while fetching places by name: $name");
        throw WrongCredentialsException();
      } else {
        logger.e("Error fetching places by name: $name, Status code: ${response.statusCode}");
        throw ServerException();
      }
    } catch (e) {
      logger.e("Error fetching places by name: $e");
      throw ServerException();
    }
  }
}
