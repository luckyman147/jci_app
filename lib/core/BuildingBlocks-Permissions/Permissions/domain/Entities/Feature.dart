import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';

class Feature {
  final String featureId;
  final String description;
  final String featureName;
  final DateTime updatedAt;
  final DateTime createdAt;
  final List<Permission> permissions;

  Feature({
    required this.featureId,
    required this.description,
    required this.featureName,
    required this.updatedAt,
    required this.createdAt,
    List<Permission>? permissions,
  }) : permissions = permissions ?? [
    Permission(type: PermissionType.canRead, isGranted: false),
    Permission(type: PermissionType.canUpdate, isGranted: false),
    Permission(type: PermissionType.canDelete, isGranted: false),
    Permission(type: PermissionType.canCreate, isGranted: false),
  ];

  Feature copyWith({
    String? featureId,
    String? description,
    String? featureName,
    DateTime? updatedAt,
    DateTime? createdAt,
    List<Permission>? permissions,
  }) {
    return Feature(
      featureId: featureId ?? this.featureId,
      description: description ?? this.description,
      featureName: featureName ?? this.featureName,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      permissions: permissions ?? List.from(this.permissions),
    );
  }
}

