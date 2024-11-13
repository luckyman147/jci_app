import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/PermissionsModel.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';

class FeaturePermissionsModel extends FeaturePermissions {

  FeaturePermissionsModel( {required super.featureId, required super.permissions });
  // Factory constructor to create from a Map<String, bool>
  factory FeaturePermissionsModel.fromMap(String featureId, Map<String, bool> permissionsMap) {
    return FeaturePermissionsModel(
      featureId: featureId,
      permissions: permissionsMap.entries.map((entry) => PermissionsModel.fromMapEntry(entry)).toList(),
    );
  }
// from entity
  factory FeaturePermissionsModel.fromEntity(FeaturePermissions featurePermissions) {
    return FeaturePermissionsModel(
      featureId: featurePermissions.featureId,
      permissions: featurePermissions.permissions.map((permission) => PermissionsModel.fromEnity(permission)).toList(),
    );
  }
  // Convert the FeaturePermissions instance back to a Map<String, bool>
 
  Map<String, Map<String,bool>> toMap() {
    return {
      featureId: permissions.map((permission) => PermissionsModel.fromEnity(permission).toMap()).fold({}, (previousValue, element) => previousValue..addAll(element)),
    };
  }


}