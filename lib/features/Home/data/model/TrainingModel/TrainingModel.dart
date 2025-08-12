import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:json_annotation/json_annotation.dart';


import '../../../domain/entities/Activitys/ActivityBasics.dart';
import '../../../domain/entities/Activitys/ActivitySettings.dart';
import '../../../domain/entities/Activitys/OnlineSettings.dart';
import '../../../domain/entities/Activitys/ParicipationStatus.dart';
import '../../../domain/entities/training.dart';

import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/Activitys/Activity.dart';

class TrainingModel extends Training {

  TrainingModel({
    required super.professeurName,
    required super.duration,
    required super.activityBasics,
    required super.settings,
    required super.online,
    super.type="Training",
    required super.participation,
  });

  // Factory constructor to create TrainingModel from Training entity
  factory TrainingModel.fromEntity(Training train) {
    return TrainingModel(
      professeurName: train.professeurName,
      duration: train.duration,
      activityBasics: train.activityBasics,
      settings: train.settings,
      online: train.online,
      participation: train.participation,
    );
  }

  // Factory constructor to set images for the training
  factory TrainingModel.SetImages(TrainingModel train, List<String> images) {
    return TrainingModel(
      professeurName: train.professeurName,
      duration: train.duration,
      activityBasics: train.activityBasics.copyWith(coverImages: images), // Assuming copyWith method exists
      settings: train.settings,
      online: train.online,
      participation: train.participation,
    );
  }

  // Factory constructor to create TrainingModel from JSON
  factory TrainingModel.fromJson(Map<String, dynamic> json, {bool isDecode = false}) {
    return TrainingModel(
      professeurName: (json['professeurName']), // Assuming UserModel handles the conversion
      duration: json['duration'],
      activityBasics: ActivityBasics.fromJson(json['activityBasics']),
      settings: ActivitySettings.fromJson(json['settings']),
      online: OnlineSettings.fromJson(json['online']),
      participation: ParticipationStatus.fromJson(json['participation']),
    );
  }

  // Convert from Activity to TrainingModel
  TrainingModel fromActivity(Activity acr) {
    return TrainingModel(
      professeurName: (acr as Training).professeurName,
      duration: acr.duration,
      activityBasics: acr.activityBasics,
      settings: acr.settings,
      online: acr.online,
      participation: acr.participation,
    );
  }

  // Convert the model to JSON
  Map<String, dynamic> toJson({bool isDecode = false}) {
    return {
      'professeurName': professeurName, // Assuming UserModel has toJson method
      'duration': duration,
      'activityBasics': activityBasics.toJson(),
      'settings': settings.toJson(),
      'online': online.toJson(),
      "type":type,
      'participation': participation.toJson(),
    };
  }

  // Copy method with updated participants list
  TrainingModel copywith(List<String> parts) {
    return TrainingModel(
      professeurName: professeurName,
      duration: duration,
      activityBasics: activityBasics, // Assuming copyWith exists in ActivityBasics
      settings: settings,
      online: online,
      participation: participation.copyWith(participants: parts), // Assuming copyWith exists in ParticipationStatus
    );
  }
}

