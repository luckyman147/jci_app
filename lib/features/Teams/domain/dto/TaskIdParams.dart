import '../entities/Checklist.dart';
import '../entities/TaskFile.dart';
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

  AddTaskParams(this.taskId, {required this.teamId, required this.name});
}

class UpdateTaskParams {
  final String taskId;
  final Tasks task;
  final String? teamId;
  final String? name;
  final bool? memberStatus;
  final String? memberId;
  final DateTime? startDate;
  final DateTime? Deadline;

  final TaskCompletionStatus? status;

  UpdateTaskParams(this.teamId, this.status, this.name, this.startDate, this.Deadline, this.memberStatus, this.memberId, {required this.taskId, required this.task});
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
  final String fileId;
  final TaskFile file;

  FileParams({
    required this.teamId,
    required this.taskId,
    required this.fileId,
    required this.file,
  });
}
