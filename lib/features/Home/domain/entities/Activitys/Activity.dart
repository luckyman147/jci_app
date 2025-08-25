import 'package:equatable/equatable.dart';
import 'ActivityBasics.dart';
import 'ActivitySettings.dart';
import 'OnlineSettings.dart';
import 'ParicipationStatus.dart';
import 'Place.dart';

class Activity extends Equatable {
  final ActivityBasics activityBasics;
  final ActivitySettings settings;
  final OnlineSettings online;
  final ParticipationStatus participation;
  final String type ;
  const Activity({
    this.type = "Event",
    required this.activityBasics,
    required this.settings,
    required this.online,
    required this.participation,
  });

  /// Factory to build from JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityBasics: ActivityBasics.fromJson(json),
      settings: ActivitySettings.fromJson(json),
      online: OnlineSettings.fromJson(json),
      participation: ParticipationStatus.fromJson(json),
    );
  }

  /// Build from images-only data (used in some places)
  factory Activity.fromImages(Map<String, dynamic> data) {
    return Activity.fromJson(data);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      ...activityBasics.toJson(),
      ...settings.toJson(),
      ...online.toJson(),
      ...participation.toJson(),
      'type': type, // Include type in JSON
    };
  }

  /// Copy with updated participants
  Activity copyWithParticipants(List<String> participants) {
    return Activity(
      activityBasics: activityBasics,
      settings: settings,
      online: online,
      participation: participation.copyWith(participants: participants),
    );
  }

  /// Dummy Activity for testing
  factory Activity.test() {
    return Activity(
      activityBasics: ActivityBasics(
        id: "id",
        name: "",
        description: "description",
        activityBeginDate: DateTime.now(),
        activityEndDate: DateTime.now(),
        activityAdress: "descripotion",
        coverImages: const [],
      ),
      settings: ActivitySettings(
        activityPoints: 2,
     
        isPaid: false,
        price: 1,
        isPublic: false, categoryIds: [],
    
      ),
      online: OnlineSettings(
        isOnline: false,
        googleMeetLink: "",
      ),
      participation:  ParticipationStatus(tempPart: false, participants: [], isPart: false),
    );
  }

  @override
  List<Object?> get props => [activityBasics, settings, online, participation];
}
