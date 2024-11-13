
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../../../core/app_theme.dart';
import '../../../Home/presentation/widgets/AddActivityWidgets.dart';
import '../../../../core/Member.dart';
import '../../domain/entities/Team.dart';
import '../../domain/usecases/TaskUseCase.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';
import '../bloc/Timeline/timeline_bloc.dart';
import 'MembersTeamSelection.dart';
import 'funct.dart';

Widget BuildActions(Function( )act1,Function()act2)=>Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    IconButton.outlined(onPressed: act2, icon: const Icon(Icons.edit),),
    IconButton.outlined(onPressed: act1, icon: const Icon(Icons.add),),
  ],
);

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

            child: Text(text,style: PoppinsRegular(18, state.section==sec?textColorBlack:ThirdColor),),),
        ),
      );
    },
  );
}

Widget buildTextField(FocusNode tasknode,bool title, TextEditingController TaskName,
    Function() onTap,String hintText,MediaQueryData mediaQuery, Function() OnPressed) {

  return
    BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return !title?
        SizedBox(

            width: mediaQuery.size.width/1.5,
            child: buildTextName(onTap, TaskName)):SizedBox(
            width: mediaQuery.size.width/1.5,


            child: buildtextfield(tasknode,title,TaskName, hintText,OnPressed  ));
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

Padding buildtextfield(FocusNode taskNode,bool isTrue,TextEditingController TaskName, String hintText,Function() OnPressed) {
  return Padding(
    padding: paddingSemetricVerticalHorizontal(),
    child: TextField(
      focusNode:taskNode ,
      style: PoppinsRegular(20  , textColorBlack),
      controller:TaskName,


      enabled: isTrue,
      decoration: InputDecoration(

          border: InputBorder.none,
          focusedBorder: InputBorder.none,

          suffixIcon: IconButton(
            onPressed: OnPressed,
            icon: const Icon(Icons.check_circle,color: PrimaryColor,size: 20,),
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

    String taskid,

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
        chooseDate(
          Startdate,
          mediaQuery,
          "MMM,dd,yyyy",
              ()async{
            await TeamFunction. DatePickerFun(
                context,Startdate,(value) {

              context.read<TimelineBloc>().add(onStartDateChanged(startdate: value));

            }

            );

          },
          hintStartTextDate,state
        ),
        chooseDate(
          Deadlinedate,
          mediaQuery,
          "MMM,dd,yyyy",
              ()async{
            await TeamFunction.DatePickerFun(
                context,Startdate,(value) {
              context.read<TimelineBloc>().add(onEndDateDateChanged(enddate: value));


            }
            );}

          ,
          hintEndTextDate,state
        ),




        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: PrimaryColor,
            shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: (){
            final inputFields input=inputFields(taskid: taskid, teamid:null, file: null, memberid: null, status: null, Deadline: Deadlinedate, StartDate: Startdate, name: null, task: null, isCompleted: null, member: null, fileid: null, );

            context.read<GetTaskBloc>().add(UpdateTimeline(input));
            context.pop();
            context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));

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
    Function(Member) onRemoveTap, Function(Member) onAddTap,Team team,
    int index,
    ) {

  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return  BlocBuilder<GetTaskBloc, GetTaskState>(
        builder: (context, state) {
          List<Map<String, dynamic>> members = List<Map<String, dynamic>>.from(team.Members);
          List<Map<String, dynamic>> ff = List<Map<String, dynamic>>.from(state.tasks[index]['AssignTo']);

          List<Member> membersList = members.map((e) => Member.fromImages(e)).toList();
          List<Member> ListAssignTo = ff.map((e) => Member.fromImages(e)).toList();
          if (state.status== TaskStatus.Loading || state.status== TaskStatus.error ) {
            return const Text("");
          }
          else if  (state.status== TaskStatus.success || state.status== TaskStatus.Changed || state.status== TaskStatus.ErrorUpdate ){
            return MemberTeamSelection. MembersAssignToBottomSheet(mediaQuery, onRemoveTap, onAddTap,membersList,ListAssignTo,context);}
          else return Container();
        },
      );
    },


  );
}









class AttachedFileWidget extends StatelessWidget {
  final List<Map<String, dynamic>> fileList;
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
            child: _buildFileRow(context,fileData,mediaQuery,idTask));
      }).toList(),
    );
  }

  Widget _buildFileRow(BuildContext context ,Map<String, dynamic> fileData,MediaQueryData mediaQuery,String idTask ) {

    String fileName = fileData['path'] ?? '';
    String extension = fileData['extension'] ?? '';
    IconData iconData = _getIconForExtension(extension);

    return InkWell(
      onTap: ()async  {
        await TeamFunction.openFile(context, fileData['id'],extension );
        // Open file
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(

              decoration: const BoxDecoration(
                color: PrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Icon(iconData, size: 20,color: Colors.white,)),
              )), // Adjust icon size as needed
          const SizedBox(width: 10), // Adjust as needed for spacing between icon and file name
          SizedBox(
              width: mediaQuery.size.width * 0.5,
              child: Text(fileName,overflow:TextOverflow.ellipsis , style: PoppinsRegular(12,textColorBlack))),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              IconButton(

                  onPressed: (){
                    final inputFields input=inputFields(taskid: idTask, teamid:null, file: null, memberid: null, status: null, Deadline: null, StartDate: null, name: null, task: null, isCompleted: null, member: null, fileid: fileData['id'], );

                    context.read<GetTaskBloc>().add(DeleteFileEvent(input));
                    context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));


                  }, icon: const Icon(Icons. delete,color: textColor,size: 30,)),
            ],
          ),

        ],
      ),
    );
  }


  IconData _getIconForExtension(String extension) {
    switch (extension) {
      case '.docx':
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icons.image;
      case '.mp4':
      case '.avi':
      case '.mov':
      case '.wmv':

        return Icons.video_library; // Video icon
      case '.mp3':
      case '.wav':
      case '.aac':
      case '.m4a':
      case '.ogg':
      case '.flac':

        return Icons.music_note; // Music icon
      default:
        return Icons.insert_drive_file; // Default icon for unknown extensions
    }
  }

}