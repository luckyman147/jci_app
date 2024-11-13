import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';

class PermissionsModel extends Permission{
  PermissionsModel({required super.type, required super.isGranted});
  // Factory method to create from a map entry
  factory PermissionsModel.fromMapEntry(MapEntry<String, bool> entry) {
    return PermissionsModel(type: entry.key, isGranted: entry.value);
  }
  // from entity
  factory PermissionsModel.fromEnity(Permission permission) {
    return PermissionsModel(type: permission.type, isGranted: permission.isGranted);
  }

  // Convert to Map
  Map<String, bool> toMap() => {type: isGranted};

}