import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';

import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/PrimitiveUser/UserModel.dart';

class TeamUser {
  final User user;
  final UserTeamRole role;

  TeamUser(this.user, {this.role = UserTeamRole.canRead});

  TeamUser copyWith({
    User? user,
    UserTeamRole? role,
  }) {
    return TeamUser(
      user ?? this.user,
      role: role ?? this.role,
    );
  }

  factory TeamUser.fromJson(Map<String, dynamic> json) {
    return TeamUser(
      UserModel.fromJson(json['user'] as Map<String, dynamic>,true),
      role: UserTeamRole.values.firstWhere(
            (e) => e.toString() == 'UserTeamRole.${json['role']}',
        orElse: () => UserTeamRole.canRead,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user':UserModel.fromEntity(user).toJson(true),
      'role': role.toString().split('.').last,
    };
  }
}

enum UserTeamRole{
  canRead,canModify,canComment
}