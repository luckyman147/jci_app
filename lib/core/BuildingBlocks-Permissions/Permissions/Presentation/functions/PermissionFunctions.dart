import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';

import '../../Data/Models/FeaturePermissionsModel.dart';
import '../../Data/Models/PermissionsModel.dart';
import '../Bloc/permissions/permissions_bloc.dart';

class PermissionsFunctions {
  static bool HasPermission(
      PermissionsState state, String feature, PermissionType type) {
    final existingFeature = state.permissions.firstWhere(
      (e) => e.featureId == feature,
      orElse: () =>
          FeaturePermissionsModel(featureId: feature, permissions: []),
    );

    //   Logger().i("PermissionsBloc: ${existingFeature.permissions.map((e) => e.isGranted)}");

    final permission = existingFeature.permissions.firstWhere(
      (p) => p.type == type,
      orElse: () => PermissionsModel(type: type, isGranted: false),
    );

    //  Logger().i("PermissionsBloc: ${permission.isGranted}");
//    Logger().i("PermissionsBloc: ${type}");

    return permission.isGranted;
  }
}
