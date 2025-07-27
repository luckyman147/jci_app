import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/PrimitiveUser/UserModel.dart';

class TeamMembers {
  final User? teamLeader;
  final List<User> members;

  const TeamMembers({
    required this.teamLeader,
    required this.members,
  });

  TeamMembers copyWith({
    User? teamLeader,
    List<User>? members,
  }) {
    return TeamMembers(
      teamLeader: teamLeader ?? this.teamLeader,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamLeader': teamLeader != null ? UserModel.fromEntity(teamLeader!).toJson(true) : null,
      'members': members.map((e) => UserModel.fromEntity(e).toJson(true)).toList(),
    };
  }

  factory TeamMembers.fromJson(Map<String, dynamic> json) {
    return TeamMembers(
      teamLeader: json['teamLeader'] != null ? UserModel.fromJson(json['teamLeader'], true) : null,
      members: json['members'] != null
          ? (json['members'] as List).map((e) => UserModel.fromJson(e, true)).toList()
          : [],
    );
  }
}
