import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:logger/logger.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Feature.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';
import '../../../global-pres.dart';
class PermissionsListView extends StatelessWidget {
  final Role role;

  const PermissionsListView({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (role.permissions.isNotEmpty)
          _buildPermissionsList(context)
        else
          _buildEmptyState(),
      ],
    );
  }

  Widget _buildPermissionsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: role.permissions.length,
      itemBuilder: (context, index) {
        final permission = role.permissions[index];
        if (permission.permissions.every((per) => !per.isGranted)) {
          return const SizedBox();
        } else {
          return _buildPermissionTile(permission, context);
        }
      },
    );
  }

  Widget _buildPermissionTile(FeaturePermissions permission, BuildContext context) {
 final len= permission.permissions.where((p) => p.isGranted).length;
    return SizedBox(
      height: (len<=2?80.h :130.h) ,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics:const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            permission.featureName != null
                ? Text(
              permission.featureName!,
              style: PoppinsSemiBold(
                15.sp,
                ColorsApp.textColorBlack,
                TextDecoration.none,
              ),
            )
                : const Text("nexsite pas"),
            Padding(
              padding: paddingSemetricVertical(),
              child: SizedBox(
                height: 107.sp,
                child: GridView.builder(

                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: len<2?1: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio:len<2?6:4,
                  ),
                  itemCount:len,
                  itemBuilder: (context, index) {
                    final grantedPermissions = permission.permissions
                        .where((p) => p.isGranted)
                        .toList();
                    return _buildPermission(grantedPermissions[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermission(Permission permission) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsApp.PrimaryColor.withOpacity(.05),
        borderRadius: BorderRadius.circular(5),
      ),

      child: Center(
        child: Text(
          permission.type.name.doublesWords,
          style: PoppinsRegular(14.sp, ColorsApp.PrimaryColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'No permissions assigned',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}