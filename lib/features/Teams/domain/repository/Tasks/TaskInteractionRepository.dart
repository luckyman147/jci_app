import 'package:dartz/dartz.dart';

import '../../../../../core/error/Failure.dart';
import '../../entities/TaskFile.dart';

abstract class TaskInteractionRepository {
  // Comments
  Future<Either<Failure, Unit>> addComment(String teamId,String taskId, String comment);
  Future<Either<Failure, Unit>> updateComment(String teamId,String taskId, String commentId, String comment);
  Future<Either<Failure, Unit>> deleteComment(String teamId,String taskId, String commentId);

  // Files
 // Future<Either<Failure, String>> getFile(String fileId);
  Future<Either<Failure, TaskFile>> updateFiles(String teamId,String taskId, TaskFile file);
  Future<Either<Failure, Unit>> deleteFiles(String teamId,String taskId, String fileId);
}
