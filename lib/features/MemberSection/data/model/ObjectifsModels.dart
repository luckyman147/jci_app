
import '../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';
import '../../domain/entity/ActionDetails.dart';
import '../../domain/entity/Objectif.dart';

class ObjectifModel extends Objectif{
  ObjectifModel({required super.id,
    required super.difficulty,
    required super.points,
    required super.groupObjectif,
    required super.objectifActionType,
    required super.privacy,
    required super.cible,
    required super.feature,
    required super.target});
  // Convert Objectif to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "difficulty":  difficulty?.name,
      'points': points,
      'groupObjectif': groupObjectif.name,
      'objectifActionType': objectifActionType.name,
      'privacy': privacy?.name,
      'cible': cible.map((e) => e.name).toList(),
      'feature': feature.name,
      'target': target,
    };
  }


  // Create Objectif from JSON
  factory ObjectifModel.fromJson(Map<String, dynamic> json) {
    return ObjectifModel(
      id: json['id'],
      difficulty: json['difficulty']!=null? ObjectifDifficulty.values.firstWhere((e) => e.name == json['difficulty']):null,
      points: json['points'],
      groupObjectif: GroupObjectif.values.firstWhere((e) => e.name == json['groupObjectif']),
      objectifActionType: ObjectifActionType.values.firstWhere((e) => e.name == json['objectifActionType']),
      privacy: json['privacy'] != null ? PrivacyType.values.firstWhere((e) => e.name == json['privacy']) : null,
      cible: (json['cible'] as List).map((e) => CibleType.values.firstWhere((c) => c.name == e)).toList(),
      feature: FeaturesType.values.firstWhere((e) => e.name == json['feature']),
      target: json['target'],


    );
  }


  // Create ObjectifModel from Objectif entity
  factory ObjectifModel.fromEntity(Objectif entity) {
    return ObjectifModel(
      id: entity.id,
      difficulty: entity.difficulty,
      points: entity.points,
      groupObjectif: entity.groupObjectif,
      objectifActionType: entity.objectifActionType,
      privacy: entity.privacy,
      cible: entity.cible,
      feature: entity.feature,
      target: entity.target,);
  }
}
class  UserObjectifsModel extends UserObjectif{
  UserObjectifsModel(super.isCompleted, super.assignedAt, {required super.objectifId,required super.currentProgress});
  Map<String, dynamic> toJson() {
    return {
      'assignedAt': assignedAt,
      "isCompleted":isCompleted,
      'objectifId': objectifId, // Convert Objectif to JSON
      'currentProgress': currentProgress,
    };
  }
  //copywioth
  UserObjectifsModel copyWith({
    int? progress,
    bool? completed,
  }) {
    return UserObjectifsModel( completed??this.isCompleted,assignedAt,


      currentProgress: progress ?? this.currentProgress,

      objectifId: this.objectifId,
    );
  }

  // Create LineObjectif from JSON
  factory UserObjectifsModel.fromJson(Map<String, dynamic> json) {
    return UserObjectifsModel(
      json["isCompleted"],
      json["assignedAt"],
      objectifId: json["objectifId"], // Convert JSON to Objectif
      currentProgress: json['currentProgress'],
    );
  }
}