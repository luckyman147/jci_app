
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/stuff/DateWidget.dart';
import 'package:jci_app/features/Teams/domain/dto/TaskIdParams.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/Teams/presentation/utils/DatePickerFiles.dart';
import 'package:jci_app/features/Teams/presentation/utils/FileStorage.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';
import 'package:open_file/open_file.dart';
import '../../../../../../core/PrimitiveUser/User.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/config/services/uploadImage.dart';
import '../../../../../Home/domain/enums/Privacy.dart';
import '../../../../../../core/Member.dart';
import '../../../../domain/entities/Team/Team.dart';
import '../../../../domain/entities/TeamUser.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../../domain/usecases/TaskUseCase.dart';
import '../../../bloc/GetTasks/get_task_bloc.dart';
import '../../../bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../bloc/Timeline/timeline_bloc.dart';
import '../../common/FilerowWidget.dart';
import '../../member/MembersTeamSelection.dart';
import '../Implementation/CommentsImpl.dart';


Widget BuildActions(Function( )act1,Function()act2)=>Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    IconButton.outlined(onPressed: act2, icon: const Icon(Icons.edit),),
    IconButton.outlined(onPressed: act1, icon: const Icon(Icons.add),),
  ],
);


Widget buildComments(BuildContext context,String id,MediaQueryData media,int numComments) {
  return BlocBuilder<GetTaskBloc, GetTaskState>(
    builder: (context, state) {
      return
      Padding(padding: paddingSemetricVertical(),
          child:

    SingleChildScrollView(child:
        Container(

          width: double.infinity,
            decoration: taskdex,
            child:  Padding(
              padding: paddingSemetricVerticalHorizontal(),
              child: Column(

                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText('Comments', media),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: numComments==0?150: 150+ (numComments* 40),

                      child:     Commentsimpl(teamId: id,))

                ],
              ),
            ))));
    },
  );}
Widget buildDeleteButton(VoidCallback onPressed,BuildContext context) {
  return
    Padding(padding: paddingSemetricVertical() ,child:
    SizedBox(
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 2,
        ),
        color: Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.delete, color: Colors.red),
        label: Text(
          'Delete'.tr(context),
          style: PoppinsRegular(16, Colors.red),
        ),
      ),
    ),
  ));
}
Widget buildAddButton(Function() onadd) {
  return SizedBox(
    height: 30,
    width: 30,
    child: InkWell(
      onTap: onadd,

      child: Container(

          decoration: BoxDecoration(
            border: Border.all(color: textColorWhite,width:1),
            shape: BoxShape.circle,
            color: PrimaryColor,
          ),

          child: const Center(child: Icon(Icons.add_rounded,color: textColorWhite,))), ),
  );
}
Widget AddFileButton(Function() onAdd, {String text = "Attach File"}) {
  return InkWell(
    onTap: onAdd,
    child: DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      dashPattern: [6, 3],
      color: textColor, // Use your theme or preferred color
      strokeWidth: 2,
      child: Container(


        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(20),
        ),
        child:
        Row(

          children: [
            const Icon(
              Icons.attach_file,
              color: textColor,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: PoppinsRegular(
                19,
                ColorsApp.textColor,
              ),
            ),
          ],
        ),


      ),
    ),
  );
}
Text buildText(String text,MediaQueryData mediaQuery) => Text(text,style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColor),);

Widget BorderSelection(String text , Section sec) {
  return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
    builder: (context, state) {
      return Padding(
        padding: paddingSemetricHorizontal(),
        child: InkWell(
          onTap: () {
            context.read<TaskVisibleBloc>().add(ChangeSectionEvent(sec));
          },
          child: Container(
            decoration: BoxDecoration(

                border: Border(
                  bottom: BorderSide(
                    color: PrimaryColor,
                    width: state.section==sec?2.0:0,
                  ),
                )
            ),

            child: Text(text,style: PoppinsRegular(12, state.section==sec?textColorBlack:ThirdColor),),),
        ),
      );
    },
  );
}

Widget buildTextField(FocusNode tasknode,bool title, TextEditingController TaskName,
    Function() onTap,String hintText,MediaQueryData mediaQuery,

    Function() OnPressed
    ,{int minlines = 1}
    ) {

  return
    BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return !title?
        SizedBox(

            width: mediaQuery.size.width/1.5,
            child: buildTextName(onTap, TaskName)):SizedBox(
            width: mediaQuery.size.width/1.5,


            child: buildtextfield(
                minlines: minlines,

                tasknode,title,TaskName, hintText,OnPressed  ));
      },
    );
}

Padding buildTextName(Function() onTap, TextEditingController TaskName) {
  return Padding(
    padding: paddingSemetricVerticalHorizontal(),
    child: InkWell(
        onTap: onTap,
        child: Text(TaskName.text,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: PoppinsRegular(20, textColorBlack),)),

  );
}

Padding buildtextfield(FocusNode taskNode,bool isTrue,TextEditingController TaskName,

    String hintText,Function() OnPressed,{int minlines=1}) {
  return Padding(
    padding: paddingSemetricVerticalHorizontal(),
    child: TextField(
      focusNode:taskNode ,
      style: PoppinsRegular(20  , textColorBlack),
      controller:TaskName,
cursorColor: ColorsApp.PrimaryColor,
      minLines: minlines,

      enabled: isTrue,
      decoration: InputDecoration(

          border: InputBorder.none,
          focusedBorder: InputBorder.none,

          suffixIcon: IconButton(
            onPressed: OnPressed,
            icon: const Icon(Icons.check_circle,color: Colors.green,size: 20,),
          ),

          hintText: hintText

      ),
    ),
  );
}
Widget BottomShetTaskBody(
    BuildContext context,
    mediaQuery,String sheetTitle,
    DateTime Startdate,
    DateTime Deadlinedate,
    String hintStartTextDate,
    String hintEndTextDate,
    Tasks task,
    String teamid



    )=>SizedBox(
  height: mediaQuery.size.height / 2.5,
  width: double.infinity,
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 10,
    ),
    child: BlocBuilder<localeCubit, LocaleState>(
  builder: (context, state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sheetTitle,
          style: PoppinsSemiBold(
            mediaQuery.devicePixelRatio * 7,
            PrimaryColor,
            TextDecoration.none,
          ),
        ),
        ChooseDateWidget(
todayDate:           Startdate,

         format:  "MMM,dd,yyyy",
        onTap:   ()async{
            await DatePickerUtils. showDatePickerDialog(
                context,Startdate,(value) {

              context.read<TimelineBloc>().add(onStartDateChanged(startdate: value));

            }

            );

          },
      text:     hintStartTextDate,locale: state
        ),
        ChooseDateWidget(
        todayDate:   Deadlinedate,

         format:  "MMM,dd,yyyy",
              onTap: ()async{
            await DatePickerUtils.showDatePickerDialog(
                context,Startdate,(value) {
              context.read<TimelineBloc>().add(onEndDateDateChanged(enddate: value));


            }
            );}

          ,
        text:   hintEndTextDate,locale: state
        ),




        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: PrimaryColor,
            shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: (){
       //     final inputFields input=inputFields(taskid: taskid, teamid:null, file: null, memberid: null, status: null, Deadline: Deadlinedate, StartDate: Startdate, name: null, task: null, isCompleted: null, member: null, fileid: null, );
final param=UpdateTaskParams(taskId: task.meta.id, task: task,teamId: teamid,
Deadline: Deadlinedate,startDate: Startdate
);
          context.read<GetTaskBloc>().add(UpdateTimeline(param));
            context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));
          Navigator.pop(context);
          Navigator.pop(context);

          },
          child: Center(
            child: Text(
              "Save".tr(context),
              style: PoppinsSemiBold(
                18,
                textColorWhite,
                TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
    );
  },
),
  ),
);

void AssignBottomSheetBuilder(BuildContext context, MediaQueryData mediaQuery,
    Function(TeamUser) onRemoveTap, Function(TeamUser) onAddTap,
    Team team,

    ) {

  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return
        BlocBuilder<GetTaskBloc, GetTaskState>(
        builder: (context, state) {
          var members = team.members.members;
          var ff = state.task!.meta.assignToMembers;


          if (state.status== TaskStatus.Loading || state.status== TaskStatus.error ) {
            return const Text("");
          }
          else if  (state.status== TaskStatus.success || state.status== TaskStatus.Changed || state.status== TaskStatus.ErrorUpdate ){
            return MemberTeamSelection. MembersAssignToBottomSheet(mediaQuery, onRemoveTap, onAddTap,members,ff,context);}
          else return Container();
        }
        )
      ;
    },


  );
}









class AttachedFileWidget extends StatelessWidget {
  final List<TaskFile> fileList;
  final String idTask;

  const AttachedFileWidget({super.key, required this.fileList, required this.idTask});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: fileList.map((fileData) {
        return Padding(
            padding:paddingSemetricVertical(),
            child: FileRowWidget (fileData: fileData,mediaQuery: mediaQuery,taskId:  idTask));
      }).toList(),
    );
  }


}