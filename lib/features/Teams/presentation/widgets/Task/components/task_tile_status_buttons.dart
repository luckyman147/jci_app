import '../../../../../Home/Activity_Global.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../utils/TaskUtils.dart';
import 'IconActionButton.dart';

class TaskTileStatusButton {
  static Widget backward({required Tasks task, required Team team, required BuildContext context}) {
    return IconActionButton(
      icon: Icons.arrow_back,
      action: () {
        final prevStatus = TaskUtils.getPreviousStatus(task.meta.status);
        TaskUtils.ChangeStatusTask(team.meta.id, prevStatus!, task, context);
      },
      destinations: TaskUtils.getLowerStatusMenuItems(
        task.meta.status,
        context,
        team.meta.id,
        task,
      ),
    );
  }

  static Widget forward({required Tasks task, required Team team, required BuildContext context}) {
    return IconActionButton(
      icon: Icons.arrow_forward,
      action: () {
        final nextStatus = TaskUtils.getNextStatus(task.meta.status);
        TaskUtils.ChangeStatusTask(team.meta.id, nextStatus!, task, context);
      },
      destinations: TaskUtils.getHigherStatusMenuItems(
        team.meta.id,
        task.meta.status,
        task,
        context,
      ),
    );
  }
}
