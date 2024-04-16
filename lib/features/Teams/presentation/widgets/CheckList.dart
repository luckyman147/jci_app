import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../domain/entities/Checklist.dart';
import '../../domain/entities/Team.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';

class CheckListWidget extends StatelessWidget {
  final List<Map<String,dynamic>> checkList;
  final Map<String,dynamic> tasks;
  final Team team;
  final String id ;

  const CheckListWidget({Key? key, required this.checkList, required this.id, required this.tasks, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context, index) =>
        Padding(
          padding: paddingSemetricHorizontal(h: 18),
          child: BlocBuilder<GetTaskBloc, GetTaskState>(
            builder: (context, state) {
              return Container(
                decoration:  buildBoxDecoration(),
                child: ListTile(
                  minVerticalPadding: 5,
                  enableFeedback: true,
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color:textColor, width: 1.5)),

                  leading:
              ProfileComponents.buildFutureBuilder(buildCheckbox(index, context), true, id, (p0) => FunctionMember.isAssignedOrLoyal(team, tasks['AssignTo'])),
                  title: buildTextField(index,id,context),


                  trailing:
                  ProfileComponents.buildFutureBuilder(                  buildIconButton(context, index),
                      true, id, (p0) => FunctionMember.isAssignedOrLoyal(team, tasks['AssignTo'])),

                ),
              );
            },
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(height: 10,),
        itemCount: checkList.length);
  }

  IconButton buildIconButton(BuildContext context, int index) {
    return IconButton(
                  onPressed: () {
                      context.read<GetTaskBloc>().add(DeleteChecklist(id,checkList[index]['id']));
                      context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));

                  },
                  icon: Icon(Icons.delete, color: Colors.red, size: 20,),
                );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],

                borderRadius: BorderRadius.circular(15),

              );
  }

  Checkbox buildCheckbox(int index, BuildContext context) {
    return Checkbox(
                  activeColor: PrimaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashRadius: 70,
                  checkColor: textColorWhite,
                  side: BorderSide(color: textColorBlack),


                  value:checkList[index]['isCompleted'], onChanged: (bool? value) {

                  context.read<GetTaskBloc>().add(UpdateChecklistStatus({"taskid":id,"checkid":checkList[index]['id'],
                    "IsCompleted":value }));
                  context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));


    },);
  }

  TextField buildTextField(int index,String id,BuildContext context) {
    return TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value){
                    context.read<GetTaskBloc>().add(UpdateChecklistName({"taskid":id,"checkid":checkList[index]['id'],
                      "name":value }));
                    context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));

                  },
        onChanged: (value){

        },
                  enabled: true,
                  controller: TextEditingController(
                      text: checkList[index]['name']),
                  style: PoppinsSemiBold(18, textColorBlack,checkList[index]["isCompleted"]?TextDecoration.lineThrough:TextDecoration.none),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                );
  }
}

Widget CheckListAddField(TextEditingController controller, String id,FocusNode focus,mediaQuery,Team team,Map<String, dynamic> task,bool mounted ) =>
    BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return Padding(
          padding: paddingSemetricVerticalHorizontal(h: 18),
          child: InkWell(
            onTap: () async {
              if (await FunctionMember.isAssignedOrLoyal(team, task['AssignTo'])){
                if (!mounted) return ;
              context.read<TaskVisibleBloc>().add(ToggleTaskVisible(false));
            FocusScope.of(context).requestFocus(focus);}
            },
            child: Container(




              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: BackWidgetColor, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child:
              !state.WillAdded? SizedBox(


                      width: mediaQuery.size.width/1.1,

                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Add CheckList",textAlign: TextAlign.center ,style: PoppinsRegular(18, textColor),),
                  )):

              textFieldcHECKLIST(focus, controller, context, state, id),

            ),
          ),
        );
      },
    );

TextField textFieldcHECKLIST(FocusNode focus, TextEditingController controller, BuildContext context, TaskVisibleState state, String id) {
  return TextField(
focusNode: focus ,
              controller: controller,

              style: PoppinsRegular(18, textColorBlack),

              decoration: InputDecoration(

                prefixIcon: GestureDetector(
                    onTap: () {
                      context.read<TaskVisibleBloc>().add(
                          ToggleTaskVisible(true));
                    focus.unfocus();
                    },
                    child: state.WillAdded ? Icon(
                      Icons.cancel, color: Colors.red,) : SizedBox()
                ),
                suffixIcon: GestureDetector(
                    onTap: () {
                      if (controller.text.isEmpty) {
                        SnackBarMessage.showErrorSnackBar(
                            message: "Empty Field", context: context);
                      }
                      else {

                        context.read<TaskVisibleBloc>().add(
                            ToggleTaskVisible(true));
                        context.read<GetTaskBloc>().add(AddCheckList(
                            {"idTask": id, "checklist": controller.text}));


                        controller.clear();
                        context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));

                      }
                    },
                    child: state.WillAdded ? Icon(
                      Icons.check_circle, color: PrimaryColor,) : SizedBox()
                ),
                hintText: 'Add CheckList',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
            );
}