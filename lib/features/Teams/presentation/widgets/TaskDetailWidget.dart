
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/Timeline/timeline_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/CheckList.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';


import '../../../../core/app_theme.dart';

import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/widgets/MemberSelection.dart';


import '../../domain/entities/Team.dart';

import '../../domain/usecases/TaskUseCase.dart';
import 'DetailTeamComponents.dart';

import 'TaskComponents.dart';


class TaskDetailsWidget extends StatefulWidget {
  final Map<String,dynamic> task;
  final int index;
  final Team team;

  const TaskDetailsWidget({Key? key, required this.task, required this.index, required this.team})
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

    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(

      child: BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
        builder: (context, state) {
          return Padding(
            padding: paddingSemetricHorizontal(h: 8),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Container(

                  decoration: taskdex,
                  child: buildDescriBody(
                    mediaQuery, state, TaskName, context,),
                ),

                const SizedBox(height: 10,),

                buildChecklist(mediaQuery, context, checklistFocus),
                const SizedBox(height: 10,),
                Container(
                  decoration: taskdex,
                  child: ListView(
                    shrinkWrap: true,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                    children: [
                     // buildSection(),
                      //   SizedBox(height: 10,),é
                      buildAssignTo(context, mediaQuery,widget.team,widget.task),
                      //  SizedBox(height: 10,),
                      buildAttachedfile(context, mediaQuery,widget.team,widget.task),
                      //  SizedBox(height: 10,),
                      buildTimeline(context, mediaQuery,widget.team,widget.task),
                    ],
                  ),
                ),


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
              padding: paddingSemetricVertical(),
              child: CheckListAddField(
                  controller, widget.task['id'], checklistFocus, mediaQuery,widget.team,widget.task,mounted),
            ),
            BlocBuilder<GetTaskBloc, GetTaskState>(
              builder: (context, state) {
                final i =  state.tasks[widget.index]['CheckLists'].length;

                if (state.status == TaskStatus.Loading) {
                  return AnimatedContainer(
                      height:
                      i<3.0?
                      i *
                          89:276,

                      duration: const Duration(milliseconds: 100),
                      child: CheckListWidget(
                        checkList:
                            state.tasks[widget.index]['CheckLists'],
                        id: state.tasks[widget.index]['id'], tasks: state.tasks[widget.index], team: widget.team,));
                }
                else {
                  return  AnimatedContainer
                    (

                      height:i<3? i * 89.6:277,
                      duration: const Duration(milliseconds: 100),
                      child: CheckListWidget(
                        checkList:
                        List<Map<String, dynamic>>.from(
                            state.tasks[widget.index]['CheckLists']),
                        id: state.tasks[widget.index]['id'], tasks: state.tasks[widget.index], team: widget.team,));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding buildChangeSection(MediaQueryData mediaQuery, BuildContext context,Function()onTap,bool isSelected,String text) {
    return Padding(
padding: const EdgeInsets.all(8.0),
child: SizedBox(

  width: mediaQuery.size.width/2.5,
  child: InkWell(

      onTap: onTap, child: Card(
    color: isSelected?PrimaryColor:Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(color: isSelected?PrimaryColor:textColorWhite, width: 1.0),
      ),


      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,style: PoppinsRegular(MediaQuery.devicePixelRatioOf(context)*5, isSelected?textColorWhite:textColorBlack),),
      ))),
),
);
  }

  Padding buildTimeline(BuildContext context, MediaQueryData mediaQuery,Team team ,Map<String,dynamic> task) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText("Timeline".tr(context),mediaQuery),
          InkWell(
            onTap: ()async  {
              if (await FunctionMember.isAssignedOrLoyal(team, task['AssignTo'])){
                context.read<TimelineBloc>().add(initTimeline({
                  'StartDate': widget.task['StartDate'],
                  'Deadline': widget.task['Deadline']
                }));

                modeltimelinebottomsheetbody(context, mediaQuery);}
            },
            child: BlocBuilder<GetTaskBloc, GetTaskState>(
              builder: (context, state)
              {

                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      BuildStart(mediaQuery, "Start Date".tr(context),
                          state.tasks[widget.index]['StartDate']),
                      BuildStart(mediaQuery, "Deadline".tr(context),
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

              return BlocBuilder<GetTaskBloc, GetTaskState>(

                builder: (context, state) {
                  return SingleChildScrollView(
                    child: BottomShetTaskBody(
                      context,
                      mediaQuery,
                      "Timeline".tr(context),
                      ste.timeline['StartDate'],
                      ste.timeline['Deadline'],
                      "Start Date".tr(context),
                      "Deadline".tr(context),
                      widget.task ["id"],),
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
                      const ChangeTextFieldsTitle(TextFieldsTitle.Inactive));
                },
                icon: const Icon(Icons.cancel, color: PrimaryColor, size: 20,))
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
                TaskName, ()async  {

                  if (await FunctionMember.isAssignedOrLoyal(widget.team, widget.task["AssignTo"])){
              context.read<TaskVisibleBloc>().add(
                  const ChangeTextFieldsTitle(TextFieldsTitle.Active));
              FocusScope.of(context).requestFocus(taskNameFocusNode);}
            },
                "TaskName here",
                mediaQuery,
                    () {
                      final inputFields input=inputFields(taskid: widget.task['id'], teamid: widget.team.id, file: null, memberid: null, status: null, Deadline: null, StartDate: null, name: TaskName.text, task: null, isCompleted: null, member: null, fileid: null, );

                  context.read<GetTaskBloc>().add(UpdateTaskName(
                      input));
                  context.read<TaskVisibleBloc>().add(
                      const ChangeTextFieldsTitle(TextFieldsTitle.Inactive));
                  context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));

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
              child: const Icon(Icons.access_time_rounded,),
            ),
            BlocBuilder<localeCubit, LocaleState>(
  builder: (context, state) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(date, style: PoppinsRegular(15, ThirdColor),),
                Text(DateFormat("MMM,dd,yyyy",state.locale==const Locale("en")?"en":'fr').format(time),
                  style: PoppinsRegular(
                      mediaQuery.devicePixelRatio * 4, textColorBlack),),
              ],
            );
  },
)

          ],


        ),

      ),
    );
  }

  Widget buildAssignTo(BuildContext context, MediaQueryData mediaQuery,Team team,Map<String, dynamic> task) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: BlocBuilder<GetTaskBloc, GetTaskState>(
        builder: (context, state) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: paddingSemetricVertical(),
                  child: buildText("Members".tr(context),mediaQuery),
                ),

                Row(
                  children: [
                    state.tasks[widget.index]['AssignTo'].isEmpty ||
                        state.tasks[widget.index]['AssignTo']== null ? const SizedBox() :

                    GestureDetector(
                      onTap: (){
                        buildAssignBottomSheetBuilderFunction(context, mediaQuery, state);

                      },
                      child: DeatailsTeamComponent.membersTeamImage(
                          context, mediaQuery,     state.tasks[widget.index]["AssignTo"].length,
                          state.tasks[widget.index]["AssignTo"],30,40),
                    ),
          ProfileComponents.buildFutureBuilder(AddAssignToWidget(context, mediaQuery, state), true, "", (p0) => FunctionMember.isAssignedOrLoyal(team,task["AssignTo"] ))

                  ],
                ),
              ]
          );
        },
      ),
    );
  }

  Padding AddAssignToWidget(BuildContext context, MediaQueryData mediaQuery, GetTaskState state) {
    return Padding(
                    padding:paddingSemetricHorizontal(),
                    child: buildAddButton(() {
                      buildAssignBottomSheetBuilderFunction(context, mediaQuery, state);
                    }),
                  );
  }

  void buildAssignBottomSheetBuilderFunction(BuildContext context, MediaQueryData mediaQuery, GetTaskState state) {
    return AssignBottomSheetBuilder(context, mediaQuery, (member) {
                        //delete memberr
      DerleteAssignTo(state, member, context);

    }, (member) {
      AddAssignTo(state, member, context);

    },widget.team,
                          widget.index

                      );
  }

  void DerleteAssignTo(GetTaskState state, Member member, BuildContext context) {
                    //delete memberr
    final inputFields input=inputFields(taskid: state.tasks[widget.index]['id'], teamid: widget.team.id, file: null, memberid: member.id, status: false, Deadline: null, StartDate: null, name: null, task: null, isCompleted: null, member: member, fileid: null, );

                      context.read<GetTaskBloc>().add(

                          UpdateMember(

                            input));
                      context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));
  }

  void AddAssignTo(GetTaskState state, Member member, BuildContext context) {
      final inputFields input=inputFields(taskid: state.tasks[widget.index]['id'], teamid: widget.team.id, file: null, memberid: member.id, status: true, Deadline: null, StartDate: null, name: null, task: null, isCompleted: null, member: member, fileid: null, );

    //add member
                      context.read<GetTaskBloc>().add(UpdateMember(
                          input));
                      context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));
  }

  Widget buildAttachedfile(BuildContext context, MediaQueryData mediaQuery,Team  team,Map<String, dynamic> task) {
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
                  buildText('Attached Files'.tr(context),mediaQuery),
                  ProfileComponents.buildFutureBuilder(   Padding(
                    padding: paddingSemetricHorizontal(),
                    child: buildAddButton(() async{
                      FileStorage.pickFile(mounted, context, widget.task['id']);
                      context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));

                    }
                    ),
                  ), true, "", (p0) => FunctionMember.isAssignedOrLoyal(team,task['AssignTo'] ))


                ],
              ),
            ),
            Row(
              children: [
                state.tasks[widget.index]['attachedFile'] .isEmpty ||
                    state.tasks[widget.index]['attachedFile']  == null
                    ? const SizedBox() :

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
    return const Row(
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
