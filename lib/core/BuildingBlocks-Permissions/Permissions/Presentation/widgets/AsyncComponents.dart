import 'package:flutter/material.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';

import 'PermssionStudy.dart';
import '../../../../../features/MemberSection/presentation/widgets/utils/ShimmerEffects.dart';

class AsyncComponents {

  static  Widget buildFutureBuilder(Widget body,PermissionType type,String featureId,{Widget? loadingWidget}){
    return TypePermissionStrategy(
       hasPermissionsWidget: body,
      noPermissionsWidget: SizedBox(),
      loadingWidget:loadingWidget??ShimmerGridView.padding(20 , 20),
      type: type, feature: featureId ,
    );
  }

}