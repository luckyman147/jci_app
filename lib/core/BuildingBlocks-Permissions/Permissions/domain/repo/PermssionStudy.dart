import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../Presentation/PermissionsBLoc/permissions_bloc.dart';
import 'IPermissionStrategy.dart';

class TypePermissionStrategy implements IPermissionStrategy {
  final Widget HasPermissionsWidget;
  final Widget NoPermissionsWidget;

  TypePermissionStrategy({required this.HasPermissionsWidget, required this.NoPermissionsWidget});


  @override
  Widget buildWidget(PermissionCheckedState state) {
    return state.hasPermission ? HasPermissionsWidget : NoPermissionsWidget;
  }
}
