import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';

import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/error/Failure.dart';
import '../../entities/Checklist.dart';
import '../../entities/TeamUser.dart';
import '../../entities/task/Task.dart';
abstract class TaskRepository {
  Future<Either<Failure, List<Tasks>>> getTasksOfTeam(String teamId);
  Future<Either<Failure, Tasks>> getTasksById(String teamId, String taskId);

  Future<Either<Failure, Tasks>> addTask(String teamId, String name,TaskCompletionStatus status);
  Future<Either<Failure, Unit>> deleteTask(String teamId,String taskId);
  Future<Either<Failure, Unit>> updateTaskStatus(String teamId,String taskId, TaskCompletionStatus isCompleted);
  Future<Either<Failure, Unit>> updateTaskName(String teamId,String taskId, String name);
  Future<Either<Failure, Unit>> updateTimeline(String teamId,String taskId, DateTime startDate, DateTime deadline);
  Future<Either<Failure, Unit>> updateDescription(String teamId,String taskId, String description);
  Future<Either<Failure, Unit>> updateMembers(String teamId,String taskId, bool status, TeamUser member);
}
