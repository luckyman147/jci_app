import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Checklist.dart';
import '../entities/Task.dart';

abstract class TaskRepo {
  Future<Either<Failure,List<Tasks>>> getTasksOfTeam(String id);
  Future<Either<Failure,Tasks>> getTasksById(String id, String taskid);

  Future<Either<Failure,Tasks>> addTask(String Teamid, String name);
  Future<Either<Failure,Unit>> updateTask(String id,  Tasks task);
  Future<Either<Failure,Unit>> deleteTask( String taskid);
  Future<Either<Failure,Unit>> UpdateTask(String id, bool isCompleted);
  Future<Either<Failure,Unit>> UpdateChecklistStatus(String taskid, String checkid, bool isCompleted);
  Future<Either<Failure,CheckList>> addChecklist( String taskid, String name);
  Future<Either<Failure,Unit>> UpdateTaskName( String taskid, String name);
  Future<Either<Failure,Unit>> UpdateTimeline( String taskid, DateTime StartDate,DateTime Deadline);
Future <Either<Failure,Unit>> UpdateMembers(String taskid, bool Status, String memberid);
  Future<Either<Failure,Unit>> updateChecklist(String id, String taskid, String checklistid, CheckList checklist);
  Future<Either<Failure,Unit>> updateChecklistName( String taskid, String checklistid, String name);
  Future<Either<Failure,Unit>> AddComment( String taskid, String comment);
  Future<Either<Failure,Unit>> UpdateComment( String taskid,String commentId, String comment);
  Future<Either<Failure,Unit>> DeleteComment( String taskid, String commentId);
  Future<Either<Failure,Uint8List>> getFile( String fileid);

  Future<Either<Failure,Unit>> deleteChecklist(String checklistid);
  Future<Either<Failure,TaskFile>> UpdateFiles(String taskid, TaskFile file);
  Future<Either<Failure,Unit>> DeleteFiles(String taskid, String file);

}
