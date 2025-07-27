import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/AgendaModel.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/Activitys/ActivityBasics.dart';
import '../../../domain/entities/Activitys/ActivitySettings.dart';
import '../../../domain/entities/Activitys/OnlineSettings.dart';
import '../../../domain/entities/Activitys/ParicipationStatus.dart';
import '../../../domain/entities/Meeting.dart';

import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/Activitys/Activity.dart';

class MeetingModel extends Meeting {

  MeetingModel({
    required super.director,
    required super.agenda,
    required super.activityBasics,
    required super.settings,
    required super.online,
    required super.participation,
  });

  // Factory constructor from Meeting Entity
  factory MeetingModel.fromEntities({required Meeting meeting, String? link}) {
    return MeetingModel(
      director: meeting.director,
      agenda: meeting.agenda,
      activityBasics: meeting.activityBasics,
      settings: meeting.settings,
      online: meeting.online,
      participation: meeting.participation,
    );
  }

  // Factory constructor from JSON
  factory MeetingModel.fromJson(Map<String, dynamic> json, {bool isDecode = false}) {
    return MeetingModel(
      director: UserModel.fromJson(json['director'],isDecode), // Assuming UserModel handles the conversion
      agenda: json['agenda'],
      activityBasics: ActivityBasics.fromJson(json['activityBasics']),
      settings: ActivitySettings.fromJson(json['settings']),
      online: OnlineSettings.fromJson(json['online']),
      participation: ParticipationStatus.fromJson(json['participation']),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson({bool isDecode = false}) {
    return {
      'director': UserModel.fromEntity(director).toJson(isDecode), // Assuming UserModel has toJson method
      'agenda': agenda,
      'activityBasics': activityBasics.toJson(),
      'settings': settings.toJson(),
      'online': online.toJson(),
      'participation': participation.toJson(),
    };
  }

  // Convert from Activity to MeetingModel
  MeetingModel fromActivity(Activity activity) {
    return MeetingModel(
      director: (activity as Meeting).director,
      agenda: activity.agenda,
      activityBasics: activity.activityBasics,
      settings: activity.settings,
      online: activity.online,
      participation: activity.participation,
    );
  }

  // Copy method with new participants list
  MeetingModel copywith(List<String> activitiesParticipants) {
    return MeetingModel(
      director: director,
      agenda: agenda,
      activityBasics: activityBasics, // Assuming copyWith method exists in ActivityBasics
      settings: settings,
      online: online,
      participation: participation.copyWith(participants: activitiesParticipants), // Assuming copyWith method exists in ParticipationStatus
    );
  }
}

