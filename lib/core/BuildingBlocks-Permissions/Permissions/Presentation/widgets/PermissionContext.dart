import 'package:flutter/material.dart';

import '../../domain/repo/IPermissionStrategy.dart';
import '../../domain/repo/PermssionStudy.dart';

import '../PermissionsBLoc/permissions_bloc.dart';



class PermissionContext {
  late IPermissionStrategy strategy;
  final Widget HasPermissionsWidget;
  final Widget NoPermissionsWidget;

  // Constructor to set the strategy based on the permission type
  PermissionContext(String permissionType, this.HasPermissionsWidget, this.NoPermissionsWidget) {
    switch (permissionType) {
      case 'canWrite':
      case 'canRead':
      case 'canDelete':
        case 'canUpdate':
        strategy = TypePermissionStrategy(HasPermissionsWidget: HasPermissionsWidget, NoPermissionsWidget: NoPermissionsWidget);
        break;

    }

  }

  Widget execute(PermissionCheckedState state) {
    return strategy.buildWidget(state);
  }
}
