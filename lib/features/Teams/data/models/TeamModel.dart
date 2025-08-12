import 'package:jci_app/features/Teams/domain/entities/task/Task.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/PrimitiveUser/UserModel.dart';
import '../../../Home/data/model/events/EventModel.dart';
import '../../../Home/domain/entities/Activity/event/Event.dart';
import '../../domain/entities/Team/Team.dart';
import '../../domain/entities/Team/TeamMembers.dart';
import '../../domain/entities/Team/TeamMeta.dart';
import '../../domain/entities/Team/TeamStats.dart';
import 'TaskModel.dart';

class TeamModel extends Team {
  TeamModel({
    required super.meta,
    required super.stats,
    required super.members,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      meta: TeamMeta.fromJson(json['meta'] as Map<String, dynamic>),
      stats: TeamStats.fromJson(json['stats'] as Map<String, dynamic>),
      members:  TeamMembers.fromJson(
        json['members'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'meta': meta.toJson(),
      'stats': stats.toJson(),
      'members': members.toJson()
    };
  }

  TeamModel copyWith({
    TeamMeta? meta,
    TeamStats? stats,
    TeamMembers? members,
  }) {
    return TeamModel(
      meta: meta ?? this.meta,
      stats: stats ?? this.stats,
      members: members ?? this.members,
    );
  }

  static TeamModel fromEntity(Team entity, bool generateNewId) {
    return TeamModel(
      meta: generateNewId
          ? entity.meta.copyWith(id: "")
          : entity.meta,
      stats: entity.stats,
      members: entity.members.copyWith(
        teamLeader:  entity.members.teamLeader,
      ),
    );
  }

  factory TeamModel.empty() {
    return TeamModel(
      meta: TeamMeta(
        id: '',
        name: '',
        description: '',
        projectId: '',
        event: null,
        status: false,
        coverImage: '',

      ),
      stats: TeamStats(
        numberOfMembers: 0,
        numberOfTasksCompleted: 0,
        numberOfTasksTotal: 0,
      ),
      members: TeamMembers(members: [], teamLeader: null, membersIds: []),
    );
  }

  
}