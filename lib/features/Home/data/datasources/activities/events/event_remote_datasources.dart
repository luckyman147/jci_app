import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

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
import '../../../../domain/enums/ParticipantWithEvents.dart';



abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEvents();
  Future<EventModel> getEventById(String id);

  Future<List<EventModel>> getEventsOfTheMonth();
  Future<List<ActivityModel>> GetactivityByName(String name,activity act);
  Future<EventModel> createEvent(EventModel event);
  Future<Unit> updateEvent(EventModel event);
  Future<Unit> deleteEvent(String id);


  Future<Unit> leaveEvent(String id);
  Future<Unit> participateEvent(String id);

}

class EventRemoteDataSourceImpl implements EventRemoteDataSource{
  final FirebaseFirestore firabaseFireStore;
  final Logger logger;

  final FirebaseImageUploader firebaseImageUploader ;

  EventRemoteDataSourceImpl(this.firebaseImageUploader, {required this.firabaseFireStore,required this.logger});
  /// This function is used to create an event
  /// It takes an event object as a parameter
  /// It returns a unit
  /// It throws a WrongCredentialsException if the status code is 400
  /// It throws a ServerException if the status code is not 200
  /// It throws a ServerException if the status code is not 400
  /// It throws a ServerException if the status code is not 204
  @override
  Future<EventModel> createEvent(EventModel event)async  {
    final activitiesCollection = firabaseFireStore.collection('activities');

    try {
      await FirebaseMessaging.instance.subscribeToTopic("all_users");
    // Log the beginning of the addMeeting process
    logger.i("Starting the process to add a new event.");
 final images=  await   firebaseImageUploader.uploadImagesToFirebase(event.CoverImages);
 logger.i("Images uploaded successfully");
    // Create the main activity document
    DocumentReference activityDocRef = await activitiesCollection.add(EventModel.setImages(event: event, images: images).toJson());
    final documentId = activityDocRef.id;
    logger.i("Activity document created successfully with ID: $documentId");


    // Update the document with the generated document ID
    await activityDocRef.update({'id': documentId});
    logger.i("Activity document updated with the generated ID.");

    // return the document event
    return EventModel.fromJson((await activityDocRef.get()).data() as Map<String, dynamic>);



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
  Future<Unit> deleteEvent(String id)async {
    try {
      await firabaseFireStore.collection('activities').doc(id).delete();
      logger.i("Event deleted successfully with ID: $id");
       return Future.value(unit);
    }
    on FirebaseException catch (e) {
      logger.e("An error occurred while deleting the event: $e");
      throw handleErrors(e);
    }
    catch (e) {
      logger.e("An error occurred while deleting the event: $e");
      throw ServerException();
    }
  }
  /// This function is used to get all events
  /// It returns a list of events
  /// It throws a NotFoundException if the document does not exist
  /// It throws a ServerException if there is an error

  @override
  Future<List<EventModel>> getAllEvents()async  {
    try {
      QuerySnapshot snapshot = await firabaseFireStore.collection('activities').where('type',isEqualTo: 'Event').
        orderBy('ActivityEndDate', descending: true).
      get();

      List<EventModel> events = snapshot.docs.map((doc) {
        return EventModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return events;
    }
    on FirebaseException catch (e) {
      logger.e("An error occurred while fetching events: $e");
      return [];
    }
    catch (e) {
      logger.e("Error fetching events: $e");
      return [];
    }
  }

  @override
  Future<EventModel> getEventById(String id)async {
    try {
      DocumentSnapshot doc = await firabaseFireStore.collection('activities').doc(id).get();

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
  Future<List<EventModel>> getEventsOfTheMonth() async{
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

    try {
      QuerySnapshot snapshot = await firabaseFireStore.collection('activities')
          .where('ActivityBeginDate', isLessThan: firstDayOfNextMonth) // Starts before next month
          .where('ActivityEndDate', isGreaterThanOrEqualTo: firstDayOfMonth)
      .where('type',isEqualTo: 'Event')
      // Ends after or on the first day of the month
          .get();

      List<EventModel> events = snapshot.docs.map((doc) {
        return EventModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return events;
    } 
    on FirebaseException catch (e) {
      logger.e("An error occurred while fetching events: $e");
      return [];
    }
    catch (e) {
      logger.e("Error fetching events: $e");
      return [];
    }
  }
  

  @override
  Future<Unit> leaveEvent(String id)async  {
    return ParticiActionActivity(id,PaticipantWithEventsAction.removeParticipantFromEvent );


  }

  @override
  Future<Unit> participateEvent(String id)async {
    return ParticiActionActivity(id,PaticipantWithEventsAction.addParticipantToEvent );


  }

  @override
  Future<Unit> updateEvent(EventModel event) async {
    try {
      logger.i("Updating event with ID: ${event.id}");
      final images=  await   firebaseImageUploader.uploadImagesToFirebase(event.CoverImages);
      logger.i("Images uploaded successfully");
      // Create the main activity document

      await firabaseFireStore.collection('activities').doc(event.id).update(EventModel.setImages(event: event, images: images).toJson());
      logger.i("Event updated successfully with ID: ${event.id}");
      return Future.value(unit);
    }
    on FirebaseException catch (e) {
      logger.e("An error occurred while updating the event: $e");
      throw handleErrors(e);
    }
    catch (e) {
      logger.e("An error occurred while updating the event: $e");
      throw ServerException();
    }
  }

  @override
  Future<List<ActivityModel>> GetactivityByName(String name, activity act)async {
    try {
      logger.i("Fetching events by name: $name");
      QuerySnapshot snapshot = await firabaseFireStore.collection('activities')
          .where('name', isEqualTo: name)
          .where("name", isLessThan: '$name\uf8ff')
           // .where('type',isEqualTo: act.name.replaceAll('s', ''))
          .get();

      List<ActivityModel> events = snapshot.docs.map((doc) {
        return ActivityModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return events;
    }
    on FirebaseException catch (e) {
      logger.e("An error occurred while fetching events by name: $e");
      return [];
    }
    catch (e) {
      logger.e("Error fetching events by name: $e");
      return [];
    }

  }


}