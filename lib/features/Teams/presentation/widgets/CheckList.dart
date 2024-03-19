import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../domain/entities/Checklist.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';

class CheckListWidget extends StatelessWidget {
  final List<CheckList> checkList;
  const CheckListWidget({Key? key, required this.checkList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context ,index)=>Padding(
      padding: paddingSemetricHorizontal(h: 18),
      child: Container(
        decoration: BoxDecoration(
          color: textColorWhite,

          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: textColorBlack,width: 2),
        ),
        child: ListTile(


          leading: InkWell(child: Icon(checkList[index].isCompleted?
          Icons.check_box:Icons.check_box_outline_blank,color: PrimaryColor,size: 20,)),
          title: Text(checkList[index].name,style: PoppinsRegular(17, textColor),),
        ),
      ),
    ),
        separatorBuilder: (context,index)=> SizedBox(height: 10,), itemCount: checkList.length);
  }
}
Widget CheckListAddField(TextEditingController controller, String id) =>
    BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return Padding(
          padding: paddingSemetricVerticalHorizontal(h: 18),
          child: InkWell(
            onTap: () {
              context.read<TaskVisibleBloc>().add(ToggleTaskVisible(false));
            },
            child: Container(
              decoration: taskDecoration,
              child: TextField(

                controller: controller,
                onTapOutside: (rr) {
                  context.read<TaskVisibleBloc>().add(ToggleTaskVisible(true));
                },
                style: PoppinsRegular(18, textColorBlack),
                onChanged: (value) {
                  log(controller.text);
                },
                decoration: InputDecoration(


                  enabled: state.WillAdded,

                  prefixIcon: GestureDetector(
                      onTap: () {
                        context.read<TaskVisibleBloc>().add(
                            ToggleTaskVisible(true));
                      },
                      child: state.WillAdded ? Icon(Icons.cancel,color: Colors.red,) : SizedBox()
                  ),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        if (controller.text.isEmpty) {
                          SnackBarMessage.showErrorSnackBar(
                              message: "Empty Field", context: context);
                        }
                        else {
                          log(id);

                          controller.clear();
                          context.read<TaskVisibleBloc>().add(
                              ToggleTaskVisible(true));
                        }
                      },
                      child: state.WillAdded ? Icon(
                        Icons.check_circle, color: PrimaryColor,) : SizedBox()
                  ),
                  hintText: 'Add CheckList',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),

            ),
          ),
        );
      },
    );