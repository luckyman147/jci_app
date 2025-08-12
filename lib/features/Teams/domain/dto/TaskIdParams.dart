import 'dart:io';

import '../../../../core/PrimitiveUser/User.dart';
import '../entities/Checklist.dart';
import '../entities/TaskFile.dart';
import '../entities/TeamUser.dart';
import '../entities/task/Task.dart';

class TaskIdParams {
  final String teamId;
  final String taskId;

  TaskIdParams({required this.teamId, required this.taskId});
}

class AddTaskParams {
  final String teamId;
  final String name;
  final String? taskId;
  final TaskCompletionStatus status;

  AddTaskParams(this.taskId, {required this.teamId,

    required this.status,

    required this.name});
}

class UpdateTaskParams {
  final String taskId;
  final Tasks task;
  final String? teamId;
  final String? name;
  final String? descriptionb;
  final bool? memberStatus;
  final TeamUser? member;
  final DateTime? startDate;
  final DateTime? Deadline;

  final TaskCompletionStatus? status;


  UpdateTaskParams(
      {required this.taskId, required this.task,
        this.teamId,
        this.descriptionb,
        this.status, this.name, this.startDate, this.Deadline, this.memberStatus, this.member,

      });
  factory UpdateTaskParams.fromName(String name, Tasks task) {
    return UpdateTaskParams(
      taskId: task.meta.id,
      task:task,
      name: name,
    );
  } factory UpdateTaskParams.fromDes(String name, Tasks task) {
    return UpdateTaskParams(
      taskId: task.meta.id,
      task:task,
      descriptionb: name,
    );
  }
  factory UpdateTaskParams.fromStatus(
      String teamId,
      TaskCompletionStatus status, Tasks task) {
    return UpdateTaskParams(
      teamId: teamId,
      taskId: task.meta.id,
      task:task,
      status: status,
    );
  }
}

class ChecklistParams {
  final String teamId;
  final String taskId;
  final String checkId;
  final String name;
  final bool isCompleted;

  ChecklistParams({
    required this.teamId,
    required this.taskId,
    required this.checkId,
    required this.name,
    required this.isCompleted,
  });
}

class ChecklistUpdateParams {
  final String teamId;
  final String taskId;
  final String checkId;
  final CheckList checklist;

  ChecklistUpdateParams({
    required this.teamId,
    required this.taskId,
    required this.checkId,
    required this.checklist,
  });
}

class CommentParams {

  final String teamId;
  final String taskId;
  final String commentId;
  final String comment;

  CommentParams({
    required this.teamId,
    required this.taskId,
    required this.commentId,
    required this.comment,
  });
}

class FileParams {
  final String taskId;
  final String teamId;
  final String? fileId;
  final TaskFile? file;
  final List<File> files ;

  FileParams({
    required this.files,
    required this.teamId,
    required this.taskId,
     this.fileId,
     this.file,
  });
}
