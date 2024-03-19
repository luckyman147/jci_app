import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/CheckList.dart';
import 'package:jci_app/features/Teams/presentation/widgets/DetailTeamWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskWidget.dart';

import '../../../../core/app_theme.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../Home/presentation/widgets/AddActivityWidgets.dart';
import '../../../Home/presentation/widgets/Formz.dart';
import '../../../Home/presentation/widgets/MemberSelection.dart';
import '../../domain/entities/Task.dart';
import '../bloc/TeamActions/team_actions_bloc.dart';
import 'CreateTeamWIdgets.dart';




class TaskDetailsWidget extends StatelessWidget {
  final Tasks task;

   TaskDetailsWidget({Key? key, required this.task, required this.TaskNamed}) : super(key: key);

  final TextEditingController controller=TextEditingController();
final TextEditingController TaskNamed;
  @override
  Widget build(BuildContext context) {

    final TextEditingController TaskName=TextEditingController(text: task.name);
    final TextEditingController description=TextEditingController(text: task.description);
    final mediaQuery = MediaQuery.of(context);
    return  BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return Padding(
          padding: paddingSemetricHorizontal(h: 8),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskDetailHeader(context, "Task Details", state.WillAdded),
          SizedBox(
              width: mediaQuery.size.width/3,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: builddesc(task,17))),
              buildTextField(state.WillAdded, TaskName, () {
              //  context.read<TaskVisibleBloc>().add(TaskVisibleEvent(isVisible: true));
              }, (PointerDownEvent dd) {
                //context.read<TaskVisibleBloc>().add(TaskVisibleEvent(isVisible: false));
              })

              ,buildTextField(state.WillAdded, description, () {
              //  context.read<TaskVisibleBloc>().add(TaskVisibleEvent(isVisible: true));
              }, (PointerDownEvent dd) {
                //context.read<TaskVisibleBloc>().add(TaskVisibleEvent(isVisible: false));
              }),
              Row(
                children: [
                  BorderSelection("Details",! state.WillAdded),
                  BorderSelection("Attachement", state.WillAdded),
                  BorderSelection("Comments", state.WillAdded),
                ],
              ),

buildAssignTo(context, mediaQuery),
Padding(
  padding: paddingSemetricVerticalHorizontal(),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildText("Timeline"),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[

        BuildStart(mediaQuery),
        BuildStart(mediaQuery),

      ]),
    ],
  ),
),
              buildText("Task Checklist"),
CheckListAddField(controller, task.id),
SizedBox(
    height: mediaQuery.size.height/4,
    child: CheckListWidget(checkList: task.CheckLists,)),


            ],
          ),


        );
      },
    );
  }

  Widget BuildStart(MediaQueryData mediaQuery) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: SizedBox(width: mediaQuery.size.width/3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Padding(
        padding: paddingSemetricHorizontal(h: 5),
        child: Icon(Icons.access_time_rounded,),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Start Date",style: PoppinsRegular(15, ThirdColor),),
          Text("${DateFormat("MMM,dd,yyyy").format(task.StartDate)}",style: PoppinsRegular(mediaQuery.devicePixelRatio*4, textColorBlack),),
        ],
      )

        ],



      ),

      ),
    );
  }








  Widget buildAssignTo(BuildContext context, MediaQueryData mediaQuery) {
    return Padding(
      padding:paddingSemetricVerticalHorizontal(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children:[
      Padding(
        padding:paddingSemetricVertical(),
        child: buildText("Team Assign "),
      ),
        task.AssignTo.isEmpty|| task.AssignTo==null?ElevatedButton(child: Text("Add Members"), onPressed: () {  },):
      Row(
        children: [
      membersTeamImage(context, mediaQuery, task.AssignTo.length, task.AssignTo),
      for (var i = 0; i<3&&i < task.AssignTo.length; i++)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "${task.AssignTo[i]['firstName']},",overflow: TextOverflow.ellipsis,
            style: PoppinsLight(18, textColor),
          ),
        ),
        ],
      ),
      ]
      ),
    );
  }

  Text buildText(String text) => Text(text,style: PoppinsRegular(15, textColor),);

  Padding BorderSelection(String text , bool  IsEnabled) {
    return Padding(
      padding: paddingSemetricHorizontal(),
      child: Container(
                decoration: BoxDecoration(

                border: Border(
                  bottom: BorderSide(
                    color: PrimaryColor,
                    width: IsEnabled?2.0:0,
                  ),
                )
                ),

                child: Text("$text",style: PoppinsRegular(18, IsEnabled?textColorBlack:ThirdColor),),),
    );
  }

  Widget buildTextField(bool state, TextEditingController TaskName,
      Function() onTap,Function(PointerDownEvent) onTapOutside) {

    return
      state==false?Padding(
        padding: paddingSemetricVerticalHorizontal(),
        child: Text(TaskName.text,style: PoppinsRegular(18, textColorBlack),),
      ):

      Padding(
        padding: paddingSemetricVerticalHorizontal(),
        child: TextField(
                controller:TaskName,
                onTap: onTap,
                onTapOutside: (dd) => onTapOutside,

                decoration: InputDecoration(
                  enabled: state,


                ),
              ),
      );
  }
}






Row TaskDetailHeader(BuildContext context, String text,bool isEnable) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          BackButton(
            onPressed: () {
              GoRouter.of(context).pop();

            },
          ),
               Text(text,style: PoppinsSemiBold(18, textColorBlack,TextDecoration.none),),
        ],
      ),

       IconButton(
        onPressed: () {
            //context.read<TaskVisibleBloc>().add(TaskVisibleEvent(isVisible: !isEnable));
        },
        icon: Icon(
      isEnable?   Icons.check_circle:Icons.edit_square
        ),

             )
    ],
  );}


Widget ActionTasksWidgets(mediaQuery,GlobalKey<FormState> key,title,TextEditingController TaskName,TextEditingController description ) => BlocConsumer<TeamActionsBloc, TeamActionsState>(
  builder: (context, state) {
    return BlocBuilder<PageIndexBloc, PageIndexState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Header(context,"Create Task"),


          ],
        );
      },
    );
  }, listener: (BuildContext context, TeamActionsState state) {
  log(state.toString());
  if (state is ErrorMessage){SnackBarMessage.showErrorSnackBar(message: state.message, context: context);
  }
  if (state is TeamAdded) {
    SnackBarMessage.showSuccessSnackBar(message: state.message, context: context);
    GoRouter.of(context).go('/home');
  }


},
);


Widget AssignTo(MediaQueryData mediaQuery)=>BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    debugPrint("state: ${state.memberFormz.value}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),

          child: Text(
            "Assign To",
            style: PoppinsRegular(18, textColorBlack),
          ),
        ),
        bottomMemberSheet(context ,mediaQuery,
            state.memberFormz.value??memberTest,"Select A member","Member"),
      ],
    );
  },
);
Widget TimesWidget(MediaQueryData mediaQuery)=>Column(
  children: [
    Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 18.0, vertical: 8),
        child: SizedBox(
            width: mediaQuery.size.width,
            child: BeginTimeWidget()

        )),
    AddEndDateButton(mediaQuery,"Show Deadline"),
    const   EndDateWidget(LabelText: 'Deadline', SheetTitle: 'Show Deadline', HintTextDate: 'Deadline Date', HintTextTime: 'Deadline Time'
    ),
  ],
);


