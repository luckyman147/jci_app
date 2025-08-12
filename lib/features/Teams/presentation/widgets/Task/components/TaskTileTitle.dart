import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Teams/presentation/widgets/Task/components/task_tile_status_buttons.dart';

import '../../../../../Home/Activity_Global.dart';
import '../../../../domain/dto/TaskIdParams.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../bloc/GetTasks/get_task_bloc.dart';
import '../../../utils/TaskUtils.dart';
import '../../common/EditableTextField.dart';
import 'IconActionButton.dart';

class TaskTileTitle extends StatelessWidget {
  final Tasks task;
  final Team team;
  final bool isVisible;

  const TaskTileTitle({
    super.key,
    required this.task,
    required this.team,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final isRight = task.meta.status == TaskCompletionStatus.Delayed;
    final isLeft = task.meta.status == TaskCompletionStatus.Todo;

    return
      Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (!isLeft && !isVisible)
          TaskTileStatusButton.backward(task: task, team: team, context: context),

        Expanded(
          child: isVisible
              ? EditableTextField(
            onChanged: (s) {},
            initialText: task.meta.name,
            onConfirm: (newName) {
              context.read<GetTaskBloc>().add(UpdateTaskNameEvent(
                UpdateTaskParams(
                  task: task,
                  taskId: task.meta.id,
                  teamId: team.meta.id,
                  name: newName,
                ),
              ));
              context.read<TaskVisibleBloc>().add(ToggleTaskVisibleById(""));
            },
            onCancel: () {
              context.read<TaskVisibleBloc>().add(ToggleTaskVisibleById(""));
            },
          )
              :
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Expanded(
                child: AutoSizeText(
                  task.meta.name,
                  style: PoppinsRegular(14.sp, ColorsApp.textColorBlack),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

            ],
          ),
        )),

        if (!isRight && !isVisible)
          TaskTileStatusButton.forward(task: task, team: team, context: context),
      ],
    );
  }
}
