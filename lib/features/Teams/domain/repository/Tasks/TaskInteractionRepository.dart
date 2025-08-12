import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/data/models/CommentsModel.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';

import '../../../../../core/error/Failure.dart';
import '../../entities/TaskFile.dart';

abstract class TaskInteractionRepository {
  // Comments
  Future<Either<Failure, String>> addComment(TaskComment comment);
  Future<Either<Failure, Unit>> updateComment(String teamId,String taskId, String commentId, String comment);
  Future<Either<Failure, Unit>> deleteComment(String teamId,String taskId, String commentId);

  // Files
 // Future<Either<Failure, String>> getFile(String fileId);
  Future<Either<Failure, TaskFile>> updateFiles(String teamId,String taskId, TaskFile file);
  Stream<Either<Failure, UploadProgress>> uploadFiles(String teamId, String taskId, List<File> bytes );
  Future<Either<Failure, Unit>> deleteFiles(String teamId,String taskId, String fileId);
}
