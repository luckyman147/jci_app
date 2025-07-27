import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/FeaturePermissionsModel.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';

import '../../../../../features/auth/AuthWidgetGlobal.dart';

class RoleModel extends Role {
  RoleModel({
    required super.permissions,
    required super.RoleCategory,
    required super.roleName,
    required super.id,
  });
  factory RoleModel.fromPermissionsMap(Map<String, dynamic> json) {
    final permissionsMap = json['permissions'] as Map<String, dynamic>? ?? {};
    final List<FeaturePermissions> permissions = [];

    // Extract all valid permissions from the map
    permissionsMap.forEach((featureId, featureData) {
      try {
        if (featureData is Map<String, dynamic>) {
          permissions
              .add(FeaturePermissionsModel.fromMap(featureId, featureData));
        } else {
          throw FormatException(
              'Invalid permission entry for feature $featureId');
        }
      } catch (e, stackTrace) {
        // Log the error but continue processing other permissions
        Logger().e('Error parsing permission for feature $featureId: $e');
        Logger().e(stackTrace.toString());
      }
    });

    return RoleModel(
      id: json["id"] ?? "",
      permissions: permissions,
      RoleCategory: CibleType.values
          .firstWhere((test) => test.name == json["RoleCategory"]),
      roleName: json['roleName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permissions': {
        for (var permission in permissions)
          permission.featureId:
              FeaturePermissionsModel.fromEntity(permission).toRoleMap()
      },
      'RoleCategory': RoleCategory.name,
      'roleName': roleName,
    };
  }

  factory RoleModel.fromEntity(Role role) {
    return RoleModel(
      id: role.id,
      permissions: role.permissions
          .map((p) => p is FeaturePermissionsModel
              ? p
              : FeaturePermissionsModel.fromEntity(p))
          .toList(),
      RoleCategory: role.RoleCategory,
      roleName: role.roleName,
    );
  }

  // Copy with method
  RoleModel copyWith({
    String? id,
    List<FeaturePermissions>? permissions,
    CibleType? RoleCategory,
    String? roleName,
  }) {
    return RoleModel(
      id: id ?? this.id,
      permissions: permissions ?? this.permissions,
      RoleCategory: RoleCategory ?? this.RoleCategory,
      roleName: roleName ?? this.roleName,
    );
  }
}
