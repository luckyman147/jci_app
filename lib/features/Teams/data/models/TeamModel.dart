import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/Team.dart';
part 'TeamModel.g.dart';
@JsonSerializable()
class TeamModel extends Team{
  TeamModel({required super.name, required super.description, required super.event, required super.Members, required super.CoverImage, required super.tasks, required super.id, required super.TeamLeader, required super.status});

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamModelToJson(this);


  Team toEntity() {
    return Team(
      name: name,
      id: id,
      TeamLeader: TeamLeader,
      description: description,
      status: status,
      event: event,
      Members: Members,
      CoverImage: CoverImage,
      tasks: tasks,
    );
  }
 static TeamModel fromEntity(Team entity,bool add) {
    return TeamModel(
      name: entity.name,
      id:add?"": entity.id,
      TeamLeader:add?"": entity.TeamLeader,
      description: entity.description,
      status: entity.status,
      event: entity.event,
      Members: entity.Members,
      CoverImage: entity.CoverImage,
      tasks: entity.tasks,
    );
  }
}