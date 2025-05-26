import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jci_app/core/config/env/urls.dart';

import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/uploadImage.dart';
import 'package:jci_app/core/config/services/verification.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/datasources/activities/ActivityRemote.dart';
import 'package:jci_app/features/Home/data/model/ActivityGuestsModel.dart';

import 'package:jci_app/features/Home/data/model/GuestModel.dart';
import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';

import '../../../../../auth/AuthWidgetGlobal.dart';
import '../../../../domain/enums/ParticipantWithEvents.dart';

abstract class TrainingRemoteDataSource {
  Future<List<TrainingModel>> getAllTraining();
  Future<TrainingModel> getTrainingById(String id);

  Future<List<TrainingModel>> getTrainingOfTheMonth();

  Future<TrainingModel> createTraining(TrainingModel Training);
  Future<Unit> updateTraining(TrainingModel Training);
  Future<Unit> deleteTraining(String id);

  Future<Unit> leaveTraining(String id);
  Future<Unit> participateTraining(String id);

  Future<Unit> checkAbsence(String activityId, String memberId, String status);

  Future<List<ParticipantDetailsParam>> getAllParticipants(String activityId);

  Future<Unit> sendReminder(String activityId);
}

class TrainingRemoteDataSourceImpl implements TrainingRemoteDataSource {
  final http.Client client;
  final Logger logger;
  final FirebaseFirestore firabaseFireStore;
  final FirebaseImageUploader firebaseImageUploader;
  final ActivityRemoteDataSource activityRemoteDataSource;
  TrainingRemoteDataSourceImpl(this.logger, this.firabaseFireStore,
      this.firebaseImageUploader, this.activityRemoteDataSource,
      {required this.client});
  @override
  Future<TrainingModel> createTraining(TrainingModel Training) async {
    final activitiesCollection = firabaseFireStore.collection('activities');

    try {
      await FirebaseMessaging.instance.subscribeToTopic("all_users");
      // Log the beginning of the addMeeting process
      logger.i("Starting the process to add a new event.");
      final images = await firebaseImageUploader
          .uploadImagesToFirebase(Training.CoverImages);
      logger.i("Images uploaded successfully");
      // Create the main activity document
      DocumentReference activityDocRef = await activitiesCollection
          .add(TrainingModel.SetImages(Training, images).toJson());
      final documentId = activityDocRef.id;
      logger.i("Activity document created successfully with ID: $documentId");

      // Update the document with the generated document ID
      await activityDocRef.update({'id': documentId});
      logger.i("Activity document updated with the generated ID.");

      // return the document event
      return TrainingModel.fromJson(
          (await activityDocRef.get()).data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      throw handleErrors(e);
    } catch (e) {
      logger.e("An error occurred while adding the meeting: $e");
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteTraining(String id) async {
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

  @override
  Future<List<TrainingModel>> getAllTraining() async {
    try {
      QuerySnapshot snapshot = await firabaseFireStore
          .collection('activities')
          .where('type', isEqualTo: 'Training')
          .orderBy('ActivityEndDate', descending: true)
          .get();

      List<TrainingModel> events = snapshot.docs.map((doc) {
        return TrainingModel.fromJson(doc.data() as Map<String, dynamic>);
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
  Future<TrainingModel> getTrainingById(String id) async {
    try {
      DocumentSnapshot doc =
          await firabaseFireStore.collection('activities').doc(id).get();

      if (doc.exists) {
        logger.i("Event retrieved successfully with ID: $id");
        return TrainingModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
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
  Future<List<TrainingModel>> getTrainingOfTheMonth() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

    try {
      QuerySnapshot snapshot = await firabaseFireStore
          .collection('activities')
          .where('ActivityBeginDate',
              isLessThan: firstDayOfNextMonth) // Starts before next month
          .where('ActivityEndDate', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('type', isEqualTo: 'Training')
          // Ends after or on the first day of the month
          .get();

      List<TrainingModel> events = snapshot.docs.map((doc) {
        return TrainingModel.fromJson(doc.data() as Map<String, dynamic>);
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
  Future<Unit> leaveTraining(String id) async {
    return activityRemoteDataSource.ParticiActionActivity(
        id, PaticipantWithEventsAction.removeParticipantFromEvent);
  }

  @override
  Future<Unit> participateTraining(String id) async {
    return activityRemoteDataSource.ParticiActionActivity(
        id, PaticipantWithEventsAction.addParticipantToEvent);
  }

  @override
  Future<Unit> updateTraining(TrainingModel Training) async {
    try {
      final images = await firebaseImageUploader
          .uploadImagesToFirebase(Training.CoverImages);
      logger.i("Images uploaded successfully");

      await firabaseFireStore
          .collection('activities')
          .doc(Training.id)
          .update(TrainingModel.SetImages(Training, images).toJson());
      logger.i("Event updated successfully with ID: ${Training.id}");
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
  Future<Unit> checkAbsence(
      String activityId, String memberId, String status) async {
    // final token = await getTokens();

    return client
        .patch(
      Uri.parse(Urls.CheckAbsence),
      headers: {
        "Content-Type": "application/json",
        //   "Authorization":'Bearer ${token[1]}'
      },
      body: json.encode(
          {"activityId": activityId, "memberId": memberId, "status": status}),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException();
      }
    });
  }

  @override
  Future<List<ParticipantDetailsParam>> getAllParticipants(String activityId) {
    return client.get(
      Uri.parse(Urls.getAllParticipants(activityId)),
      headers: {
        "Content-Type": "application/json",
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body);

        final List<ParticipantDetailsParam> members = decodedJson
            .map<ParticipantDetailsParam>((jsonMemberModel) =>
                ParticipantDetailsParam.fromMap(jsonMemberModel))
            .toList();
        return members;
      } else if (response.statusCode == 400) {
        throw EmptyDataException();
      } else {
        throw ServerException();
      }
    });
  }

  @override
  Future<Unit> sendReminder(String activityId) {
    return client.post(
      Uri.parse(Urls.SendReminderUrl(activityId)),
      headers: {
        "Content-Type": "application/json",
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException();
      }
    });
  }
}
