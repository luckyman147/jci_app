import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:jci_app/features/Teams/domain/repository/TaskRepo.dart';

import '../../../../core/error/Exception.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/TaskLocalDataSources.dart';
import '../datasources/TaskRemoteDatasources.dart';

class TaskRepoImpl implements TaskRepo{
  final TaskRemoteDataSource taskRemoteDataSource;
  final TaskLocalDataSource taskLocalDataSource;
  final NetworkInfo networkInfo;

  TaskRepoImpl({required this.taskRemoteDataSource, required this.taskLocalDataSource,
   required this.networkInfo
  });
  @override
  Future<Either<Failure, Unit>> addChecklist(String id, String taskid, List<CheckList> checklist) {
    // TODO: implement addChecklist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Tasks>> addTask(String Teamid, String name) {
    return _getMessage(taskRemoteDataSource.AddTask(Teamid, name));
  }

  @override
  Future<Either<Failure, Unit>> deleteChecklist(String id, String taskid, String checklistid) {
    // TODO: implement deleteChecklist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(String id, String taskid) {
    // TODO: implement deleteTask
    throw UnimplementedError();
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
  }
}
