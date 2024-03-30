import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/features/Home/data/model/events/EventModel.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/CreateTeamWIdgets.dart';
import 'package:jci_app/features/Teams/presentation/widgets/EventSelection.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../../core/app_theme.dart';
import '../../../Home/domain/entities/Event.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/bloc/IsVisible/bloc/visible_bloc.dart';
import '../../../Home/presentation/widgets/Functions.dart';
import '../../../Home/presentation/widgets/MemberSelection.dart';
import '../../../auth/presentation/bloc/Members/members_bloc.dart';
import '../../domain/entities/Team.dart';
import '../widgets/funct.dart';

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
  context.read<TaskVisibleBloc>().add(ChangeImageEvent("assets/images/jci.png",));

  context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: activity.Events));
  context.read<FormzBloc>().add(EventChanged( eventChanged: EventTest));

  context.read<MembersBloc>().add(GetAllMembersEvent());
  context.read<FormzBloc>().add(InitMembers(members: []));
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
      body:SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
               ActionsWidgets( mediaQuery,formKey,teamNameController,teamDescriptionController,widget.team ),
                imageTeamPicker(mediaQuery),
                TextTeamfieldNormal('Team Name',"Team Name here",teamNameController,(value){}),
            Events(mediaQuery),
            Members(mediaQuery),
                StatusWidget(mediaQuery,),
                TextTeamfieldDescription("Description", "Description must be less then 2 line",teamDescriptionController , (p0) => null)
              ],


            ),
          ),
        ) ,)
    );
  }
  Widget Members(mediaQuery)=>Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: BlocBuilder<FormzBloc, FormzState>(
      builder: (context, state) {
        log("sss: ${state.memberFormz.value}");
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),

              child: Text(
                "Members Name",
                style: PoppinsRegular(18, textColorBlack),
              ),
            ),
            bottomMembersSheet(context ,mediaQuery,
                state.membersTeamFormz.value??[]),
          ],
        );
      },
    ),
  );
  Widget Events(mediaQuery)=>BlocBuilder<FormzBloc, FormzState>(
    builder: (context, state) {
      debugPrint("state: ${state.eventFormz.value}");
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),

            child: Text(
              "Events Name ",
              style: PoppinsRegular(18, textColorBlack),
            ),
          ),
          bottomEventSheet(context ,mediaQuery,
              state.eventFormz.value??EventTest),
        ],
      );
    },
  );
  void checkTeam( BuildContext context) async{



    if (!mounted) {
      return;
    }

teamNameController.text = widget.team.name;
teamDescriptionController.text = widget.team.description;
//log(EventModel.fromJson(widget.team.event).toString());
    context.read<FormzBloc>().add(EventChanged( eventChanged:Event.fromJson(widget.team.event)));



log("ddddddd"+widget.team.Members.map((e) => Member.toMember(e)).toList().toString());
log("ddddddd"+widget.team.Members.toString());
    context.read<FormzBloc>().add(InitMembers(members: widget.team.Members.map((e) => Member.toMember(e)).toList()));
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(widget.team.status));
    context.read<MembersBloc>().add(GetAllMembersEvent());
    context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: activity.Events));
  }
}



