import 'package:jci_app/features/Teams/domain/entities/Team/TeamMeta.dart';
import 'package:jci_app/features/common/enums/PrivacyType.dart';

import '../../domain/entities/Project.dart';

class  ProjectModel extends Project{
  ProjectModel({required super.id,
    required super.name,
    required super.description,
    required super.privacy,
    required super.teamsInfos});

  //copy with
  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    PrivacyType? privacy,
    List<TeamMeta>? teamInfos,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      privacy: privacy ?? this.privacy,
      teamsInfos: teamInfos ?? this.teamsInfos,
    );
  }


  factory ProjectModel.fromJson(Map<String, dynamic> json) {  
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      privacy: PrivacyType.values.firstWhere(
            (e) => e.name == json['privacy'],
      ),
      teamsInfos:(json['teamInfos'] as List).map( (team) => TeamMeta.fromJson(team as Map<String, dynamic>)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'privacy': privacy.name,
      'teamInfos': teamsInfos,
    };
  }
  //from Project to ProjectModel
  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      name: project.name,
      description: project.description,
      privacy: project.privacy,
      teamsInfos: project.teamsInfos,
    );
  }
  //to Project from ProjectModel
  Project toEntity() {
    return Project(
      id: id,
      name: name,
      description: description,
      privacy: privacy,
      teamsInfos :teamsInfos,
    );
  }
}