import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Feature.dart';

import 'Permission.dart';

class FeaturePermissions {
  final String featureId;
  final String? featureName;
  final List<Permission> permissions;

  FeaturePermissions({required this.featureId, required this.permissions,this.featureName});

factory FeaturePermissions.FromFeature(Feature feature){
  return FeaturePermissions(featureId: feature.featureId,permissions: feature.permissions);
}
FeaturePermissions CopyWith(String? featureName)=>FeaturePermissions(featureId: featureId,
    permissions: permissions,featureName: featureName??this.featureName);

}