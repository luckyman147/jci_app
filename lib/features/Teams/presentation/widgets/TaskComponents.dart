import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_theme.dart';
import '../../../Home/presentation/widgets/AddActivityWidgets.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../domain/entities/Team.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';
import '../bloc/Timeline/timeline_bloc.dart';
import 'MembersTeamSelection.dart';
import 'funct.dart';

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

          child: Center(child: Icon(Icons.add_rounded,color: textColorWhite,))), ),
  );
}

Text buildText(String text) => Text(text,style: PoppinsRegular(18, textColor),);

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

            child: Text("$text",style: PoppinsRegular(18, state.section==sec?textColorBlack:ThirdColor),),),
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

            width: mediaQuery.size.width/1.2,
            child: buildTextName(onTap, TaskName)):SizedBox(
            width: mediaQuery.size.width/1.2,


            child: buildtextfield(tasknode,title,TaskName, hintText,OnPressed  ));
      },
    );
}

Padding buildTextName(onTap(), TextEditingController TaskName) {
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
            icon: Icon(Icons.check_circle,color: PrimaryColor,size: 20,),
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
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sheetTitle,
          style: PoppinsSemiBold(
            mediaQuery.devicePixelRatio * 6,
            PrimaryColor,
            TextDecoration.none,
          ),
        ),
        chooseDate(
          Startdate,
          mediaQuery,
          "MMM,dd,yyyy",
              ()async{
            await DatePickerFun(
                context,Startdate,(value) {

              context.read<TimelineBloc>().add(onStartDateChanged(startdate: value));
            }

            );

          },
          hintStartTextDate,
        ),
        chooseDate(
          Deadlinedate,
          mediaQuery,
          "MMM,dd,yyyy",
              ()async{
            await DatePickerFun(
                context,Startdate,(value) {
              context.read<TimelineBloc>().add(onEndDateDateChanged(enddate: value));


            }
            );}

          ,
          hintEndTextDate,
        ),




        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: PrimaryColor,
            shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: (){
            log("Startdate $Startdate  Deadlinedate $Deadlinedate  taskid $taskid");
            context.read<GetTaskBloc>().add(UpdateTimeline({"StartDate":Startdate,"Deadline":Deadlinedate,"id":taskid}));
          },
          child: Center(
            child: Text(
              "Save",
              style: PoppinsSemiBold(
                18,
                textColorWhite,
                TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
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
log(ff.toString());
    List<Member> membersList = members.map((e) => Member.fromImages(e)).toList();
    List<Member> ListAssignTo = ff.map((e) => Member.fromImages(e)).toList();
    if (state.status== TaskStatus.Loading || state.status== TaskStatus.error) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else if  (state.status== TaskStatus.success || state.status== TaskStatus.Changed){
    return MembersAssignToBottomSheet(mediaQuery, onRemoveTap, onAddTap,membersList,ListAssignTo);}
    else return Container();
  },
);
        },


  );
}


