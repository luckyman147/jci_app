import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Checklist.dart';
import '../entities/Task.dart';

abstract class TaskRepo {
  Future<Either<Failure,List<Tasks>>> getTasksOfTeam(String id);
  Future<Either<Failure,Tasks>> getTasksById(String id, String taskid);

  Future<Either<Failure,Unit>> addTask(String Teamid, Tasks task);
  Future<Either<Failure,Unit>> updateTask(String id,  Tasks task);
  Future<Either<Failure,Unit>> deleteTask(String id, String taskid);
  Future<Either<Failure,Unit>> addChecklist(String id, String taskid, List<CheckList> checklist);
  Future<Either<Failure,Unit>> updateChecklist(String id, String taskid, String checklistid, CheckList checklist);
  Future<Either<Failure,Unit>> deleteChecklist(String id, String taskid, String checklistid);

}
