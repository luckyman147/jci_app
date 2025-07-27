import 'package:jci_app/core/PrimitiveUser/User.dart';
import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/Activitys/Activity.dart';
import '../../../domain/entities/Activity/event/Event.dart';
import '../../../domain/entities/Activitys/ActivityBasics.dart';
import '../../../domain/entities/Activitys/ActivitySettings.dart';
import '../../../domain/entities/Activitys/OnlineSettings.dart';
import '../../../domain/entities/Activitys/ParicipationStatus.dart';

class EventModel extends Event {
  EventModel({
    required super.leaderName,
    required super.registrationDeadline,
    required super.activityBasics,
    required super.settings,
    required super.online,
    required super.participation,
  });

  // Factory constructor from Event Entity
  factory EventModel.fromEntity({required Event event, String? link}) {
    return EventModel(
      leaderName: event.leaderName,
      registrationDeadline: event.registrationDeadline,
      activityBasics: event.activityBasics,
      settings: event.settings,
      online: event.online,
      participation: event.participation,
    );
  }

  // Factory constructor from JSON
  factory EventModel.fromJson(Map<String, dynamic> json, {bool isDecode = false}) {
    return EventModel(
      leaderName: UserModel.fromJson(json['leaderName'],true), // Assuming UserModel handles the conversion
      registrationDeadline: DateTime.parse(json['registrationDeadline']),
      activityBasics: ActivityBasics.fromJson(json['activityBasics']),
      settings: ActivitySettings.fromJson(json['settings']),
      online: OnlineSettings.fromJson(json['online']),
      participation: ParticipationStatus.fromJson(json['participation']),
    );
  }

  // Set Images
  factory EventModel.setImages({required EventModel event, required List<String> images}) {
    return EventModel(
      leaderName: event.leaderName,
      registrationDeadline: event.registrationDeadline,
      activityBasics: event.activityBasics.copyWith(coverImages: images), // Assuming copyWith method exists in ActivityBasics
      settings: event.settings,
      online: event.online,
      participation: event.participation,
    );
  }

  // Set Participants
  factory EventModel.setParticipants({required EventModel event, required List<String> participants}) {
    return EventModel(
      leaderName: event.leaderName,
      registrationDeadline: event.registrationDeadline,
      activityBasics: event.activityBasics,
      settings: event.settings,
      online: event.online,
      participation: event.participation.copyWith(participants: participants), // Assuming copyWith method exists in ParticipationStatus
    );
  }
 factory EventModel.setId({required EventModel event, required String id}) {
    return EventModel(
      leaderName: event.leaderName,
      registrationDeadline: event.registrationDeadline,
      activityBasics: event.activityBasics.copyWith(id: id),
      settings: event.settings,
      online: event.online,
      participation: event.participation
      , // Assuming copyWith method exists in ParticipationStatus
    );
  }

  // Set isPart
  factory EventModel.setIsPart({required EventModel event, required bool isPart}) {
    return EventModel(
      leaderName: event.leaderName,
      registrationDeadline: event.registrationDeadline,
      activityBasics: event.activityBasics,
      settings: event.settings,
      online: event.online,
      participation: event.participation.copyWith(isPart: isPart), // Assuming copyWith method exists in ParticipationStatus
    );
  }

  // Convert from Activity to EventModel
  EventModel fromActivity(Activity activity) {
    return EventModel(
      leaderName: (activity as Event).leaderName,
      registrationDeadline: activity.registrationDeadline,
      activityBasics: activity.activityBasics,
      settings: activity.settings,
      online: activity.online,
      participation: activity.participation,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'leaderName': UserModel.fromEntity(leaderName).toJson(true), // Assuming UserModel has toJson method
      'registrationDeadline': registrationDeadline.toIso8601String(),
      'activityBasics': activityBasics.toJson(),
      'settings': settings.toJson(),
      'online': online.toJson(),
      'type':type,
      'participation': participation.toJson(),
    };
  }
// to event
  Event toEvent() {
    return Event(
      leaderName: leaderName,
      registrationDeadline: registrationDeadline,
      activityBasics: activityBasics,
      settings: settings,
      online: online,
      participation: participation,
    );
  }
  // Copy method with new participants list
  EventModel copyWith(List<String> activitiesParticipants) {
    return EventModel(
      leaderName: leaderName,
      registrationDeadline: registrationDeadline,
      activityBasics: activityBasics, // Assuming copyWith method exists in ActivityBasics
      settings: settings,
      online: online,
      participation: participation.copyWith(participants: activitiesParticipants), // Assuming copyWith method exists in ParticipationStatus
    );
  }
}
