import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/route/app_router.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Teams/domain/entities/Team/TeamMembers.dart';
import 'package:jci_app/features/Teams/domain/entities/Team/TeamMeta.dart';
import 'package:jci_app/features/Teams/domain/entities/Team/TeamStats.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/members/members_cubit.dart';

import 'package:jci_app/features/Teams/presentation/widgets/member/MembersTeamSelection.dart';

import '../../../../../../core/PrimitiveUser/User.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/CommonTextField.dart';
import '../../../../../Home/domain/entities/Activity/event/Event.dart';
import '../../../../../Home/domain/enums/ActionImage.dart';
import '../../../../../Home/domain/enums/Privacy.dart';
import '../../../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../../../Home/presentation/bloc/IsVisible/bloc/visible_bloc.dart';
import '../../../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';



import '../../../../domain/entities/Team/Team.dart';
import '../../../bloc/GetTasks/get_task_bloc.dart';
import '../../../bloc/TaskFilter/taskfilter_bloc.dart';
import '../../../components/EventSelection.dart';

Widget ActionsWidgets(mediaQuery,GlobalKey<FormState> key,TextEditingController TeamName,TextEditingController description,Team team ) => BlocBuilder<GetTeamsBloc, GetTeamsState>(
  builder: (context, state) {
    return BlocBuilder<PageIndexBloc, PageIndexState>(
  builder: (context, state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Header(context,team.isEmpty?"${"Create".tr(context)} ${"Team".tr(context)}":"${"Edit".tr(context)} ${"Team".tr(context)}"),
        DoneActions(TeamName, description, key,team),

      ],
    );
  },
);
  },
);

void LIstenerAdd(GetTeamsState state, BuildContext context) {
    log(state.toString());
  if (state.status ==  TeamStatus.error)
  {SnackBarMessage.showErrorSnackBar(message: state.errorMessage, context: context);
  }
 else if (  state.status == TeamStatus.Created) {
    SnackBarMessage.showSuccessSnackBar(message: "Team Created Successfully".tr(context), context: context);
    context.read<TaskVisibleBloc>().add(const changePrivacyEvent(Privacy.Primary));
   context.pushRoute(HomeRoute());
    context.read<GetTeamsBloc>().add(const GetTeams(null,false,isPrivate: false));



  }

}
Widget DoneActions(TextEditingController TeamName, TextEditingController description,GlobalKey<FormState> key,Team team)=>BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
  builder: (context, form) {
    return BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return BlocBuilder<MembersTeamCubit, MembersTeamState>(
  builder: (context, te) {
    return BlocBuilder<VisibleBloc, VisibleState>(
      builder: (context, Visstate) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap:()async {
                addOrUpdateTeam(formKey: key, currentTeam: team, nameController: TeamName,
                   descriptionController:  description,
                    formState: form,formzState:  state,visibleState:  Visstate,membersState:  te,
                    context: context);
              },
              child: BlocSelector<GetTeamsBloc, GetTeamsState, bool>(
                selector: (state) {
                  // Customize the condition for rebuilding the widget
                  // For example: show loading spinner if saving
                  return state.status == TeamStatus.Loading;
                },
                builder: (context, isSaving) {
                  return isSaving
                      ? const LoadingWidget()
                      : Text(
                    "Save".tr(context),
                    style: PoppinsSemiBold(21, PrimaryColor, TextDecoration.none),
                  );
                },
              )

            )
        );
      },
    );
  },
);
  },
);
  },
);

void addOrUpdateTeam({
  required GlobalKey<FormState> formKey,
  required Team currentTeam,
  required TextEditingController nameController,
  required TextEditingController descriptionController,
  required TaskVisibleState formState,
  required FormzState formzState,
  required VisibleState visibleState,
  required MembersTeamState membersState,
  required BuildContext context,
}) {
  if (!formKey.currentState!.validate()) {
    SnackBarMessage.showErrorSnackBar(
      message: "Please fill all fields",
      context: context,
    );
    return;
  }

  final team = Team(
    meta: TeamMeta(id: currentTeam.meta.id.isEmpty ? '' : currentTeam.meta.id,
        name: nameController.text,
        description:descriptionController.text ,
        coverImage: formState.images.isNotEmpty ? formState.images[0] : '',
        event:formzState.eventFormz.value ,
        status:visibleState.isPaid ),
    members: TeamMembers(teamLeader: currentTeam.isEmpty ? null :
    currentTeam.members.teamLeader, members: membersState.members),
    stats: TeamStats(
      numberOfTasksCompleted:  currentTeam.isEmpty ? 0 : currentTeam.stats.numberOfTasksCompleted,
      numberOfMembers: membersState.members.length,
      numberOfTasksTotal:  currentTeam.isEmpty ? 0 : currentTeam.stats.numberOfTasksTotal,
    ),

  );

  final bloc = context.read<GetTeamsBloc>();

  if (currentTeam.isEmpty) {
    bloc.add(AddTeam(team));
  } else {
    bloc.add(UpdateTeam(team));
  }
}



Row Header(BuildContext context,String text) {
  return Row(
        children: [
          BackButton(
            onPressed: () {
             context.navigateTo(HomeRoute());
              context.read<TaskVisibleBloc>().add(const ChangeImageEvent("assets/images/jci.png",ActionImage.ADD));
              context.read<GetTaskBloc>().add(resetevent());
              context.read<TaskVisibleBloc>().add(const changePrivacyEvent(Privacy.Primary));

              context.read<TaskfilterBloc>().add(const filterTask([]));
              //context.read<FormzBloc>().add(ImageInputChanged(imageInput:XFile("")));

            },
          ),
          Text('$text ',style:PoppinsSemiBold(21, textColorBlack, TextDecoration.none)),
        ],
      );
}
Widget choosWidget()=>        const Center(
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: 28.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo,
          size: 20,
          color: PrimaryColor,
        ),

      ],
    ),
  ));

Widget TextTeamfieldDescription(String name, String HintText,
    TextEditingController controller, Function(String) onChanged,BuildContext context) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: PoppinsRegular(18, textColorBlack),
          ),
          TextFormField(

            autovalidateMode: AutovalidateMode.onUserInteraction,
            autocorrect: true,
            autofocus: true,
            minLines: 3,
            maxLength: 100,
            autofillHints: [HintText],
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text'.tr(context);
              }
              return null;
            },
            onChanged: (value) {
              onChanged(value);
            },
            style: PoppinsNorml(18, textColorBlack),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: controller,
            decoration: InputDecoration(
                focusedBorder: border(PrimaryColor),
                enabledBorder: border(ThirdColor),
                errorBorder: border(Colors.red),
                focusedErrorBorder: border(PrimaryColor),
                errorStyle: ErrorStyle(18, Colors.red),
                hintStyle: PoppinsNorml(18, ThirdColor),
                hintText: HintText),
          ),
        ],
      ),
    );


Widget bottomMembersSheet(BuildContext context, MediaQueryData mediaQuery,
    List<User> members,assignType assign,Team team




    ) {

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0,),
    child: InkWell(
      onTap: () {
        MemberBottomSheetBuilder(context, mediaQuery,assign,team);
      },
      child:Container(
          width: mediaQuery.size.width,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: ThirdColor,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0,),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child:
              members.isNotEmpty?membersImage(context, mediaQuery, members):
              Text("${"Select".tr(context)}  ${"Members".tr(context)}",style: PoppinsRegular(18, ThirdColor),),
            ),
          )),
    ),
  );}

void MemberBottomSheetBuilder(BuildContext context, MediaQueryData mediaQuery,assignType assign,Team team

    ) {
  showModalBottomSheet(
    context: context,
    builder: (ctx)
  {
    return MemberTeamSelection.MembersTeamBottomSheet(
      mediaQuery, assign, team
    );
  });
}


Widget membersImage(BuildContext context, MediaQueryData mediaQuery,
    List<User> members,)=>Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Row(

    children: [
      for (var i = 0; i < (members.length > 4? 3 : members.length); i++)

        Align(
            widthFactor: .6,
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: textColorWhite,width: 5),
                  shape: BoxShape.circle,
                ),
                child: MemberTeamSelection.photo(members[i].Images[0],50,100))),
      if (members.length > 4)
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: PrimaryColor,
            shape: BoxShape.circle,                      ),
          // Customize the container as needed
          child: Align(
            widthFactor: .4,
            child: Center(
              child: Text(
                '+ ${members.length - 4} ',
                style: PoppinsLight(18, textColorWhite),
              ),
            ),
          ),
        ),
    ],
  ),
);
Widget bottomEventSheet(BuildContext context, MediaQueryData mediaQuery,
    Event event,


    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0,),
    child: InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {

                return EventsTeamBottomSheet(mediaQuery);
              },
            );


      },
      child:Container(
          width: mediaQuery.size.width,
          decoration:
          memberdeco,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0,),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child:
              event.activityBasics.name.isNotEmpty&& event.activityBasics.name!='Choose the Event'?imageEventWidget(event,mediaQuery):
              Text("Select an event".tr(context),style: PoppinsRegular(18, ThirdColor),),
            ),
          )),
    ),
  );}
Widget StatusWidget(mediaQuery) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: BlocBuilder<VisibleBloc, VisibleState>(
  builder: (context, state) {
  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 18.0),
  child: Column(
  children: [
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(
  "Status".tr(context),
  style: PoppinsRegular(
  mediaQuery.devicePixelRatio * 6, textColorBlack),
  ),
  InkWell(






      onTap: (){
        if(state.isPaid) {
          context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(false));
        } else {
          context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(true));
        }

      }, child: Container(
    width: mediaQuery.size.width * .3,
      decoration: BoxDecoration(
      color: !state.isPaid?Colors.red:Colors.green,
      borderRadius: BorderRadius.circular(15.0),
      ),


      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(!state.isPaid?"Private".tr(context):"Public",style: PoppinsRegular(18, textColorWhite),)),
      )),
  ),
  ],
  ),
  ],
  ));
  }),
);

