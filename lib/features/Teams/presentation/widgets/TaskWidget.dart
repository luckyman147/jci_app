import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/strings/app_strings.dart';

import '../../domain/entities/Task.dart';
import 'TaskDetailWidget.dart';
import 'TeamComponent.dart';

class TaskWidget extends StatefulWidget {
  final List<Tasks> tasks;
  final String teamid;
  const TaskWidget({Key? key, required this.tasks, required this.teamid}) : super(key: key);

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

        return InkWell(
          onTap: (){
           showModalBottomSheet(
             backgroundColor: textColorWhite,
             useSafeArea: true,
               isScrollControlled: true,
               context: context, builder: (BuildContext context) {

             return Container(
               color: textColorWhite,
                height: mediaQuery.size.height,
                 child: SafeArea(child: TaskDetailsWidget(task: widget.tasks[index], TaskNamed: _nameController,)));
           });
          },
          child: Container(
            decoration: taskDecoration
            ,

            child: Padding(
              padding: paddingSemetricVerticalHorizontal(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
              Row(
                children: [
                  buildCheckbox(index),
                  buildPadding(index, mediaQuery),
                ],
              ),
              Row(
                children: [
                  builddesc( widget.tasks[index],13),
                  widget.tasks[index].AssignTo!=null &&   widget.tasks[index].AssignTo.length>0?  widget.tasks[index].AssignTo[0]['Images']!=null && widget.tasks[index].AssignTo[0]['Images'].length>0?
                  WithPhoto(index, mediaQuery)
                      : NoPhoto(mediaQuery):SizedBox()
                ],
              ),
                    ],),
            ),
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) {

        return SizedBox(height: 10,);

      }, itemCount:min(2, widget.tasks.length,)),
    );
  }

  Padding WithPhoto(int index, MediaQueryData mediaQuery) {
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),


                    child: Image.memory(
                      base64Decode(widget.tasks[index].AssignTo[0]['Images']),
                      fit: BoxFit.cover,
                      height: mediaQuery.size.height / 20.5,
                      width: mediaQuery.size.height / 20.5,


                    )),
              );
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



  Padding buildPadding(int index, MediaQueryData mediaQuery) {
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(
                      width: mediaQuery.size.width / 3.5,
                      child: Text(widget.tasks[index].name,overflow:
                      TextOverflow.ellipsis, maxLines: 1
                          ,style:PoppinsSemiBold(mediaQuery.devicePixelRatio*4, textColorBlack, TextDecoration.none)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('MMM,dd').format(widget.tasks[index].Deadline),style:PoppinsRegular(mediaQuery.devicePixelRatio*4, textColor),),

                        widget.tasks[index].CheckLists.isEmpty?SizedBox():
                        Row(
                          children: [
                            SvgPicture.string(hierarchy),
                            Text(widget.tasks[index].CheckLists.length.toString(),style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColorBlack), ),
                          ],
                        )

                      ],

                    ),
                  ],
                ),
              );
  }

  Checkbox buildCheckbox(int index) {
    return Checkbox(
                activeColor: PrimaryColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashRadius: 70,
                checkColor: textColorWhite,
                side: BorderSide(color: textColorBlack),


                value: widget.tasks[index].isCompleted, onChanged: (bool? value) {  },);
  }
}
Widget BottomTaskSheet(MediaQueryData mediaQuery){

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


          Row(
            children: [
              myTaskButtons(),

            ],
          ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                      height: mediaQuery.size.height/3 ,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(),
                      )),
                ),
              )

            ],
          )

      ),

  );
}
Padding builddesc(Tasks tasks,double size) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),

    child: Container(
      decoration: BoxDecoration(
          color: tasks.isCompleted?Colors.green.withOpacity(.1):SecondaryColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(tasks.isCompleted?"Completed" :"Pending",style: PoppinsSemiBold(size,

              tasks.isCompleted?Colors.green:Colors.white
              , TextDecoration.none), ),
        ),
      ),),
  );}