import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import 'package:provider/provider.dart'; // or flutter_bloc
import 'package:auto_route/auto_route.dart';
import '../../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/functions/PermissionFunctions.dart';
import '../../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/config/env/Constants.dart';
import '../../../../../../core/route/app_router.dart';
import '../../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../../../MemberSection/presentation/bloc/objectifs/objectif_bloc.dart';
import '../../../../../MemberSection/presentation/pages/Dashboard/Dashboard.dart';
import '../../../../../Teams/data/models/TeamModel.dart';
import '../../../../../auth/AuthWidgetGlobal.dart';
import '../../../bloc/Activity/activity_cubit.dart';
import '../../Functions/ActivityFunctions.dart';
import 'CreateOptionButton.dart';

class ActivityOptionsRow extends StatelessWidget {
  const ActivityOptionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<PermissionsBloc, PermissionsState>(
        builder:(context,state){
          final canAccess = PermissionsFunctions.hasAnyPermission(
            state,
            [Constants.MANAGE_MEMBERS,Constants.MANAGE_EVENTS,
              Constants.MANAGE_OBJECTIFS, Constants.MANAGE_PROJECTS, Constants.MANAGE_TEAMS, Constants.MANAGE_TRAININGS,
              Constants.MANAGE_MEETINGS], // list of features
            [PermissionType.canRead,  ], // list of types
          );

          return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child:

     Padding(padding: paddingSemetricVerticalHorizontal(),

       child:
       Column(
         crossAxisAlignment: CrossAxisAlignment.start,
           spacing: 10,
           children: [
             if (state.permissions.isNotEmpty)
      Row(
        spacing: 6,
          children: [

        Icon(Icons.schema,color: ColorsApp.PrimaryColor),
        AutoSizeText("Quick Access",style: PoppinsSemiBold(19, ColorsApp.textColorBlack, TextDecoration.none),),
]),
             if (state.permissions.isNotEmpty)

               SizedBox(
               height: 110, // adjust height for your buttons
               width: MediaQuery.of(context).size.width,
               child: ListView(
                 scrollDirection: Axis.horizontal,
                 padding: const EdgeInsets.symmetric(horizontal: 8),
                 children: [
                   CreateOptionButton.CreateRowOption(
                     context,
                     color: Colors.orange,
                     label: "Dashboard",
                     icon: Icons.dashboard,
                     onTap: () => AdminDashboard.NavigateToDahboard(context,),
                     permissionName: Constants.MANAGE_TEAMS,
                   ),    CreateOptionButton.CreateRowOption(
                     context,
                     label: "Event",
                     icon: Icons.event,
                     onTap: () => ActivityFunctions.NavigateActivity(context, activity.Events),
                     permissionName: Constants.MANAGE_EVENTS,
                   ),
                   CreateOptionButton.CreateRowOption(
                     context,
                     color: ColorsApp.SecondaryColor,
                     label: "Meeting",
                     icon: Icons.meeting_room,
                     onTap: () => ActivityFunctions.NavigateActivity(context, activity.Meetings),
                     permissionName: Constants.MANAGE_MEETINGS,
                   ),
                   CreateOptionButton.CreateRowOption(
                     context,
                     color: Colors.green,
                     label: "Training",
                     icon: Icons.school,
                     onTap: () => ActivityFunctions.NavigateActivity(context, activity.Trainings),
                     permissionName: Constants.MANAGE_TRAININGS,
                   ),
                   CreateOptionButton.CreateRowOption(
                     context,
                     label: "Team",
                     color: Colors.orange,
                     icon: Icons.group,
                     onTap: () => context.pushRoute(CreateTeamRoute(team: TeamModel.empty())),
                     permissionName: Constants.MANAGE_TEAMS,
                   ),
                   CreateOptionButton.CreateRowOption(
                     context,
                     label: "Project",
                     color: Colors.red,
                     icon: Icons.assignment,
                     onTap: () => Navigator.pop(context),
                     permissionName: Constants.MANAGE_PROJECTS,
                   ),
                   CreateOptionButton.CreateRowOption(
                     context,
                     label: "Objective",
                     icon: Icons.track_changes,
                     onTap: () {
                       context.pushRoute(
                         ObjectifformPageRoute(
                           MemberId: context.read<MembersBloc>().state.user?.id ?? "",
                           event: ObjectiveEvent.Create,
                         ),
                       );
                     },
                     permissionName: Constants.MANAGE_OBJECTIFS,
                   ),
                 ].map((widget) => Padding(
                   padding: const EdgeInsets.only(right: 10),
                   child: widget,
                 )).toList(),
               ),
             )

       ])
    ));});
  }
}
