import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/Teams/presentation/utils/TaskUtils.dart';

import '../../../../domain/entities/task/Task.dart';
import '../../../constants/TeamConstants.dart';

class TaskStatusSelector extends StatelessWidget {
  const TaskStatusSelector({
    super.key,
    required this.status,
    required this.teamId,
    required this.taskId,
    this.hasPermission = true,

  });
final bool hasPermission;
  final TaskCompletionStatus status;
  final String teamId;
  final Tasks taskId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (hasPermission) {
          _showStatusBottomSheet(context);
        }},
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsApp.textColor,width: 2),
          borderRadius: BorderRadius.circular(110),
        ),
        child: Row(

          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            buildStatusCircle(status),
            Text(
              status.name.doublesWords,
              style: PoppinsRegular(14, ColorsApp.textColor),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildStatusCircle(TaskCompletionStatus status) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: TeamConstants.taskStatusColors[status],
        shape: BoxShape.circle,
      ),
    );
  }

  void _showStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final otherStatuses = TaskCompletionStatus.values
            .where((s) => s != status)
            .toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: otherStatuses.map((s) {
              return ListTile(
                leading: buildStatusCircle(s),
                title: Text(
                  s.name.doublesWords,
                  style: PoppinsRegular(16, TeamConstants.taskStatusColors[s]!),
                ),
                onTap: () {
                  // close the sheet
                  TaskUtils.ChangeStatusTask(teamId, s, taskId, context); Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
