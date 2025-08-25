
import 'package:jci_app/features/Teams/presentation/utils/TaskUtils.dart';

import '../../../../../Home/Activity_Global.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../bloc/GetTeam/get_teams_bloc.dart';
import '../../../constants/TeamConstants.dart';
import '../components/TaskColumn.dart';

class TaskStatusBoard extends StatelessWidget {
  final List<Tasks> tasks;
  final String teamId;
  final bool isVertical;
  final Team team;



   TaskStatusBoard({
    super.key,
    required this.team,
    required this.tasks,
    required this.teamId,
      this.isVertical=false,

  });

  @override
  @override
  Widget build(BuildContext context) {
    final taskStatusTitles =TaskUtils. getTaskStatusTitles(context);
    final statuses = TaskCompletionStatus.values;

    return ListView.separated(
scrollDirection:!isVertical? Axis.horizontal: Axis.vertical, // Change to vertical if needed
      itemCount: statuses.length,
      itemBuilder: (context, index) {
  final status = statuses[index];
      final statusTasks = tasks.where((t) => t.meta.status == status).toList();



        return

          TaskColumn(
          title: taskStatusTitles[status] ?? status.name,
          status: status,
          team: team,
          color:TeamConstants. taskStatusColors[status] ?? Colors.grey,
          tasks: statusTasks,
          teamId: teamId,
        );
      },
      separatorBuilder: (context, index) =>   const SizedBox(width: 12,height: 12,),
    );
  }







}
