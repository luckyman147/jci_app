import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/env/urls.dart';

import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/verification.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/datasources/activities/ActivityRemote.dart';
import 'package:jci_app/features/Home/data/model/CommentModel.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/MeetingModel.dart';
import 'package:jci_app/features/Home/domain/enums/ParticipantWithEvents.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class MeetingRemoteDataSource {
  Future<List<MeetingModel>> getAllMeetings();
  Future<MeetingModel> getMeetingById(String id);

  Future<MeetingModel> createMeeting(MeetingModel Meeting);

  Future<Unit> updateMeeting(MeetingModel Meeting);
  Future<Unit> deleteMeeting(String id);

  Future<Unit> leaveMeeting(String id);
  Future<Unit> participateMeeting(String id);
}

class MeetingRemoteDataSourceImpl implements MeetingRemoteDataSource {
  final FirebaseFirestore firabaseFireStore;
  final Logger logger;
  final ActivityRemoteDataSource activityRemoteDataSource;

  MeetingRemoteDataSourceImpl(this.logger, this.activityRemoteDataSource,
      {required this.firabaseFireStore});

  ///Create a new meeting
  ///@param Meeting
  ///@return Unit
  @override
  Future<MeetingModel> createMeeting(MeetingModel Meeting) async {
    final activitiesCollection = firabaseFireStore.collection('activities');

    try {
      await FirebaseMessaging.instance.subscribeToTopic("all_users");
      // Log the beginning of the addMeeting process
      logger.i("Starting the process to add a new meeting.");

      // Create the main activity document
      DocumentReference activityDocRef =
          await activitiesCollection.add(Meeting.toJson());
      final documentId = activityDocRef.id;

      // Update the document with the generated document ID
      await activityDocRef.update({'id': documentId});
      logger.i("Activity document updated with the generated ID.");

      return MeetingModel.fromJson(
          (await activityDocRef.get()).data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        logger.e(
            "User does not have permission to create documents in this collection.");
        throw UnauthorizedException();
      } else if (e.code == 'unavailable') {
        logger.e("The server is unavailable. Please try again later.");
        throw NotVerifiedException();
      } else {
        logger.e("An error occurred while adding the meeting: $e");
        throw ExpiredException();
      }
    } catch (e) {
      logger.e("An error occurred while adding the meeting: $e");
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteMeeting(String id) async {
    final activitiesCollection = firabaseFireStore.collection('activities');

    try {
      // Delete the meeting document
      await activitiesCollection.doc(id).delete();
      logger.i("Successfully deleted meeting with ID: $id");
      return Future.value(unit);
    } catch (e) {
      logger.e("Error deleting meeting with ID $id: $e");
      throw NotFoundException();
    }
  }

  @override
  Future<List<MeetingModel>> getAllMeetings() async {
    final activitiesCollection = firabaseFireStore.collection('activities');

    try {
      // Get all meetings in the activities collection
      final snapshot = await activitiesCollection
          .where('type', isEqualTo: "Meeting")
          .orderBy('ActivityEndDate', descending: true)
          .get();
      Logger().i(snapshot);
      final meetings = snapshot.docs.map((doc) {
        final data = doc.data();
        Logger().i(data);

        return MeetingModel.fromJson(
            data); // Assuming you have a fromJson method in your Meeting class
      }).toList();

      logger.i("Successfully fetched all meetings.");
      return meetings;
    } catch (e) {
      logger.e("Error fetching meetings: $e");
      throw ServerException();
    }
  }

  @override
  Future<MeetingModel> getMeetingById(String id) async {
    final activitiesCollection = firabaseFireStore.collection('activities');

    try {
      // Get the document by its ID
      final docSnapshot = await activitiesCollection.doc(id).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;

        return MeetingModel.fromJson(
            data); // Assuming you have a fromJson method in your Meeting class
      } else {
        logger.i("Meeting with ID $id not found.");
        throw NotFoundException();
      }
    } catch (e) {
      logger.e("Error fetching meeting by ID: $e");
      throw ServerException();
    }
  }

  @override
  Future<Unit> leaveMeeting(String id) async {
    return activityRemoteDataSource.ParticiActionActivity(
        id, PaticipantWithEventsAction.removeParticipantFromEvent);
  }

  @override
  Future<Unit> participateMeeting(String id) async {
    return activityRemoteDataSource.ParticiActionActivity(
        id, PaticipantWithEventsAction.addParticipantToEvent);
  }

  @override
  Future<Unit> updateMeeting(MeetingModel Meeting) async {
    final activitiesCollection = firabaseFireStore.collection('activities');

    try {
      logger.i("Starting the process to update meeting with ID: ${Meeting.activityBasics.id}");
      // Update the meeting document with new data
      await activitiesCollection.doc(Meeting.activityBasics.id).update(Meeting.toJson());
      logger.i("Successfully updated meeting with ID: ");
      return Future.value(unit);
    } catch (e) {
      logger.e("Error updating meeting with ID : $e");
      throw ServerException();
    }
  }
}
