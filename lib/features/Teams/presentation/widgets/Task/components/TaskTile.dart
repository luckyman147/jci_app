import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Teams/domain/dto/TaskIdParams.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/screens/DetailsTaskScreen.dart';
import 'package:jci_app/features/Teams/presentation/utils/NavigationUtils.dart';
import 'package:jci_app/features/Teams/presentation/utils/TaskUtils.dart';
import 'package:jci_app/features/Teams/presentation/widgets/Task/components/task_tile_subtitle.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import '../../../../../../core/route/app_router.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../constants/TeamConstants.dart';
import '../../common/EditableTextField.dart';
import 'TaskTileTitle.dart';
class TaskTile extends StatelessWidget {
  final Tasks task;
  final Team team;

  const TaskTile({super.key, required this.task, required this.team});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        final isVisible = state.SelectedTaskId == task.meta.id;

        return Card(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 5.w,),
            key: Key(task.meta.id),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: TeamConstants. taskStatusColors[task.meta.status]??Colors.grey , width: 1.w),
              borderRadius: BorderRadius.circular(10.r),
            ),
            tileColor: Colors.white,
            isThreeLine: true,
            subtitle: TaskTileSubtitle(task: task, teamId: team.meta.id,),
            title: TaskTileTitle(
              task: task,
              team: team,
              isVisible: isVisible,
            ),
            onTap: () {
              context.read<GetTaskBloc>().add(initTask(task));

              NavigationUtils.    navigateTopTaskdetails(context,team,task);

            },
          ),
        );
      },
    );
  }

}
