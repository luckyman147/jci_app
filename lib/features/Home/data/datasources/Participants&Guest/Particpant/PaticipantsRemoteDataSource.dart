import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/domain/enums/AttendeceEmum.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../../core/PrimitiveUser/UserModel.dart';
import '../../../../../../core/config/env/urls.dart';
import '../../../../../../core/error/Exception.dart';
import '../../../../domain/entities/ParticipantDetailsParam.dart';
import "package:http/http.dart" as http;

abstract class ParticipantsRemoteDataSource {
  Future<List<UserModel>> getAllParticipants();

  Future<Unit> checkAbsence(String activityId, String memberId, String status);
  Future<Unit> updateMembersAttendance({
    required String activityId,
    required List<ParticipantDetailsParam> members,
  });
  Future<List<ParticipantDetailsParam>> getAllParticipantsWithStatusOfActivity(
      String activityId);

  Future<Unit> sendReminder(
      String activityName, String activityBeginDate, String location);
}

class ParticipantsRemoteDataSourceImpl implements ParticipantsRemoteDataSource {
  final Logger logger;
  final FirebaseFirestore firabaseFireStore;
  final Store store;
  ParticipantsRemoteDataSourceImpl(this.store,
      {required this.logger, required this.firabaseFireStore});
  @override
  Future<Unit> checkAbsence(
      String activityId, String memberId, String status) async {
    ///This function is used to update the absence of a member in an activity
    ///It takes the activityId, memberId and status of the member
    ///It returns a unit if the operation is successful
    ///It returns a failure if the operation is not successful
    try {
      // Reference to the activity document
      final activityDoc =
          FirebaseFirestore.instance.collection('activities').doc(activityId);

      // Reference to the participants subcollection
      final participantsCollection = activityDoc.collection('Participants');

      // Query the participant by ID
      final participantQuery = await participantsCollection
          .where('memberId', isEqualTo: memberId)
          .get();

      if (participantQuery.docs.isNotEmpty) {
        // If the participant exists, update their attendance
        final participantDoc = participantQuery.docs.first;
        await participantsCollection.doc(participantDoc.id).update({
          'attendance': status,

          // Update attendance field
        });

        logger.i("Attendance updated successfully for member $memberId");
      } else {
        // If participant not found, add a new entry with the provided attendance
        await participantsCollection
            .add({'memberId': memberId, 'attendance': status});

        logger.i(
            "Participant added and attendance set to $status for member $memberId");
      }
      return unit;
    } catch (e) {
      logger.e("Error updating attendance: $e");
      throw Exception("Failed to update attendance");
    }
  }

  ///This function is used to get all the participants
  ///It returns a list of participants if the operation is successful
  ///It returns a failure if the operation is not successful
  ///It throws a Failure if an error occurs
  ///TODO: Add Pagination with page and limits

  @override
  Future<List<UserModel>> getAllParticipants() async {
    try {
      final activitiesCollection = firabaseFireStore.collection('users');
      final snapshot = await activitiesCollection.get();
      final List<UserModel> users = [];
      for (var element in snapshot.docs) {
        users.add(UserModel.fromJson(element.data(), true));
      }
      return users;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  ///This function is used to get all the participants of an activity
  ///It takes the activityId
  ///It returns a list of participants if the operation is successful
  ///It returns a failure if the operation is not successful
  ///It throws a Failure if an error occurs
  ///TODO: Add Pagination with page and limits
  ///
  @override
  Future<List<ParticipantDetailsParam>> getAllParticipantsWithStatusOfActivity(
      String activityId) async {
    try {
      final participantsCollection = firabaseFireStore
          .collection('activities')
          .doc(activityId)
          .collection('Participants');

      final snapshot = await participantsCollection.get();
      final List<ParticipantDetailsParam> participants = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        participants.add(ParticipantDetailsParam.fromMap(data));
      }

      return participants;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  ///This function is used to send a reminder to the participants of an activity
  ///It takes the activityName, activityBeginDate and location
  ///It returns a unit if the operation is successful
  ///It returns a failure if the operation is not successful
  ///It throws a Failure if an error occurs
  ///
  @override
  Future<Unit> sendReminder(
      String ActivityName, String ActivityBeginDate, String location) async {
    try {
      final id = await store.getUserId();

      final url =
          '${Urls.mainurl}/sendReminderToAllUsers?activityName=$ActivityName&activityBeginDate=$ActivityBeginDate&userId=$id&location=$location';

      final response = await http.post(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        return Future.value(unit);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  ///This function is used to update the attendance of multiple members in an activity
  ///It takes the activityId and a list of members
  ///It returns a unit if the operation is successful
  ///It returns a failure if the operation is not successful
  ///It throws a Failure if an error occurs
  ///
  @override
  Future<Unit> updateMembersAttendance(
      {required String activityId,
      required List<ParticipantDetailsParam> members}) async {
    try {
      // Reference to the activity document
      final activityDoc =
          FirebaseFirestore.instance.collection('activities').doc(activityId);

      // Reference to the participants subcollection
      final participantsCollection = activityDoc.collection('Participants');

      // Batch to perform multiple writes at once
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      // Iterate over each member and their attendance
      for (var member in members) {
        final memberId = member.participant;
        final newAttendance = member.attendance;

        // Query the participant by ID
        final participantQuery = await participantsCollection
            .where('memberId', isEqualTo: memberId)
            .get();

        if (participantQuery.docs.isNotEmpty) {
          // If the participant exists, update their attendance
          final participantDoc = participantQuery.docs.first;
          batch.update(participantsCollection.doc(participantDoc.id), {
            'attendance': newAttendance.name, // Update attendance field
          });
        } else {
          // If participant not found, add a new entry with the provided attendance
          final newDoc = participantsCollection.doc();
          batch.set(newDoc, {
            'memberId': memberId,
            'attendance': newAttendance.name, // Add attendance field
          });
        }
      }

      // Commit the batch write
      await batch.commit();

      logger.i("Attendance updated for all members in the list.");
      return unit;
    } catch (e) {
      logger.e("Error updating attendance for multiple members: $e");
      throw Exception("Failed to update attendance for multiple members");
    }
  }
}
