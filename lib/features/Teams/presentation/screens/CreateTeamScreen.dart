import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Teams/presentation/widgets/CreateTeamWIdgets.dart';
import 'package:jci_app/features/Teams/presentation/widgets/EventSelection.dart';

import '../../../../core/app_theme.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/widgets/MemberSelection.dart';
import '../../../auth/presentation/bloc/Members/members_bloc.dart';

class CreatTeamScreen extends StatefulWidget {
  const CreatTeamScreen({Key? key}) : super(key: key);

  @override
  State<CreatTeamScreen> createState() => _CreatTeamScreenState();
}

class _CreatTeamScreenState extends State<CreatTeamScreen> {
  @override
  void initState() {

    context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: activity.Events));
    context.read<MembersBloc>().add(GetAllMembersEvent());
    context.read<FormzBloc>().add(InitMembers(members: []));
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
               ActionsWidgets( mediaQuery,formKey,teamNameController,teamDescriptionController),
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
        debugPrint("state: ${state.memberFormz.value}");
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
}
