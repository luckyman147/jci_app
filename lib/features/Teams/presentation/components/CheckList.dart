import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/components/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/functions/functionMember.dart';
import 'package:jci_app/features/Teams/domain/usecases/TaskUseCase.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../domain/entities/Checklist.dart';
import '../../domain/entities/Team/Team.dart';
import '../../domain/entities/task/Task.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';

class CheckListWidget extends StatelessWidget {
  final List<CheckList> checkList;
  final Tasks tasks;
  final String teamId;


  const CheckListWidget(
      {Key? key,
      required this.checkList,

      required this.tasks,
      required this.teamId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => Padding(
              padding: paddingSemetricHorizontal(h: 18),
              child: BlocBuilder<GetTaskBloc, GetTaskState>(
                builder: (context, state) {
                  return Container(
                      decoration: buildBoxDecoration(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: textColor, width: 1.5),
                        ),
                        child: Row(
                          children: <Widget>[

                                buildCheckbox(index, context),


                            Expanded(
                              child: buildTextField(index, tasks.meta.id, context),
                            ),

                                buildIconButton(context, index),



                          ],
                        ),
                      ));
                },
              ),
            ),
        separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
        itemCount: checkList.length);
  }

  IconButton buildIconButton(BuildContext context, int index) {
    return IconButton(
      onPressed: () {

        context.read<GetTaskBloc>().add(DeleteChecklistEvent(
            teamId, tasks.meta.id, checkList[index].id));

        context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
        size: 20,
      ),
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
          offset: const Offset(0, 1), // changes position of shadow
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
      side: const BorderSide(color: textColorBlack),
      value: checkList[index].isCompleted,
      onChanged: (bool? value) {
        context.read<GetTaskBloc>().add(UpdateChecklistStatusEvent(teamId, tasks.meta.id, checkList[index].id, value?? false));


        context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));
      },
    );
  }

  TextField buildTextField(int index, String id, BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {


        context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));
      },
      onChanged: (value) {},
      enabled: true,
      controller: TextEditingController(text: checkList[index].name),
      style: PoppinsSemiBold(
          MediaQuery.devicePixelRatioOf(context) * 4,
          textColorBlack,
          checkList[index].isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(18),
      ),
    );
  }
}

Widget CheckListAddField(
        TextEditingController controller,
        String taskId,
        FocusNode focus,
        mediaQuery,
        String teamId,

        bool mounted) =>
    BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return Padding(
          padding: paddingSemetricVerticalHorizontal(h: 18),
          child: InkWell(
            onTap: () async {

                if (!mounted) return;
                context
                    .read<TaskVisibleBloc>()
                    .add(const ChangeWillAdded(true));
                FocusScope.of(context).requestFocus(focus);

            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: BackWidgetColor, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: !state.WillAdded
                  ? SizedBox(
                      width: mediaQuery.size.width / 1.1,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "${"Add".tr(context)} ${"Subtask"}",
                          textAlign: TextAlign.center,
                          style: PoppinsRegular(
                              MediaQuery.devicePixelRatioOf(context) * 5,
                              textColor),
                        ),
                      ))
                  : textFieldcHECKLIST(focus, controller, context, state, taskId,teamId),
            ),
          ),
        );
      },
    );

TextField textFieldcHECKLIST(FocusNode focus, TextEditingController controller,
    BuildContext context, TaskVisibleState state, String taskId,String teamId) {
  return TextField(
    focusNode: focus,
    controller: controller,
    style: PoppinsRegular(18, textColorBlack),
    decoration: InputDecoration(
      prefixIcon: GestureDetector(
          onTap: () {
            context.read<TaskVisibleBloc>().add(const ToggleTaskVisible(true));
            focus.unfocus();
          },
          child: state.WillAdded
              ? const Icon(
                  Icons.cancel,
                  color: Colors.red,
                )
              : const SizedBox()),
      suffixIcon: GestureDetector(
          onTap: () {
            if (controller.text.isEmpty) {
              SnackBarMessage.showErrorSnackBar(
                  message: "Empty Field".tr(context), context: context);
            } else {
              context.read<GetTaskBloc>().add(AddChecklistEvent(
               teamId,taskId,
                  controller.text));

              controller.clear();
              context
                  .read<TaskVisibleBloc>()
                  .add(const ChangeIsUpdatedEvent(false));
            }
          },
          child: state.WillAdded
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : const SizedBox()),
      hintText: '${"Add".tr(context)} ${"Subtask".tr(context)}',
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(18),
    ),
  );
}
