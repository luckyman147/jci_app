import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/MemberImpl.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/core/Member.dart';

import '../../../Home/presentation/widgets/Functions.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../../core/MemberModel.dart';
import '../bloc/Members/members_bloc.dart';
import '../bloc/memberPermissions/member_permission_bloc.dart';

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








              ProfileComponents.hh(widget.member,context),
  if (widget.member.description.isNotEmpty)  ProfileComponents.ExpandedContainer(context, ProfileComponents.isDes(state.state), ProfileComponents.BuildDescriptionWidget(widget.member,ste,context), 'About Me'.tr(context), StatesBool.Description,mediaQuery,mediaQuery.size.width/1.17,mediaQuery.size.height/4),
    ProfileComponents.ExpandedContainer(context, ProfileComponents.isObjectif(state.state), ProfileComponents.BuildObjectifsWidget(widget.member,ste,context), 'Objectives'.tr(context), StatesBool.Objectifs,mediaQuery, mediaQuery.size.width/1.17,mediaQuery.size.height/4),

    ProfileComponents.ExpandedContainer(context, ProfileComponents.isPoints(state.state), ProfileComponents.BuildPointsWidget(widget.member,ste,context,pointsFocusNode), 'Points'.tr(context), StatesBool.Points,mediaQuery,mediaQuery.size.width/1.17 ,mediaQuery.size.height/4),
                      ProfileComponents.ExpandedContainer(context, ProfileComponents.iActivities(state.state),ProfileComponents.ActivitiesComponent(widget.member.Activities , mediaQuery), 'My Activities'.tr(context), StatesBool.Activities,mediaQuery,mediaQuery.size.width/1.17,mediaQuery.size.height/4 ),
              ProfileComponents.ExpandedContainer(context, ProfileComponents.iTeams(state.state), ProfileComponents.TeamsComponent(widget.member,mediaQuery,context), 'My Teams'.tr(context), StatesBool.Teams,mediaQuery,mediaQuery.size.width/1.17 ,mediaQuery.size.height/4),
            ],
                    );
  },
)]),
          );
      },
    ),
);
  }



  IconButton buildIconButton(BuildContext context) {
    return IconButton(
                  onPressed: () async{

                    context.go('/settings?user=${jsonEncode(MemberModel.fromEntity(widget.member).toJson())}');


                  },
                  icon: const Icon(Icons.settings, color: textColorBlack,),
                );
  }
  void image()async {
    if(widget.member.Images.isNotEmpty){
      final image=await ActivityAction. convertBase64ToXFile(widget.member.Images[0]['url']!);
      if (!mounted) return;
      if    (image!=null){

        context.read<TaskVisibleBloc>().add(ChangeImageEvent(image.path,));
      }
      else{
        context.read<TaskVisibleBloc>().add(const ChangeImageEvent("assets/images/jci.png",));
      }

    }
    else{
      context.read<TaskVisibleBloc>().add(const ChangeImageEvent("assets/images/jci.png",));

    }
context.read<MemberManagementBloc>().add(initMemberEvent(isUpdated: widget.member.is_validated, cotisation: widget.member.cotisation, points: widget.member.points.toDouble(), role: widget.member.role, objectifs: widget.member.objectifs));

  }


}
