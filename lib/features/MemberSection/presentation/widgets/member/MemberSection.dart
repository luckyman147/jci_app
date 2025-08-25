import 'dart:convert';


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:jci_app/features/Home/domain/enums/ActionImage.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/components/AboutMemberComponent.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/user/MembersPage.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/member/MemberImpl.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../bloc/Members/members_bloc.dart';
import '../../bloc/memberPermissions/member_permission_bloc.dart';
import '../../components/InfoMemberFeaturesButton.dart';

import '../../functions/functionMember.dart';
import '../../pages/user/SettingsPage.dart';
import '../../pages/objectif/ObjectifPage.dart';

import '../MemberFeatures/PointsWidget.dart';
import '../MemberFeatures/TeamsWidget.dart';

class MemberSectionWidget extends StatefulWidget {
  final Member member;

// Add this to your state class
  final GlobalKey<ScaffoldState> scaffoldKey;
  const MemberSectionWidget({Key? key, required this.member, required this.scaffoldKey}) : super(key: key);

  @override
  State<MemberSectionWidget> createState() => _MemberSectionWidgetState();
}

class _MemberSectionWidgetState extends State<MemberSectionWidget> {
  FocusNode pointsFocusNode = FocusNode();
  @override
  void initState() {
    context.read<PermissionsBloc>().add(LoadPermissionOfMasterEvent(featuresId: [Constants.MANAGE_POINTS  , Constants.MANAGE_OBJECTIFS ,
      Constants.MANAGE_TEAMS,
      Constants.MANAGE_EVENTS,
      Constants.MANAGE_MEETINGS,
      Constants.MANAGE_TRAININGS,



      Constants.MANAGE_MEMBERS]));
    context.read<MemberPermissionBloc>().add(checkIsowner(widget.member.id!));

    image();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    pointsFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    return BlocListener<MemberManagementBloc, MemberManagementState>(
  listener: (context, state) {
    if (state.typeResult ==TypeResult.Removed){
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      context.read<MembersBloc>().add(const GetAllMembersEvent(true));
    }
    else if (state.typeResult ==TypeResult.Updated){
      FunctionMember.IfCurrentOwner(context, widget.member.id!);
    }
    // TODO: implement listener}
  },
  child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
      builder: (context, state) {
        return
          SingleChildScrollView(

            child:Container(
              height: 2000,
              color: ColorsApp.PrimaryColor.withOpacity(.04),
              child: Column(
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [


                        BackButton(color:
                   ColorsApp.textColorBlack, onPressed: () {
                          final st=context.read<MemberPermissionBloc>().state.isowner;
                          if(st) {
                            context.read<PageIndexBloc>().add(
                                SetIndexEvent(index: 0));
                          }
                          else {
                            Navigator.pop(context);

                          }
                          //  context.read<MembersBloc>().add(const GetAllMembersEvent(false));
                  }),


                        Text('Profile',style: PoppinsSemiBold(19.sp, ColorsApp.textColorBlack, TextDecoration.none))
                      ]  ),
                  MemberImpl.isOwner(buildIconButton(context),true),


                ],
              ),






              BlocBuilder<MemberManagementBloc, MemberManagementState>(
                builder: (context, ste) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                                  children: [
                                    AboutMemberComponent.MemberHeaader(widget.member,context),

                                    Padding(
                    padding: paddingSemetricHorizontal(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        InfoButtonMember(
                          header: 'Admin Dashboard'.tr(context),
                          onClick: () => ObjectifsPage.show( context,widget.member,  ste),
                          icon: Icons.dashboard,
                          type: PermissionType.canRead,
                          featureId: Constants.MANAGE_MEMBERS,
                        ),
                    MemberImpl.isOwner(
                        InfoButtonMember(
                        featureId: Constants.MANAGE_MEMBERS,
                        type: PermissionType.canRead,
                        icon: Icons.people_alt,
                        onClick: () => MembersPage.show(context),
                        header: 'Members',
                      ),true),
                        InfoButtonMember(
                          header: 'Objectives'.tr(context),
                          onClick: () => ObjectifsPage.show( context,widget.member,  ste),
                          icon: Icons.emoji_events,
                          type: PermissionType.canRead,
                          featureId: Constants.MANAGE_OBJECTIFS,
                        ),
                        InfoButtonMember(
                          featureId: Constants.MANAGE_POINTS,
                          type: PermissionType.canRead,
                          icon: Icons.workspace_premium_outlined,
                          onClick: () => PointsWidget.show(context,
                            widget.member,
                             ste,
                             pointsFocusNode,
                          ),
                          header: 'My Activities'.tr(context),
                        ),
                   InfoButtonMember(
                          featureId: Constants.MANAGE_OBJECTIFS,
                          type: PermissionType.canRead,
                          icon: Icons.workspaces,
                          onClick: () => TeamsComponent(member: widget.member),
                          header: 'My Teams'.tr(context),
                        ),

                      ],
                    ),
                                    )

                                  ],
                        ),
                  );
                },
              )]),
            ),
          );
      },
    ),
);
  }



  Row buildIconButton(BuildContext context) {
    return Row(
      children: [
        buildnotificationIcon((){
          widget.scaffoldKey.currentState?.openDrawer();

        })
        ,  IconButton(
                      onPressed: () async{

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(member: widget.member),
                          ),
                        );

                      },
                      icon:  Icon(Icons.settings, color:
                  ColorsApp.textColorBlack),
                    ),
      ],
    );
  }

  Widget
   buildnotificationIcon(Function() onPressed) {

    return InkWell(
      onTap: onPressed,
      child: Stack(
          children: [
            const Icon(Icons.notifications, color:
         ColorsApp.textColorBlack,),
            if (widget.member.unreadNotificationCount!=0) // Show badge only if there are new notifications
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 10,
                    minHeight: 10,
                  ),
                  child: AutoSizeText(widget.member.unreadNotificationCount.toString(),style: PoppinsSemiBold(10.sp, ColorsApp.textColorWhite, TextDecoration.none),),
                ),
              ),
          ],
        ),
    );
  }
  void image()async {
    if(widget.member.Images.isNotEmpty){
      final image=widget.member.Images[0];
      if (!mounted) return;
      if    (image!=null){

        context.read<TaskVisibleBloc>().add(ChangeImageEvent(image,ActionImage.ADD));
      }
      else{
        context.read<TaskVisibleBloc>().add(const ChangeImageEvent("assets/images/jci.png",ActionImage.ADD));
      }

    }
    else{
      context.read<TaskVisibleBloc>().add(const ChangeImageEvent("assets/images/jci.png",ActionImage.ADD));

    }
context.read<MemberManagementBloc>().add(initMemberEvent(isUpdated: widget.member.is_validated, cotisation: widget.member.cotisation, points: widget.member.points.toDouble(), role: widget.member.role!, objectifs: widget.member.userObjectifs));

  }


}
