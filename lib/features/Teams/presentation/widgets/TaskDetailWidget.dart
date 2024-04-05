import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskFilter/taskfilter_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/Timeline/timeline_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/CheckList.dart';
import 'package:jci_app/features/Teams/presentation/widgets/DetailTeamWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';


import '../../../../core/app_theme.dart';

import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/widgets/MemberSelection.dart';


import '../../domain/entities/Team.dart';
import 'CreateTeamWIdgets.dart';
import 'MembersTeamSelection.dart';
import 'TaskComponents.dart';


class TaskDetailsWidget extends StatefulWidget {
  final Map<String, dynamic> task;
  final int index;
  final Team team;

  TaskDetailsWidget({Key? key, required this.task, required this.index, required this.team})
      : super(key: key);

  @override
  State<TaskDetailsWidget> createState() => _TaskDetailsWidgetState();
}

class _TaskDetailsWidgetState extends State<TaskDetailsWidget> {
  FocusNode taskNameFocusNode = FocusNode();
  FocusNode checklistFocus = FocusNode();
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    checklistFocus.dispose();
    taskNameFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController TaskName = TextEditingController(
        text: widget.task['name']);
log('task name ${widget.task['attachedFile']}');
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(

      child: BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
        builder: (context, state) {
          return Padding(
            padding: paddingSemetricHorizontal(h: 8),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Container(

                  decoration: taskdex,
                  child: buildDescriBody(
                    mediaQuery, state, TaskName, context,),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: taskdex,
                  child: ListView(
                    shrinkWrap: true,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                    children: [
                     // buildSection(),
                      //   SizedBox(height: 10,),é
                      buildAssignTo(context, mediaQuery),
                      //  SizedBox(height: 10,),
                      buildAttachedfile(context, mediaQuery),
                      //  SizedBox(height: 10,),
                      buildTimeline(context, mediaQuery),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                buildChecklist(mediaQuery, context, checklistFocus),


              ],
            ),


          );
        },
      ),
    );
  }

  Widget buildSection() {
    return Padding(
      padding: paddingSemetricVertical(),
      child: Row(
        children: [
          BorderSelection("Details", Section.Details),

          BorderSelection("Comments", Section.Comments),
        ],
      ),
    );
  }

  SingleChildScrollView buildChecklist(MediaQueryData mediaQuery,
      BuildContext context, FocusNode checklistFocus) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Container(
        decoration: taskdex,
        child: ListView(
          shrinkWrap: true, keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [

            Padding(
              padding: paddingSemetricHorizontal(),
              child: buildText("Task Checklist",mediaQuery),
            ),
            Padding(
              padding: paddingSemetricVertical(),
              child: CheckListAddField(
                  controller, widget.task['id'], checklistFocus, mediaQuery),
            ),
            BlocBuilder<GetTaskBloc, GetTaskState>(
              builder: (context, state) {
                final i = state.tasks[widget.index]['CheckLists'].length;
                if (state.status == TaskStatus.Loading) {
                  return SizedBox(
                      height: state.tasks[widget.index]['CheckLists'].length *
                          89,

                      child: CheckListWidget(
                        checkList: List<Map<String, dynamic>>.from(
                            state.tasks[widget.index]['CheckLists']),
                        id: state.tasks[widget.index]["id"],));
                }
                else {
                  return SizedBox(

                      height: i * 89.6,
                      child: CheckListWidget(
                        checkList: List<Map<String, dynamic>>.from(
                            state.tasks[widget.index]['CheckLists']),
                        id: state.tasks[widget.index]["id"],));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding buildTimeline(BuildContext context, MediaQueryData mediaQuery) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText("Timeline",mediaQuery),
          InkWell(
            onTap: () {

              context.read<TimelineBloc>().add(initTimeline({
                'Start Date': widget.task['StartDate'],
                'Deadline': widget.task['Deadline']
              }));

              modeltimelinebottomsheetbody(context, mediaQuery);
            },
            child: BlocBuilder<GetTaskBloc, GetTaskState>(
              builder: (context, state)
              {
                log(state.tasks[widget.index]['StartDate'].toString()+ "start");
                log(state.tasks[widget.index]['Deadline'].toString()+ "deadline");
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      BuildStart(mediaQuery, "Start Date",
                          state.tasks[widget.index]['StartDate']),
                      BuildStart(mediaQuery, "Deadline",
                          state.tasks[widget.index]['Deadline']),

                    ]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void modeltimelinebottomsheetbody(BuildContext context,
      MediaQueryData mediaQuery) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: mediaQuery.size.height / 2.5,
          child: BlocBuilder<TimelineBloc, TimelineState>(
            builder: (context, ste) {
              log(ste.timeline['Start Date'].toString() + "startss");
              log(ste.timeline['Deadline'].toString() + "jjjj");

              return BlocBuilder<GetTaskBloc, GetTaskState>(

                builder: (context, state) {
                  return SingleChildScrollView(
                    child: BottomShetTaskBody(
                      context,
                      mediaQuery,
                      "Timeline",
                      ste.timeline['Start Date'],
                      ste.timeline['Deadline'],
                      "StartDate",
                      "Deadline",
                      widget.task['id'],),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget buildDescriBody(MediaQueryData mediaQuery, TaskVisibleState state,
      TextEditingController TaskName, BuildContext context) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: Row(
        children: [
          SizedBox(

            child:


            state.textFieldsTitle == TextFieldsTitle.Active
                ? IconButton(
                onPressed: () {
                  context.read<TaskVisibleBloc>().add(
                      ChangeTextFieldsTitle(TextFieldsTitle.Inactive));
                },
                icon: Icon(Icons.cancel, color: PrimaryColor, size: 20,))
                :
            BackButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
            ),
          ),
          SizedBox(

            child: buildTextField(
                taskNameFocusNode,
                state.textFieldsTitle == TextFieldsTitle.Active,
                TaskName, () {
              log("message");
              context.read<TaskVisibleBloc>().add(
                  ChangeTextFieldsTitle(TextFieldsTitle.Active));
              FocusScope.of(context).requestFocus(taskNameFocusNode);
            },
                "TaskName here",
                mediaQuery,
                    () {
                  context.read<GetTaskBloc>().add(UpdateTaskName(
                      {"taskid": widget.task['id'], "name": TaskName.text}));
                  context.read<TaskVisibleBloc>().add(
                      ChangeTextFieldsTitle(TextFieldsTitle.Inactive));
                  context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));

                    }


            ),
          ),
        ],
      ),
    );
  }

  Widget BuildStart(MediaQueryData mediaQuery, String date, DateTime time) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: SizedBox(width: mediaQuery.size.width / 3,
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
                Text(date, style: PoppinsRegular(15, ThirdColor),),
                Text("${DateFormat("MMM,dd,yyyy").format(time)}",
                  style: PoppinsRegular(
                      mediaQuery.devicePixelRatio * 4, textColorBlack),),
              ],
            )

          ],


        ),

      ),
    );
  }

  Widget buildAssignTo(BuildContext context, MediaQueryData mediaQuery) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: BlocBuilder<GetTaskBloc, GetTaskState>(
        builder: (context, state) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: paddingSemetricVertical(),
                  child: Row(

                    children: [
                      buildText("Members",mediaQuery),
                      Padding(
                        padding:paddingSemetricHorizontal(),
                        child: buildAddButton(() {
                          buildAssignBottomSheetBuilderFunction(context, mediaQuery, state);
                        }),
                      )
                    ],
                  ),
                ),

                Row(
                  children: [
                    state.tasks[widget.index]['AssignTo'].isEmpty ||
                        state.tasks[widget.index]['AssignTo'] == null ? SizedBox() :

                    GestureDetector(
                      onTap: (){
                        buildAssignBottomSheetBuilderFunction(context, mediaQuery, state);

                      },
                      child: membersTeamImage(
                          context, mediaQuery, state.tasks[widget.index]['AssignTo'].length,
                          state.tasks[widget.index]['AssignTo'],30,40),
                    ),


                  ],
                ),
              ]
          );
        },
      ),
    );
  }

  void buildAssignBottomSheetBuilderFunction(BuildContext context, MediaQueryData mediaQuery, GetTaskState state) {
    return AssignBottomSheetBuilder(context, mediaQuery, (member) {
                        //delete memberr
                        log(member.id.toString());
                        context.read<GetTaskBloc>().add(

                            UpdateMember(
                                {"taskid": state.tasks[widget.index]['id'], "member": member,
                                  'status': false, 'memberId': member.id}));
                        context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));

    }, (member) {
                        //add member
                        context.read<GetTaskBloc>().add(UpdateMember(
                            {"taskid": state.tasks[widget.index]['id'], "member": member,
                              'status': true, 'memberId': member.id}));
                        context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));

    },widget.team,
                          widget.index

                      );
  }

  Widget buildAttachedfile(BuildContext context, MediaQueryData mediaQuery) {
    return BlocBuilder<GetTaskBloc, GetTaskState>(
  builder: (context, state) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: paddingSemetricVertical(),
              child: Row(

                children: [
                  buildText('Attached Files',mediaQuery),
                  Padding(
                    padding: paddingSemetricHorizontal(),
                    child: buildAddButton(() async{
                     FileStorage.pickFile(mounted, context, widget.task['id']);
                     context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));

                    }
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                state.tasks[widget.index]['attachedFile'] .isEmpty ||
                    state.tasks[widget.index]['attachedFile']  == null
                    ? SizedBox() :

                AttachedFileWidget (  fileList: state.tasks[widget.index]['attachedFile'] as List<Map<String,dynamic>>, idTask: state.tasks[widget.index]['id'] as String,),


              ],
            ),
          ]
      ),
    );
  },
);
  }

  Row TaskDetailHeader(BuildContext context, int index, String text,
      bool isEnable, Map<String, dynamic> task, MediaQueryData mediaQuery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [


            // Text(text,style: PoppinsSemiBold(18, textColorBlack,TextDecoration.none),),
            /*     SizedBox(
              width: mediaQuery.size.width/3,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: builddesc(task,13,index))),
*/
          ],
        ),

        /*    IconButton(
        onPressed: () {
            //context.read<TaskVisibleBloc>().add(TaskVisibleEvent(isVisible: !isEnable));
        },
        icon: Icon(

      isEnable?   Icons.check_circle:Icons.edit,
          color: isEnable?PrimaryColor:SecondaryColor,
          size: 30,
        ),

             )*/
      ],
    );
  }

  Widget AssignTo(MediaQueryData mediaQuery) =>
      BlocBuilder<FormzBloc, FormzState>(
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
              bottomMemberSheet(context, mediaQuery,
                  state.memberFormz.value ?? Member.memberTest, "Select A member",
                  "Member"),
            ],
          );
        },
      );
}
