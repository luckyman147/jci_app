import 'package:jci_app/features/Home/domain/entities/Activitys/Activity.dart';

import '../../domain/entities/Activitys/ActivityBasics.dart';
import '../../domain/entities/Activitys/ActivitySettings.dart';
import '../../domain/entities/Activitys/OnlineSettings.dart';
import '../../domain/entities/Activitys/ParicipationStatus.dart';

class ActivityModel extends Activity {
  ActivityModel({
    required super.activityBasics,
    required super.settings,
    required super.online,
    required super.participation,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activityBasics: ActivityBasics(
        id: json['id'] ?? json['_id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        activityBeginDate: json['ActivityBeginDate'] != null
            ? DateTime.parse(json['ActivityBeginDate'])
            : json['ActivityBegindate'] != null
            ? DateTime.parse(json['ActivityBegindate'])
            : DateTime.now(),
        activityEndDate: json['ActivityEndDate'] != null
            ? DateTime.parse(json['ActivityEndDate'])
            : json['ActivityEnddate'] != null
            ? DateTime.parse(json['ActivityEnddate'])
            : DateTime.now(),
        activityAdress: json['ActivityAdress'] ?? '',
        coverImages: (json['CoverImages'] ?? json['coverImages'] ?? [])
            .cast<String>(),
      ),
      settings: ActivitySettings(
        activityPoints: json['ActivityPoints'] ?? 0,

        isPaid: json['IsPaid'] ?? false,
        price: json['price'] ?? 0,
        isPublic: json['IsPublic'] ?? false,
       categoryIds:  (json['categorieId'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      ),
      online: OnlineSettings(
        isOnline: json['isOnline'] ?? false,
        googleMeetLink: json['googleMeetLink'] ?? '',
      ),
      participation:  ParticipationStatus(tempPart: false,
        participants: (json['Participants'] ??
            json['participants'] ??
            <dynamic>[])
            .map<String>((e) => e.toString())
            .toList(),
        isPart: json['IsPart'] ?? false,


      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...activityBasics.toJson(),
      ...settings.toJson(),
      ...online.toJson(),
      ...participation.toJson(),
    };
  }
}
