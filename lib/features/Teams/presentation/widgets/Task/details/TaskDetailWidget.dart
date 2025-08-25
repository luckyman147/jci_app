import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/Task/details/tas_misc_sections.dart';
import 'package:jci_app/features/Teams/presentation/widgets/Task/details/task_cxhecklist_section.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../Home/domain/enums/Privacy.dart';

import '../../../../../MemberSection/presentation/functions/functionMember.dart';
import '../../../../domain/dto/TaskIdParams.dart';
import '../../../../domain/entities/Team/Team.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../bloc/GetTasks/get_task_bloc.dart';
import '../../../bloc/GetTeam/get_teams_bloc.dart';
import '../../../bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../utils/TaskUtils.dart';
import '../components/TaskComponents.dart';
import '../components/TaskNameEditor.dart';
import '../components/TaskSelectorStatus.dart';


class TaskDetailsWidget extends StatefulWidget {
  final Tasks task;
  final Team team;

  const TaskDetailsWidget({Key? key, required this.task, required this.team})
      : super(key: key);

  @override
  State<TaskDetailsWidget> createState() => _TaskDetailsWidgetState();
}

class _TaskDetailsWidgetState extends State<TaskDetailsWidget> {
  FocusNode taskNameFocusNode = FocusNode();
  FocusNode checklistFocus = FocusNode();
  final TextEditingController controller = TextEditingController();
late TextEditingController TaskName;
  @override
  void dispose() {
    controller.dispose();
    checklistFocus.dispose();
    taskNameFocusNode.dispose();
    super.dispose();
  }
  @override
  void initState() {
     TaskName =
    TextEditingController(text: widget.task.meta.name);
     if (widget.task.content.description.isNotEmpty) {
      controller.text = widget.task.content.description;}
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var ifMeLeader= FunctionMember.isOwnerWithContext(context.read<GetTeamsBloc>().state.teamById!.members.teamLeader!.id!, context);

    var hasModify = FunctionMember.IfIhavePermission( widget.task.meta.assignToMembers, context);
    var hasTeamModify = FunctionMember.IfIhavePermission( widget.team.members.members, context);
    var hasComment = FunctionMember.IfIhavePermissionComment( widget.task.meta.assignToMembers, context);
    var hasTeamComment = FunctionMember.IfIhavePermissionComment( widget.team.members.members, context);
    var hasPermission= ifMeLeader || hasModify || hasTeamModify ;
    var hasPermissionComment= hasPermission||hasComment || hasTeamComment;
    return SingleChildScrollView(
      child: Padding(
        padding: paddingSemetricHorizontal(h: 8),
        child:
        BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
          builder: (context, state) =>

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
           TaskNameEditor(
             hasPermission: hasPermission,

             mediaQuery: mediaQuery, task: widget.task, taskNameFocusNode: taskNameFocusNode, taskNameController: TaskName,)
          ,
Container(
  decoration: taskdex,
  padding: paddingSemetricVerticalHorizontal(),
  child:
  BlocBuilder<GetTaskBloc, GetTaskState>(
    builder: (context, state) {
      final task = state.task;

      if (task == null) {
        return const SizedBox.shrink(); // Or show a loading spinner if needed
      }


      return

       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildText("Status", mediaQuery),
          const SizedBox(width: 10),
          Flexible(
            child: TaskStatusSelector(
              hasPermission: hasPermission,
              status: task.meta.status,
              teamId: widget.team.meta.id,
              taskId: widget.task,
            ),
          ),
        ],
      );
    },
  ),

),
            const SizedBox(height: 10),
            TaskMiscSections(
              task: widget.task,
              team: widget.team,
              mediaQuery: mediaQuery,
              controller: controller,
              taskNameFocusNode: taskNameFocusNode, hasPermissionAll: hasPermission,
            ),
            const SizedBox(height: 10),
            TaskChecklistSection(
              hasPermissions: hasPermission,
              task: widget.task,
              team: widget.team,
              checklistFocus: checklistFocus,
              controller: controller,
              mediaQuery: mediaQuery,
            ),
            buildComments(context,widget.team.meta.id,mediaQuery,widget.task.communication.comments.length,hasPermissionComment),

Visibility(
    visible: hasPermission,
    child:
            buildDeleteButton((){
              TaskUtils.DeleteTaskFunction(context, widget.task,widget. team.meta.id,isAnotherpage: true);

            }, context))
          ],
        ),

        ),
      ),
    );
  }

}
