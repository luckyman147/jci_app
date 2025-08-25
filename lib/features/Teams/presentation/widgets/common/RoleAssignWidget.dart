import 'package:auto_size_text/auto_size_text.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';

import '../../../../Home/Activity_Global.dart';
import '../../../domain/dto/TaskIdParams.dart';
import '../../../domain/entities/TeamUser.dart';
import '../../bloc/GetTasks/get_task_bloc.dart';
import '../../bloc/GetTeam/get_teams_bloc.dart';
import '../../bloc/members/members_cubit.dart';

class RoleAssignWidget extends StatelessWidget {
  const RoleAssignWidget({super.key,required this.isLeader,
    required this.isMeLeader,

     required this.hasPermission,


    required this.item, required this.onRoleChanged});
  final TeamUser item;
  final bool isLeader;
  final bool isMeLeader;
  final bool hasPermission;


  final Function(UserTeamRole,TeamUser) onRoleChanged;

  @override
  Widget build(BuildContext context) {
    return
       BlocBuilder<MembersTeamCubit,MembersTeamState>(builder: (context, w) {

        if  (w.members.isNotEmpty && w.members.any((test)=>test.user.id==item.user.id&& !isLeader)) {

          return     DropdownButton<UserTeamRole>(
            iconEnabledColor: ColorsApp.PrimaryColor
            ,


            key: Key(item.role.name), // Unique key for each dropdown
            underline: const SizedBox(),
            iconSize: 10,
            style: PoppinsRegular(12, ColorsApp.textColorBlack),
            icon: const Icon(Icons.arrow_forward_ios, color: ColorsApp.textColorBlack),
            value:

            w.members.firstWhere((test)=>test.user.id==item.user.id) .role, // Current selected role

            // This defines the dropdown menu items (icon + text)
            items: UserTeamRole.values.map((role) {
              return DropdownMenuItem<UserTeamRole>(
                key: Key(role.name),
                value: role,
                child:
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child:
                    Row(
                      spacing: 10,
                      children: [
                        Icon(
                          _getRoleIcon(role),
                          color: ColorsApp.textColorBlack,
                        ),

                        AutoSizeText(
                          role.name.doublesWords  ,
                          style: PoppinsRegular(13, ColorsApp.textColorBlack),
                        ),
                      ],
                    )),
              );
            }).toList(),
        onChanged: isMeLeader || !hasPermission
              ? (UserTeamRole? newValue) {
            if (newValue != null) {
              onRoleChanged(newValue, item);
            }
          }
             : null, // ❌ disables the menu
          );

        } return const SizedBox();},



      );

  }
   IconData _getRoleIcon(UserTeamRole role) {
    switch (role) {
      case UserTeamRole.canRead:
        return Icons.visibility; // 👁 read
      case UserTeamRole.canModify:
        return Icons.edit; // ✏ modify
      case UserTeamRole.canComment:
        return Icons.comment; // 💬 comment
    }
  }
}
