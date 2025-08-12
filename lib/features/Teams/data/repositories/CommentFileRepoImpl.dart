import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Teams/data/datasources/CommentFileRemoteDatasource.dart';
import 'package:jci_app/features/Teams/data/models/CommentsModel.dart';

import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';

import '../../domain/repository/Tasks/TaskInteractionRepository.dart';

class CommentFileRepoImpl extends TaskInteractionRepository {
  final CommentFileRemoteDataSource remoteDataSource;
  final Handler <Unit> handler;
  final Handler <String> Stringhandler;
  final Handler <TaskFile> taskhandler;
  final Handler <UploadProgress> filehandler;
  CommentFileRepoImpl(this.handler, this.Stringhandler, this.taskhandler, this.filehandler, {required this.remoteDataSource});
  @override
  Future<Either<Failure, String>> addComment(TaskComment comment)async {

    return await Stringhandler.handle(
  onCall:    () => remoteDataSource.addComment(CommentModel.fromEntity(comment)),
  onError:     (result) {
    Failure.fromException(result);
  }
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteComment(String teamId, String taskId, String commentId)async {
    return await handler.handle(
      onCall: () => remoteDataSource.deleteComment(teamId, taskId, commentId),
      onError: (result) {
        Failure.fromException(result);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteFiles(String teamId, String taskId, String fileId) async{
    return await handler.handle(
      onCall: () => remoteDataSource.deleteFile(teamId, taskId, fileId),
      onError: (result) {
        Failure.fromException(result);
      },
    );
  }

/*  @override
  Future<Either<Failure, List<TaskFile>> getFile(String fileId) async{
    return await Stringhandler.handle(
      onCall: () => remoteDataSource.getFiles(fileId),
      onError: (result) {
        if (result is Exception) {
          throw result;
        }
      },
    );
  }
*/
  @override
  Future<Either<Failure, Unit>> updateComment(String teamId, String taskId, String commentId, String comment) {
    // TODO: implement updateComment
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TaskFile>> updateFiles(String teamId, String taskId, TaskFile file) {
    // TODO: implement updateFiles
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, UploadProgress>> uploadFiles(String teamId, String taskId, List<File> bytes ) async*{
      yield* filehandler.handleSTream(
      onCall: () async*{ yield* remoteDataSource.uploadFile(teamId:  teamId,taskId:  taskId,files: bytes);},
      onError: (result) {
     throw   Failure.fromException(result);
      },
    );
  }
  // This class is currently empty, but it can be extended in the future
  // to implement methods related to comment file operations.

  // For example, you might want to add methods like:
  // - uploadCommentFile
  // - downloadCommentFile
  // - deleteCommentFile
  // - listCommentFiles

  // Each method would handle the specific logic related to comment files.
}