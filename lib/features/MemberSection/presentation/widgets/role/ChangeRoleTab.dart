import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/roles/role__bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/UseCases/RoleUsesCases.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/features/MemberSection/presentation/components/buttonsComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/roles/CreateRoleTab.dart';
import 'package:logger/logger.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Feature.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';
import 'DialogsRole.dart';
import 'PermissionListView.dart';

class ChangeRoleTab extends StatelessWidget {
  const ChangeRoleTab({super.key, required this.roles, required this.roleName, required this.memberId});
final List<Role> roles;
final String roleName;
final String memberId;
  @override
  Widget build(BuildContext context) {
    List<ValueNotifier<bool>> expandStates =
    List.generate(roles.length, (_) => ValueNotifier<bool>(false));

    return ListView.separated(
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role =  roles[index];
        final value=expandStates[index];
        return RoleTile(role, value);
      }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10,); },
    );
  }

  ValueListenableBuilder<bool> RoleTile(Role role, ValueNotifier<bool> value) {
    return ValueListenableBuilder<bool>(
          builder: (context,isTrue,_) {
            return Padding(
              padding: paddingSemetricVerticalHorizontal(),
              child: AnimatedContainer(
                decoration: _buildBoxDecoration(),
                duration: const Duration(milliseconds: 600),
                child: ListTile(
                  onTap: (){
                    value.value=!value.value;
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Row(
                    children: [
                      Padding(
                        padding:paddingSemetricHorizontal(),
                        child:
                        AsyncComponents.buildFutureBuilder(
                      ButtonsMemberComponents.      FlashButton(context, role,(){

                          CreateUpdateRolePage.show(context, role: role);

                      },Icons.edit,ColorsApp.SecondaryColor),
                          PermissionType.canUpdate,Constants.MANAGE_MEMBERS

                        )

                      ) ,

                          Text(role.roleName,style:PoppinsSemiBold(17.sp, ColorsApp.textColorBlack, TextDecoration.none) ,),
                    ],
                  ),

                  if  (  role.roleName!=roleName)
                    ButtonsMemberComponents.FlashButton(
                      context,
                      role,
                      ()=>RoleDialogs.ConfirmChangingRole(context,role,memberId),
                      Icons.check_outlined,
                      ColorsApp.PrimaryColor,
                    ),
                    ],
                  ),


                  subtitle: isTrue
                      ?
                  PermissionsListView(role: role,):const SizedBox(height: 2,)
                ),

              ),
            );
          }, valueListenable: value,
        );
  }


  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color:ColorsApp.textColorBlack,
        width:2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}