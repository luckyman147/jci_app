import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/PrimitiveUser/UserModel.dart';
import '../TeamUser.dart';

class TeamMembers {
  final User? teamLeader;
  final List<TeamUser> members;
  final List<String> membersIds;


  const TeamMembers({

    required this.membersIds ,
    required this.teamLeader,
    required this.members,
  });

  TeamMembers copyWith({
    List<String>? membersIds,
    User? teamLeader,
    List<TeamUser>? members,
  }) {
    return TeamMembers(
      membersIds: membersIds ?? this.membersIds,
      teamLeader: teamLeader ?? this.teamLeader,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membersIds': membersIds,
      'teamLeader': teamLeader != null ? UserModel.fromEntity(teamLeader!).toJson(true) : null,
      'members': members.map((e) => e.toJson()).toList(),
    };
  }

  factory TeamMembers.fromJson(Map<String, dynamic> json) {
    return TeamMembers(
      membersIds: json['membersIds'] != null
          ? List<String>.from(json['membersIds'])
          : [],
      teamLeader: json['teamLeader'] != null ? UserModel.fromJson(json['teamLeader'], true) : null,
      members: json['members'] != null
          ? (json['members'] as List).map((e) => TeamUser.fromJson(e)).toList()
          : [],
    );
  }
}
