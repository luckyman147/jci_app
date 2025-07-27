import 'package:jci_app/core/PrimitiveUser/User.dart';
import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import '../../../../Home/domain/entities/Activity/event/Event.dart';
import 'TeamMembers.dart';
import 'TeamMeta.dart';
import 'TeamStats.dart';

class Team {
  final TeamMeta meta;
  final TeamStats stats;
  final TeamMembers members;

  const Team({
    required this.meta,
    required this.stats,
    required this.members,
  });
  bool get isEmpty => meta.id.isEmpty && meta.name.isEmpty    && members.teamLeader == null  ;
  Team copyWith({
    TeamMeta? meta,
    TeamStats? stats,
    TeamMembers? members,
  }) {
    return Team(
      meta: meta ?? this.meta,
      stats: stats ?? this.stats,
      members: members ?? this.members,
    );
  }
  Team convertMetaToTeam(TeamMeta meta) {
    return Team(
      meta: meta,
      stats: TeamStats(),
      members: TeamMembers(
        teamLeader: null, // or provide a default value
        members: [], // empty list for now, or populate if you have member data
      ),


     // empty for now, or populate if you have member data
    );
  }

}
