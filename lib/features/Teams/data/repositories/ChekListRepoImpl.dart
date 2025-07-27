import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';

import 'package:jci_app/core/error/Failure.dart';

import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';

import '../../domain/repository/Tasks/CheckListRepository.dart';
import '../datasources/ChecklistRemoteDataSources.dart';
import '../models/CheckListModel.dart';

class CheckListRepoImpl implements ChecklistRepository {
  final ChecklistRemoteDataSource checklistRemoteDataSource;
  final Handler<CheckList> handler;
  final Handler<Unit> unitHandler;
  final Handler<List<CheckList>> checkHandler;
  CheckListRepoImpl({
    required this.unitHandler,
    required this.checkHandler,
    required this.checklistRemoteDataSource,
    required this.handler,
  });

  @override
  Future<Either<Failure, CheckList>> addChecklist(String teamId, String taskId, String name)async {
    return await handler.handle(
   onCall:    () => checklistRemoteDataSource.addChecklist(teamId, taskId, name),
    onError: (e)=> Failure.fromException(e),
    );

  }

  @override
  Future<Either<Failure, Unit>> deleteChecklist(String teamId, String tasKId, String checklistId) async{
    return await unitHandler.handle(
      onCall: () => checklistRemoteDataSource.deleteChecklist(teamId, tasKId, checklistId),
      onError: (e) => Failure.fromException(e),
    );
  }

  @override
  Future<Either<Failure, List<CheckList>>> fetchChecklists(String taskId, String name)async {
    return await checkHandler.handle(
      onCall: () => checklistRemoteDataSource.getChecklists(taskId, name),
      onError: (e) => Failure.fromException(e),
    );

  }

  @override
  Future<Either<Failure, Unit>> updateChecklist(String teamId, String taskId, String checklistId, CheckList checklist) async{
    return await unitHandler.handle(
      onCall: () => checklistRemoteDataSource.updateChecklist(teamId, taskId, checklistId, CheckListModel.fromEntity(checklist)),
      onError: (e) => Failure.fromException(e),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateChecklistName(String teamId, String taskId, String checklistId, String name) async{
    return await unitHandler.handle(
      onCall: () => checklistRemoteDataSource.updateChecklistName(teamId, taskId, checklistId, name),
      onError: (e) => Failure.fromException(e),
    );

  }

  @override
  Future<Either<Failure, Unit>> updateChecklistStatus(String teamId, String taskId, String checklistId, bool isCompleted) async{
    return await unitHandler.handle(
      onCall: () => checklistRemoteDataSource.updateChecklistStatus(teamId, taskId, checklistId, isCompleted),
      onError: (e) => Failure.fromException(e),
    );
  }

}