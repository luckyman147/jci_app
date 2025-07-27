import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../dto/TaskIdParams.dart';
import '../entities/TaskFile.dart';
import '../repository/Tasks/CheckListRepository.dart';
import '../repository/Tasks/TaskInteractionRepository.dart';

class AddCommentUseCase extends UseCase<Unit, CommentParams> {
  final TaskInteractionRepository repo;
  AddCommentUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(CommentParams params) {
    return repo.addComment(params.teamId,params.taskId, params.comment);
  }
}

class UpdateCommentUseCase extends UseCase<Unit, CommentParams> {
  final TaskInteractionRepository repo;
  UpdateCommentUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(CommentParams params) {
    return repo.updateComment(params.taskId, params.commentId, params.commentId,params.comment);
  }
}

class DeleteCommentUseCase extends UseCase<Unit, CommentParams> {
  final TaskInteractionRepository repo;
  DeleteCommentUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(CommentParams params) {
    return repo.deleteComment(params.teamId,params.taskId, params.commentId);
  }
}



class UpdateFileUseCase extends UseCase<TaskFile, FileParams> {
  final TaskInteractionRepository repo;
  UpdateFileUseCase(this.repo);

  @override
  Future<Either<Failure, TaskFile>> call(FileParams params) {
    return repo.updateFiles(params.teamId,params.taskId, params.file);
  }
}

class DeleteFileUseCase extends UseCase<Unit, FileParams> {
  final TaskInteractionRepository repo;
  DeleteFileUseCase(this.repo);

  @override
  Future<Either<Failure, Unit>> call(FileParams params) {
    return repo.deleteFiles(params.teamId,params.taskId, params.fileId);
  }
}
