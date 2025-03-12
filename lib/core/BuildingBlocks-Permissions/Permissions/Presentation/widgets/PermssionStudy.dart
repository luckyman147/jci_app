import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/FeaturePermissionsModel.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/PermissionsModel.dart';
import 'package:logger/logger.dart';

import '../../domain/Entities/FeaturePermissions.dart';
import '../../domain/Entities/Permission.dart';
import '../../domain/repo/IPermissionStrategy.dart';
import '../PermissionsBLoc/permissions_bloc.dart';
class TypePermissionStrategy extends StatelessWidget {
  final Widget hasPermissionsWidget;
  final Widget noPermissionsWidget;
  final Widget loadingWidget;
  final PermissionType type;
  final String feature;

  const TypePermissionStrategy({
    required this.hasPermissionsWidget,
    required this.noPermissionsWidget,
    required this.type,
    required this.feature,
    required this.loadingWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PermissionsBloc, PermissionsState, bool?>(
      selector: (state) {
        if (state.type==TypePermissionsStatus.Loading) return null; // Representing the loading state
        if (state.permissions.isNotEmpty) {


          final existingFeature = state.permissions.firstWhere(
                (e) => e.featureId == feature,
            orElse: () => FeaturePermissionsModel(featureId: feature, permissions: []),
          );




          final permission = existingFeature.permissions.firstWhere(
                (p) => p.type == type,
            orElse: () => PermissionsModel(type: type, isGranted: false),
          );


          return permission.isGranted;
        }
        return false;
      },
      builder: (context, hasPermission) {
        if (hasPermission == null) {
          return loadingWidget; // Show loading widget if the state is loading
        }
        return hasPermission ? hasPermissionsWidget : noPermissionsWidget;
      },
    );
  }
}


