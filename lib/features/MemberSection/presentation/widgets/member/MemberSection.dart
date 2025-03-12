import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/domain/enums/ActionImage.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/components/AboutMemberComponent.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/member/MemberImpl.dart';
import 'package:jci_app/features/MemberSection/presentation/components/ProfileComponents.dart';
import 'package:jci_app/core/Member.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/PermissionsBLoc/permissions_bloc.dart';
import '../../../../Home/presentation/widgets/Functions/Functions.dart';
import '../../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../../../core/MemberModel.dart';
import '../../bloc/Members/members_bloc.dart';
import '../../bloc/memberPermissions/member_permission_bloc.dart';
import '../../components/InfoMemberFeaturesButton.dart';
import '../../pages/ObjectifPage.dart';
import '../../pages/SettingsPage.dart';
import '../achivements/AchivementsWidget.dart';
import 'DescriptionWidget.dart';
import '../MemberFeatures/PointsWidget.dart';
import '../MemberFeatures/TeamsWidget.dart';

class MemberSectionWidget extends StatefulWidget {
  final Member member;

  const MemberSectionWidget({Key? key, required this.member}) : super(key: key);

  @override
  State<MemberSectionWidget> createState() => _MemberSectionWidgetState();
}

class _MemberSectionWidgetState extends State<MemberSectionWidget> {
  FocusNode pointsFocusNode = FocusNode();
  @override
  void initState() {
    context.read<PermissionsBloc>().add(LoadPermissionOfMasterEvent(featuresId: [Constants.MANAGE_POINTS  , Constants.MANAGE_OBJECTIFS ,]));

    context.read<MemberPermissionBloc>().add(checkIsowner(widget.member.id!));
    context.read<MemberPermissionBloc>().add(const checkIsSuper());
    context.read<MemberPermissionBloc>().add(const checkIsAdmin());

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
    final mediaQuery = MediaQuery.of(context);

    return BlocListener<MemberManagementBloc, MemberManagementState>(
  listener: (context, state) {
    if (state.typeResult ==TypeResult.Removed){
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      context.read<MembersBloc>().add(const GetAllMembersEvent(true));
    }
    // TODO: implement listener}
  },
  child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
      builder: (context, state) {
        return
          SingleChildScrollView(
            child: Column(
              children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    children: [
      MemberImpl.IsNonowner(BackButton(color: textColorBlack, onPressed: () {
                  Navigator.of(context).pop();
                  context.read<MembersBloc>().add(const GetAllMembersEvent(false));

                })),
                      SizedBox(
                        width:MediaQuery.of(context).size.width/1.5,
                        child: Padding(
                          padding: paddingSemetricHorizontal(),

                          child: Text('${widget.member.firstName} ${widget.member.lastName}',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: PoppinsSemiBold(
                              18, textColorBlack, TextDecoration.none),),
                        ),
                      ),

                    ]  ),
    MemberImpl.Isowner(buildIconButton(context),true),


              ],
            ),

                    const SizedBox(height: 20,),






            BlocBuilder<MemberManagementBloc, MemberManagementState>(
  builder: (context, ste) {
    return Column(
            children: [








              AboutMemberComponent.MemberHeaader(widget.member,context),
 // if (widget.member.description.isNotEmpty)
   /* InfoButtonMember(
        ProfileComponents.isDes(state.state),
        BuildDescriptionWidget(member:widget.member,), 
        'About Me'.tr(context), StatesBool.Description,mediaQuery,mediaQuery.size.width/1.17,mediaQuery.size.height/4),
    */
              Padding(
                padding: paddingSemetricHorizontal(h: 25),
                child: GridView(
                  shrinkWrap: true,

                  gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing:12.0,
                    childAspectRatio: 1, // Adjust ratio based on your design
                  ),
                  children: [
                    InfoButtonMember(
                      header: 'Objectives'.tr(context),
                      onClick: () => ObjectifsPage.show( context,widget.member,  ste),
                      icon: Icons.track_changes,
                      type: PermissionType.canRead,
                      featureId: Constants.MANAGE_OBJECTIFS,
                    ),
                    InfoButtonMember(
                      featureId: Constants.MANAGE_POINTS,
                      type: PermissionType.canRead,
                      icon: Icons.emoji_events,
                      onClick: () => PointsWidget(
                        member: widget.member,
                        state: ste,
                        pointsFocusNode: pointsFocusNode,
                      ),
                      header: 'Points'.tr(context),
                    ),
                    InfoButtonMember(
                      featureId: Constants.MANAGE_OBJECTIFS,
                      type: PermissionType.canRead,
                      icon: Icons.people_alt,
                      onClick: () => TeamsComponent(member: widget.member),
                      header: 'My Teams'.tr(context),
                    ),
                  ],
                ),
              )

            ],
                    );
  },
)]),
          );
      },
    ),
);
  }



  Row buildIconButton(BuildContext context) {
    return Row(
      children: [
        buildnotificationIcon()
        ,  IconButton(
                      onPressed: () async{

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(member: widget.member),
                          ),
                        );

                      },
                      icon: const Icon(Icons.settings, color: textColorBlack,),
                    ),
      ],
    );
  }

  Stack buildnotificationIcon() {
    return Stack(
        children: [
          const Icon(Icons.notifications, color: textColorBlack),
          if (true) // Show badge only if there are new notifications
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
              ),
            ),
        ],
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
