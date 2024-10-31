
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/members/members_cubit.dart';
import 'package:jci_app/features/Teams/presentation/widgets/CreateTeamWIdgets.dart';

import '../../../../core/app_theme.dart';
import '../../../Home/domain/entities/Event.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/bloc/IsVisible/bloc/visible_bloc.dart';


import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';

import '../../domain/entities/Team.dart';


class CreatTeamScreen extends StatefulWidget {
  final Team team;

  const CreatTeamScreen({Key? key, required this.team}) : super(key: key);

  @override
  State<CreatTeamScreen> createState() => _CreatTeamScreenState();
}

class _CreatTeamScreenState extends State<CreatTeamScreen> {
  @override
  void initState() {
if (!widget.team .isEmpty) {
  checkTeam(context);
  //    context.read<GetTeamsBloc>().add(GetTeamByIdEvent(id: team));
    }

else{
  context.read<TaskVisibleBloc>().add(const ChangeImageEvent("assets/images/jci.png",));
  context.read<MembersBloc>().add(const GetAllMembersEvent(false));
  context.read<AcivityFBloc>().add(const GetAllActivitiesEvent(act: activity.Events));
  context.read<FormzBloc>().add(EventChanged( eventChanged: Event.EventTest));


  context.read<MembersTeamCubit>().initMembers([]);
}

    // TODO: implement initState
    super.initState();
  }
  TextEditingController teamNameController = TextEditingController();
  TextEditingController teamDescriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body:BlocListener<GetTeamsBloc, GetTeamsState>(
        listener: (BuildContext context, GetTeamsState state) {
          LIstenerAdd(state, context);


        },
  child: SafeArea(
        child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                     ActionsWidgets( mediaQuery,formKey,teamNameController,teamDescriptionController,widget.team ),
                      imageTeamPicker(mediaQuery),
                      TextTeamfieldNormal('Team Name'.tr(context),"${"Team Name".tr(context)} ${"here".tr(context)}",teamNameController,(value){}),
                  Events(mediaQuery),
                  Members(mediaQuery),
                      StatusWidget(mediaQuery,),
                      TextTeamfieldDescription("Description".tr(context), "Description must be less then 3 line".tr(context),teamDescriptionController , (p0) => null,context)
                    ],


                  ),
                ),
              ) ,),
)
    );
  }
  Widget Members(mediaQuery)=>Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: BlocBuilder<MembersTeamCubit, MembersTeamState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),

              child: Text(
                "Members Name".tr(context),
                style: PoppinsRegular(18, textColorBlack),
              ),
            ),
            bottomMembersSheet(context ,mediaQuery,
                state.members,assignType.Assign,widget.team),
          ],
        );
      },
    ),
  );
  Widget Events(mediaQuery)=>BlocBuilder<FormzBloc, FormzState>(
    builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),

            child: Text(
              "Event Name".tr(context),
              style: PoppinsRegular(18, textColorBlack),
            ),
          ),
          bottomEventSheet(context ,mediaQuery,
              state.eventFormz.value??Event.EventTest),
        ],
      );
    },
  );
  void checkTeam( BuildContext context) async{



    if (!mounted) {
      return;
    }
    log(widget.team.Members.toString());
teamNameController.text = widget.team.name;
teamDescriptionController.text = widget.team.description;

    context.read<FormzBloc>().add(EventChanged( eventChanged:Event.fromJson(widget.team.event)));
//context.read<MembersTeamCubit>().initMembers(widget.team.Members);
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(widget.team.status));
    context.read<MembersBloc>().add(const GetAllMembersEvent(true));
    context.read<AcivityFBloc>().add(const GetAllActivitiesEvent(act: activity.Events));
  }
}



