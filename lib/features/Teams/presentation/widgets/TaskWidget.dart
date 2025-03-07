import 'dart:convert';
import 'dart:developer';
import 'dart:math';



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../domain/entities/Task.dart';
import '../../domain/entities/Team.dart';
import '../../domain/usecases/TaskUseCase.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';
import 'DetailTeamComponents.dart';
import 'DetailTeamWidget.dart';
import 'TaskDetailWidget.dart';
import 'TeamComponent.dart';

class TaskWidget extends StatefulWidget {
  final List<Map<String,dynamic>> tasks;
  final Team team;
  const TaskWidget({Key? key, required this.tasks, required this.team}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: ListView.separated(itemBuilder: (BuildContext context, int index) {

        return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
          builder: (context, state) {
            return InkWell(
              onLongPress: ()async{

                if (state.WillAdded==false && await FunctionMember.isAssignedOrLoyal(widget.team, widget.tasks[index]['AssignTo'])) {
                  context.read<TaskVisibleBloc>().add(DeletedTaskedEvent(false));
                }

              },
              onTap: (){

                buildShowModalBottomSheet(context, mediaQuery, widget.tasks,index,widget.team);
              },
              child:  Container(
                decoration: taskDecoration
                ,

                child: Padding(
                  padding: paddingSemetricVerticalHorizontal(),
                  child: BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
                    builder: (context, state) {
                      return Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              buildCheckBox(task: widget.tasks[index], index: index, team: widget.team,),
                              buildPadding(index, mediaQuery),
                            ],
                          ),
                          Visibility(
                              visible: !state.WillDeleted,
                              child:DeatailsTeamComponent.membersTeamImage(context, mediaQuery, widget.tasks[index]['AssignTo'].length,
                                  widget.tasks[index]['AssignTo'],30,40)
                          ), Visibility(
                              visible: state.WillDeleted,
                              child:IconButton( icon: Icon(Icons.delete, color: Colors.red, size: 30,), onPressed: () {

                                context.read<GetTaskBloc>().add(DeleteTask(widget.tasks[index]['id'], ));
                                context.read<TaskVisibleBloc>().add(DeletedTaskedEvent(true));
                                context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));


                              },)
                          ),
                        ],);
                    },
                  ),
                ),


              ),
            );
          },
        );
      }, separatorBuilder: (BuildContext context, int index) {

        return SizedBox(height: 10,);

      }, itemCount:min(5, widget.tasks.length,)),
    );
  }






  Padding buildPadding(int index, MediaQueryData mediaQuery) {
    final bool datetime = widget.tasks[index]['Deadline'].isAfter(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: mediaQuery.size.width / 2.5,
            child: Text(widget.tasks[index]['name'],overflow:
            TextOverflow.ellipsis, maxLines: 1
                ,style:PoppinsSemiBold(mediaQuery.devicePixelRatio*6, textColorBlack, TextDecoration.none)),
          ),
          BlocBuilder<localeCubit, LocaleState>(
  builder: (context, state) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('MMM,dd',state.locale==Locale('en')?"en":"fr").format(widget.tasks[index]['Deadline']),style:PoppinsRegular(mediaQuery.devicePixelRatio*5,!datetime?Colors.red:textColor ),),


              Row(
                children: [widget.tasks[index]['CheckLists'].isEmpty?SizedBox():
                Row(
                  children: [
                    SvgPicture.string(hierarchy),
                    Text(widget.tasks[index]['CheckLists'].length.toString(),style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColorBlack), ),
                    Icon(Icons.attach_file_rounded, color: textColorBlack,),
                    Text(widget.tasks[index]['attachedFile'].length.toString(),style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColorBlack), ),
                  ],
                ),
                  builddesc( widget.tasks,12,index),
                ],
              )

            ],

          );
  },
),
        ],
      ),
    );
  }


}





Padding WithPhoto(Map<String,dynamic> tasks, MediaQueryData mediaQuery) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ClipRRect(
        borderRadius: BorderRadius.circular(100),


        child: Image.memory(
          base64Decode(   tasks["AssignTo"][0]['Images'][0]['url']),
          fit: BoxFit.cover,
          height:20,
          width: 20,


        )),
  );
}
Future<dynamic> buildShowModalBottomSheet(BuildContext context, MediaQueryData mediaQuery, List<Map<String, dynamic>> tasks,int index,Team team) {
  return showModalBottomSheet(
      backgroundColor: textColorWhite,
      barrierColor: textColorWhite,
      useSafeArea: true,
      isScrollControlled: true,





      context: context, builder: (BuildContext context) {

    return Scaffold(

        body: TaskDetailsWidget(task: tasks[index], index: index, team: team,));
  });
}

Padding NoPhoto(MediaQueryData mediaQuery) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),

    child: ClipRRect(

      borderRadius: BorderRadius.circular(100),

      child: Container(
          height: mediaQuery.size.height / 20.5,
          width: mediaQuery.size.height / 20.5,
          color: textColor,
          child:Center(child:Icon(Icons.person,color: Colors.white,size: 20,))
      ),
    ),
  );
}
Widget BottomTaskSheet(MediaQueryData mediaQuery,List<Map<String, dynamic>> tasks,Team team){

  return SizedBox(
    height: mediaQuery.size.height / .9,
    width: double.infinity,
    child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,


          children: [






            Expanded(child: Padding(
              padding:paddingSemetricVertical(),
              child: BottomTasks(tasks: tasks, team: team,),
            ))

          ],
        )

    ),

  );
}
Widget builddesc(List<Map<String, dynamic>> tasks,double size,int index) {
  return BlocBuilder<GetTaskBloc, GetTaskState>(
    builder: (context, state) {
      return SizedBox(
        width: 100,
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),

          child: Container(
            decoration: BoxDecoration(
                color: tasks[index]['isCompleted']?Colors.green.withOpacity(.1):SecondaryColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(tasks[index]['isCompleted']?"Completed".tr(context) :"Pending".tr(context),style: PoppinsSemiBold(size,

                    tasks[index]['isCompleted']?Colors.green:Colors.white
                    , TextDecoration.none), ),
              ),
            ),),
        ),
      );
    },
  );}
class BottomTasks extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final Team team;
  const BottomTasks({Key? key, required this.tasks, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ListView.separated(
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: textColorWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: textColorBlack),
        ),
        child: ListTile(
          hoverColor: PrimaryColor.withOpacity(.5),

          selectedColor: PrimaryColor,
          onLongPress: (){

            context.pop();


            buildShowModalBottomSheet(context, mediaQuery, tasks,index,team);


          },
          leading: BlocBuilder<GetTaskBloc, GetTaskState>(
            builder: (context, state) {

              return buildCheckBox(task: tasks[index], index: index, team: team,);},
          ),
          title: SizedBox(
              width: mediaQuery.size.width / 20.5,

              child: Text(tasks[index]['name'],style: PoppinsRegular(15, textColorBlack),overflow: TextOverflow.ellipsis,)),
          trailing: SizedBox(
            // Wrap the trailing widget with a SizedBox to limit its width
            width: 180,
            height: 40,// Adjust width according to your needs
            child: Row(
              children: [
                SizedBox(

                    child: builddesc(tasks, 14,index)),
                tasks[index]["AssignTo"] != null &&
                    tasks[index]["AssignTo"].length > 0
                    ?    tasks[index]["AssignTo"][0]['Images'] != null &&
                    tasks[index]["AssignTo"][0]['Images'].length > 0
                    ? WithPhoto(tasks[index], mediaQuery)
                    : NoPhoto(mediaQuery)
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: tasks.length,
    );
  }
}

class buildCheckBox extends StatefulWidget {
  final Team team;
  final  Map<String,dynamic> task;
  final int index;
  const buildCheckBox({Key? key, required this.task, required this.index, required this.team}) : super(key: key);

  @override
  State<buildCheckBox> createState() => _buildCheckBoxState();
}

class _buildCheckBoxState extends State<buildCheckBox> {

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
        builder: (context, ste) {
          return BlocBuilder<GetTaskBloc, GetTaskState>(
              builder: (context, state) {


                return
                  ste.WillDeleted?Padding(
                    padding:paddingSemetricHorizontal(),
                    child: InkWell(
                        onTap: (){
                          context.read<TaskVisibleBloc>().add(DeletedTaskedEvent( true));

                        },

                        child: Icon(Icons.cancel,color:SecondaryColor)),
                  ):
                  ProfileComponents.buildFutureBuilder(buildCheckbox(context, state), true, '', (p0) => FunctionMember.isAssignedOrLoyal(widget.team, widget.task['AssignTo']))  ; }


          );
        },
      );;
  }

  Checkbox buildCheckbox(BuildContext context, GetTaskState state) {
    return Checkbox(
      activeColor: PrimaryColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashRadius: 70,
      checkColor: textColorWhite,
      side: BorderSide(color: textColorBlack),


      value:widget.task['isCompleted'], onChanged: (bool? value) {
      final inputFields input=inputFields(taskid:widget.task['id'] , teamid: null, file: null, memberid: null, status: false, Deadline: null, StartDate: null, name: null, task: null, isCompleted: value, member: null, fileid: null, );

      context.read<GetTaskBloc>().add(UpdateStatus(input, widget.index));
      context.read<TaskfilterBloc>().add(filterTask(state.tasks));
      context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));


    },);
  }
}