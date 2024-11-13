import '../../domain/Entities/UserPermissions.dart';
import 'FeaturePermissionsModel.dart';

class UserPermissionsModel extends UserPermissions{
  UserPermissionsModel({required super.userId, required super.featurePermissions});
  factory UserPermissionsModel.fromMap(String userId, Map<String, Map<String, bool>> data) {
    return UserPermissionsModel(
      userId: userId,
      featurePermissions: data.entries
          .map((entry) => FeaturePermissionsModel.fromMap(entry.key, entry.value))
          .toList(),
    );
  }
//from entity
  factory UserPermissionsModel.fromEntity(UserPermissions userPermissions) {
    return UserPermissionsModel(
      userId: userPermissions.userId,
      featurePermissions: userPermissions.featurePermissions
          .map((feature) => FeaturePermissionsModel.fromEntity(feature))
          .toList(),
    );
  }
  // Convert UserPermissions instance back to Map<String, Map<String, bool>>
  Map<String, Map<String, Map<String,bool>>> toMap() {
    return {
      for (var feature in featurePermissions) feature.featureId: FeaturePermissionsModel.fromEntity(feature).toMap(),
    };
  }
}