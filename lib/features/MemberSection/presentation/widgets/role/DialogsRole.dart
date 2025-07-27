import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/roles/role__bloc.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/UseCases/RoleUsesCases.dart';
import '../../../../../core/app_theme.dart';
import '../../../global-pres.dart';

class RoleDialogs{
  static   ConfirmChangingRole(BuildContext context,Role role,String memberId)async{

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title:  Text('Confirm Role Change'
          ,style: PoppinsSemiBold(16, ColorsApp.textColorBlack, TextDecoration.none),

          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are about to change this user\'s role to:',style:
                PoppinsRegular(13, ColorsApp.textColorBlack)
                ,),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorsApp.PrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  role.roleName,
                  style:PoppinsNorml(14, ColorsApp.SecondaryColor)
                ),
              ),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:  Text('Cancel',

              style: PoppinsNorml(14, textColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsApp.PrimaryColor,
              ),
              onPressed: () => Navigator.pop(context, true),
              child:  Text('Confirm Change'
              ,style: PoppinsNorml(15, ColorsApp.PrimaryColor),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {

        context.read<RoleBloc>().add(
          ChangeRoleOfUserEvent(
            changeRoleParams: ChangeRoleParams(
              userId: memberId,
              roleId: role.id!,
            ),
          ),
        );
      }}
}