import 'package:auto_route/auto_route.dart';

import '../../../../core/config/services/TeamStore.dart';
import '../../../../core/route/app_router.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../Home/Activity_Global.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/GetTeam/get_teams_bloc.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';

class TeamListeners{
  static void init(String id, BuildContext context) async {
    final store = await TeamStore.getUpdated();
    context.read<GetTaskBloc>().add(GetTasks(id: id, filter: TaskFilter.All));
    context.read<TaskVisibleBloc>().add(const ToggleTaskVisible(true));
    context
        .read<GetTeamsBloc>()
        .add(GetTeamById({"id": id, "isUpdated": store}));
  }

  static void ListenerDelete(
      GetTeamsState state, BuildContext context, String id) {
    if (state.status == TeamStatus.Deleted) {
      SnackBarMessage.showSuccessSnackBar(
          message: "Deleted Succefully", context: context);
      context.navigateTo(HomeRoute());

      context.read<GetTaskBloc>().add(resetevent());
    } else if (state.status == TeamStatus.DeletedError) {
      SnackBarMessage.showErrorSnackBar(
          message: "Error Deleting", context: context);
      context
          .read<GetTeamsBloc>()
          .add(GetTeamById({"id": id, "isUpdated": false}));
    }
  }

}