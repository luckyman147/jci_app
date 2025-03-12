import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../../../core/PrimitiveUser/User.dart';
import '../../../../../../../core/error/Failure.dart';
import '../../../../../../../core/usescases/usecase.dart';
import '../../../../../domain/Dtos/PArticipantParam.dart';
import '../../../../../domain/entities/ParticipantDetailsParam.dart';
import '../../../../../domain/enums/AttendeceEmum.dart';


class ParticipantsBlocFunctions{



// Helper method to check if the status is already the same
 static  bool isStatusAlreadyUpdated(Attendance updatedStatus, String memberId,ParticpantsState state ) {
    // Check if the member is already in the correct list (Absent or Present)
    return (updatedStatus == Attendance.Absent && state.AbsentList.any((p) => p.partipantId == memberId)) ||
        (updatedStatus == Attendance.Present && state.PresentList.any((p) => p.partipantId == memberId));
  }

// Helper method to update lists based on status
  static List<ParticipantsParams> updateList(List<ParticipantsParams> currentList, ParticipantsParams updatedParticipant, [bool addToList = true]) {
    // Remove participant from the list if present
    final updatedList = List<ParticipantsParams>.from(currentList);
    updatedList.removeWhere((participant) => participant.partipantId == updatedParticipant.partipantId);

    // Add participant to the list if necessary
    if (addToList) {
      updatedList.add(updatedParticipant);
    }

    return updatedList;
  }

// Fetch all members


// Categorize participants based on attendance
static  CategorizedParticipants categorizeParticipants({
    required List<User> allMembers,
    required List<ParticipantDetailsParam> presenceList,
    required LoadIsParttipatedList event,
  }) {
    final presenceMap = {
      for (var presence in presenceList) presence.participant: presence.attendance,
    };

    List<ParticipantsParams> allMembersListParam = [];
    List<ParticipantsParams> presentListParam = [];
    List<ParticipantsParams> joinedList = [];
    List<ParticipantsParams> absentList = [];
Logger().wtf('allMembers ${presenceList.map((e) => e.attendance.name)}');
    if (presenceList.isEmpty) {
      // Treat all members as absent
      for (var userInfo in allMembers) {
        ParticipantsParams participant = CreateParticpantObject(event, userInfo,Attendance.Pending);
        allMembersListParam.add(participant);
      }
    } else {
      // Classify members based on their attendance status
      for (var userInfo in allMembers) {
        Logger().wtf('allMembers ${userInfo.id}');
        Logger().wtf('map $presenceMap');

        final attendanceStatus = presenceMap[userInfo.id] ?? Attendance.Pending;
        ParticipantsParams participant = CreateParticpantObject(event, userInfo, attendanceStatus);

        if (attendanceStatus == Attendance.Present) {
          presentListParam.add(participant);
        } else if (attendanceStatus == Attendance.Absent) {
          absentList.add(participant);
        } else {
          allMembersListParam.add(participant);
        }

        if (event.participants.contains(participant.partipantId)) {
          joinedList.add(participant);
        }

      }
    }



    return CategorizedParticipants(
      allMembersListParam: allMembersListParam,
      presentListParam: presentListParam,
      joinedList: joinedList,
      absentList: absentList,
    );
  }




static  ParticipantsParams CreateParticpantObject(LoadIsParttipatedList event, User userInfo,Attendance attendance) {

    ParticipantsParams PartiObject = ParticipantsParams(
      event.activityId,
      partcipantImage: userInfo.Images.isNotEmpty?userInfo.Images[0]:'',
      partipantId: userInfo.id!,
      partcipantName: "${userInfo.firstName} ${userInfo.lastName}",
      status: attendance,

    );
    return PartiObject;
  }









}