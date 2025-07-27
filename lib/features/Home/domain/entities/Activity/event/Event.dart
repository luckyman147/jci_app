import 'package:equatable/equatable.dart';
import 'package:jci_app/core/PrimitiveUser/User.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/Activity.dart';

import '../../Activitys/ActivityBasics.dart';
import '../../Activitys/ActivitySettings.dart';
import '../../Activitys/OnlineSettings.dart';
import '../../Activitys/ParicipationStatus.dart';

class Event extends Activity {
  final User leaderName;
  final DateTime registrationDeadline;
  final String type = "Event";

  const Event({
    required this.leaderName,
    required this.registrationDeadline,
    required super.activityBasics,
    required super.settings,
    required super.online,
    required super.participation,
  });

  /// Factory constructor from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      leaderName: json['LeaderName'],
      registrationDeadline: json['registrationDeadline'] != null
          ? DateTime.parse(json['registrationDeadline'])
          : DateTime.now(),
      activityBasics: ActivityBasics.fromJson(json),
      settings: ActivitySettings.fromJson(json),
      online: OnlineSettings.fromJson(json),
      participation: ParticipationStatus.fromJson(json),
    );
  }



  /// Static dummy test
  static Event get eventTest => Event(
    leaderName: User.UserTest(),
    registrationDeadline: DateTime.now(),
    activityBasics: ActivityBasics(
      id: '',
      name: "Choose the Event",
      description: "hola",
      activityBeginDate: DateTime.now(),
      activityEndDate: DateTime.now(),
      activityAdress: "hhhh",
      coverImages: const [],
    ),
    settings: ActivitySettings(
      activityPoints: 2,

      isPaid: false,
      price: 0,
      isPublic: false, categoryIds: [],

    ),
    online: OnlineSettings(isOnline: false, googleMeetLink: ""),
    participation: ParticipationStatus(tempPart: false, participants: [], isPart: false),
  );

  @override
  List<Object?> get props => [
    leaderName,
    registrationDeadline,
    activityBasics,
    settings,
    online,
    participation,
  ];
}
