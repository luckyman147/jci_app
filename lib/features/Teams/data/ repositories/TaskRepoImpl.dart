import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Teams/data/models/CheckListModel.dart';
import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/Teams/domain/repository/TaskRepo.dart';

import '../../../../core/error/Exception.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/TaskLocalDataSources.dart';
import '../datasources/TaskRemoteDatasources.dart';
import '../models/FileModel.dart';

class TaskRepoImpl implements TaskRepo{
  final TaskRemoteDataSource taskRemoteDataSource;
  final TaskLocalDataSource taskLocalDataSource;
  final NetworkInfo networkInfo;

  TaskRepoImpl({required this.taskRemoteDataSource, required this.taskLocalDataSource,
   required this.networkInfo
  });
  @override
  Future<Either<Failure, CheckList>> addChecklist( String taskid, String name)async  {

    return await _getCheckMessage(taskRemoteDataSource.addCheckList(taskid, name));

  }

  @override
  Future<Either<Failure, Tasks>> addTask(String Teamid, String name)async  {
    return await _getMessage(taskRemoteDataSource.AddTask(Teamid, name));
  }

  @override
  Future<Either<Failure, Unit>> deleteChecklist( String checklistid) {
return  _getMessageUnit(taskRemoteDataSource.deleteCheckList( checklistid));
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String taskid) {
    return _getMessageUnit(taskRemoteDataSource.deleteTask( taskid));
  }

  @override
  Future<Either<Failure, Tasks>> getTasksById(String id, String taskid) async{
    try {
      final remoteTask = await taskRemoteDataSource.getTasksById(id,taskid);

      return Right(remoteTask);
    } on ServerException {
      return Left(ServerFailure());
    }



  }

  @override
  Future<Either<Failure, List<Tasks>>> getTasksOfTeam(String id) async{
    if (await networkInfo.isConnected) {
      try {
        final  remoteTasks= await taskRemoteDataSource.getTasksOfTeam(id);
        taskLocalDataSource.cacheTasks(remoteTasks);
        return Right(remoteTasks);
      } on ServerException {
        return Left(ServerFailure());
      }
      on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    } else {
      try {
        final localTasks = await taskLocalDataSource.getAllCachedTasks();
        return Right(localTasks);

      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }


  }

  @override
  Future<Either<Failure, Unit>> updateChecklist(String id, String taskid, String checklistid, CheckList checklist) {
    // TODO: implement updateChecklist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateTask(String id, Tasks task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }



  Future<Either<Failure, Tasks>> _getMessage(
      Future<Tasks> task) async {
    if (await networkInfo.isConnected) {
      try {
      final tasks=  await task;
        return  Right(tasks);
      }

      on EmptyDataException {
        return Left(EmptyDataFailure());
      }
      on ServerException {
        return Left(ServerFailure());
      }
    }


    else {
      return Left(OfflineFailure());
    }
  }  Future<Either<Failure, Unit>> _getMessageUnit(
      Future<Unit> task) async {
    if (await networkInfo.isConnected) {
      try {
     await task;
        return  Right(unit);
      }


      on ServerException {
        return Left(ServerFailure());
      }
    }


    else {
      return Left(OfflineFailure());
    }
  }
  Future<Either<Failure, CheckList>> _getCheckMessage(
      Future<CheckListModel> task) async {
    if (await networkInfo.isConnected) {
      try {
      final tasks=  await task;
        return  Right(tasks);
      }

      on EmptyDataException {
        return Left(EmptyDataFailure());
      }
      on ServerException {
        return Left(ServerFailure());
      }
    }


    else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> UpdateTask(String id, bool isCompleted) async{
    return _getMessageUnit(taskRemoteDataSource.updateIscompleted(id, isCompleted));
  }

  @override
  Future<Either<Failure, Unit>> UpdateChecklistStatus(String taskid, String checkid, bool isCompleted) {
return _getMessageUnit(taskRemoteDataSource.updateChecklistStatus(taskid, checkid, isCompleted));
  }

  @override
  Future<Either<Failure, Unit>> UpdateTaskName(String taskid, String name) {
    return _getMessageUnit(taskRemoteDataSource.updateTaskName(taskid, name));
  }

  @override
  Future<Either<Failure, Unit>> UpdateTimeline(String taskid, DateTime StartDate, DateTime Deadline) {
    return _getMessageUnit(taskRemoteDataSource.UpdateTimeline(taskid, StartDate, Deadline));
  }

  @override
  Future<Either<Failure, Unit>> UpdateMembers(String taskid, bool Status, String memberid) {
    return _getMessageUnit(taskRemoteDataSource.UpdateMembers(taskid, Status, memberid));
  }

  @override
  Future<Either<Failure, Unit>> DeleteFiles(String taskid, String file) {
    return _getMessageUnit(taskRemoteDataSource.DeleteFiles(taskid, file));
  }

  @override
  Future<Either<Failure, TaskFile>> UpdateFiles(String taskid, TaskFile file)async  {
    if (await networkInfo.isConnected) {


      try {
        final _file=FileModel.fromEntity(file);

        final  remoteTasks= await taskRemoteDataSource.UpdateFiles(taskid, _file);

        return Right(remoteTasks);
      } on ServerException {
        return Left(ServerFailure());
      }
      on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    } else {
      return Left(OfflineFailure());

  }
}

  @override
  Future<Either<Failure, Unit>> updateChecklistName(String taskid, String checklistid, String name) {
    return _getMessageUnit(taskRemoteDataSource.UpdateChecklistName(taskid, checklistid, name));
  }

  @override
  Future<Either<Failure, Unit>> AddComment(String taskid, String comment)async {
    return _getMessageUnit(taskRemoteDataSource.AddComment(taskid, comment));
  }

  @override
  Future<Either<Failure, Unit>> DeleteComment(String taskid, String commentId) {
    return _getMessageUnit(taskRemoteDataSource.DeleteComment(taskid, commentId));
  }

  @override
  Future<Either<Failure, Unit>> UpdateComment(String taskid, String commentId, String comment) {
    return _getMessageUnit(taskRemoteDataSource.UpdateComment(taskid, commentId, comment));
  }}
