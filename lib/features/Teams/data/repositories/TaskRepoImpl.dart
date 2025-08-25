import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Teams/data/models/CheckListModel.dart';
import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Task.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/Teams/domain/repository/Tasks/TaskRepo.dart';

import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/TeamUser.dart';
import '../datasources/TaskLocalDataSources.dart';
import '../datasources/TaskRemoteDatasources.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;
final Handler<List<Tasks>> tasksHandler;
final Handler<Tasks> taskHandler;
final Handler<Unit> unitHandler;

  TaskRepositoryImpl(this.tasksHandler, this.taskHandler, this.unitHandler, {required this.remote, required this.local,});

  @override
  Future<Either<Failure, List<Tasks>>> getTasksOfTeam(String teamId) async {

  return await  tasksHandler.handle(onCall: () async  {
    final tasks = await remote.getTasksOfTeam(teamId);
    local.cacheTasks(tasks);
    return tasks;
  },
      onError: (e)=> Failure.fromException(e),
      onFailConnection: ()async{
        final cached = await local.getAllCachedTasks();
        return cached;
      });
  }

  @override
  Future<Either<Failure, Tasks>> getTasksById(String teamId, String taskId) async {
    return await  taskHandler.handle(onCall: () async  {
      final tasks = await remote.getTasksById(teamId,taskId);

      return tasks;
    },
        onError: (e) => Failure.fromException(e),
        );
  }

  @override
  Future<Either<Failure, Tasks>> addTask(String teamId, String name,TaskCompletionStatus status) async  {
    return _handleData(remote.addTask(teamId, name,status));
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String teamId,String taskId)async {
    return await _handleUnit(remote.deleteTask(teamId,taskId));
  }




  @override
  Future<Either<Failure, Unit>> updateTimeline(String teamId,String taskId, DateTime start, DateTime deadline) {
    return _handleUnit(remote.updateTimeline(teamId,taskId, start, deadline));
  }

  @override
  Future<Either<Failure, Unit>> updateTaskName(String teamId,String taskId, String name) {
    return _handleUnit(remote.updateTaskName( teamId,taskId, name));
  }

  @override
  Future<Either<Failure, Unit>> updateMembers(String teamId,String taskId, bool status, TeamUser memberId) {
    return _handleUnit(remote.updateMembers(teamId,taskId, status, memberId));
  }

  Future<Either<Failure, Tasks>> _handleData(Future<Tasks> future) async {
    return await taskHandler.handle(onCall: () async {
      final data = await future;
      return data;
    },
    onError: (e) {
      Failure.fromException(e);
    });
  }

  Future<Either<Failure, Unit>> _handleUnit(Future<Unit> future) async {
    return await unitHandler.handle(onCall: () async {


          await future;
          return Future.value(unit);

      },
      onError: (e) {
      Failure.fromException(e);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> updateTaskStatus(String teamId,String taskId, TaskCompletionStatus isCompleted) {
    return _handleUnit(remote.updateIsCompleted(teamId,taskId, isCompleted));

  }

  @override
  Future<Either<Failure, Unit>> updateDescription(String teamId, String taskId, String description) async{

    return await _handleUnit(remote.updateTaskDescription(teamId, taskId, description));
  }

  @override
  Future<Either<Failure, Unit>> updateMembersRole(String teamId, String taskId, String newRole, String memberId) async{
    return await _handleUnit(remote.updateMembersRole(teamId, taskId, newRole, memberId));

  }
}

