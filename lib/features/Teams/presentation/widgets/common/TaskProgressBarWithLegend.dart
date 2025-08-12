import '../../../../Home/Activity_Global.dart';
import '../../../domain/entities/task/Task.dart';
import '../../constants/TeamConstants.dart';
import '../../utils/TaskUtils.dart';

class TaskProgressBarWithLegend extends StatelessWidget {
  final List<Tasks> tasks;

  const TaskProgressBarWithLegend({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width * 0.9;

    final Map<TaskCompletionStatus, int> statusCounts = {
      for (var status in TaskCompletionStatus.values)
        status: tasks.where((task) => task.meta.status == status).length,
    };

    final totalTasks = tasks.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // PROGRESS BAR
      Center(child:   Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: TaskCompletionStatus.values.map((status) {
            final count = statusCounts[status]!;
            final percent = totalTasks == 0 ? 0.0 : count / totalTasks;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: width * percent,
              height: 10,
              decoration: BoxDecoration(
                color: TeamConstants.taskStatusColors[status],
                borderRadius: BorderRadius.horizontal(
                  left: status == TaskCompletionStatus.values.first
                      ? const Radius.circular(18)
                      : Radius.zero,
                  right: status != TaskCompletionStatus.values.first
                      ? const Radius.circular(18)
                      : Radius.zero,
                ),
              ),
            );
          }).toList(),
        )),
        const SizedBox(height: 8),
        // LEGEND (REFERENCE)
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: TaskCompletionStatus.values.map((status) {
            final count = statusCounts[status]!;
            final color = TeamConstants.taskStatusColors[status];

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  "${getTaskStatusTitle(context, status)}: $count",
                  style: PoppinsLight(10, ColorsApp.textColorBlack),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  String getTaskStatusTitle(BuildContext context, TaskCompletionStatus status) {
    final locale = Localizations.localeOf(context).languageCode;
    return TaskUtils. getTaskStatusTitles(context, locale: locale)[status] ?? status.name;
  }
}
