
import 'dart:typed_data';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/domain/entities/Note.dart';
import 'package:jci_app/features/Home/domain/repsotories/NotesRepo.dart';


import '../../../auth/AuthWidgetGlobal.dart';
import '../../../auth/domain/usecases/USesCasesGlobal.dart';
import '../Dtos/NoteInput.dart';

class GetCommentsOfActivityUseCase  {
  final ActivityCommentRepo commentRepository;

  GetCommentsOfActivityUseCase(this.commentRepository);

  Stream<Either<Failure,List<ActivityComment>>> call( String activityId, String? startAfterCreatedAt, {int limit=5}) async* {
    yield* commentRepository.getAllActivityComments(activityId, startAfterCreatedAt, limit);
  }
}


class AddCommentToActivityUseCase extends UseCase<Unit,NoteInput> {
  final ActivityCommentRepo commentRepository;

  AddCommentToActivityUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(NoteInput noteInput) async {
    Logger().i(noteInput.comment?.user ==null);
    return await commentRepository.addActivityComments(noteInput.activityId, noteInput.comment!);
  }
}
class UpdateCommentToActivityUseCase extends UseCase<Unit,ActivityComment> {
  final ActivityCommentRepo commentRepository;

  UpdateCommentToActivityUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(ActivityComment comment) async {
    return await commentRepository.UpdateActivityComments(comment);
  }
}
class DeleteCommentToActivityUseCase extends UseCase<Unit,NoteInput> {
  final ActivityCommentRepo commentRepository;

  DeleteCommentToActivityUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(NoteInput noteInput) async {
    return await commentRepository.deleteActivityComments(noteInput.activityId, noteInput.CommentId!);
  }
}
class AddReplyToCommentUseCase extends UseCase<Unit,ReplyComment> {
  final ActivityCommentRepo commentRepository;

  AddReplyToCommentUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(ReplyComment noteInput) async {
    return await commentRepository.AddReply(noteInput);
  }
}
class UpdateReplyToCommentUseCase extends UseCase<Unit,ReplyComment> {
  final ActivityCommentRepo commentRepository;

  UpdateReplyToCommentUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(ReplyComment noteInput) async {
    return await commentRepository.UpdateReply(noteInput);
  }
}
class SendCommentNotificationsUseCase extends UseCase<Unit,ActivityComment> {
  final ActivityCommentRepo commentRepository;

  SendCommentNotificationsUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(ActivityComment noteInput) async {
    return await commentRepository.SendCommentNotifications(noteInput);
  }
}
class DeleteReplyToCommentUseCase extends UseCase<Unit,NoteInput> {
  final ActivityCommentRepo commentRepository;

  DeleteReplyToCommentUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(NoteInput noteInput) async {
    return await commentRepository.DeleteReply(noteInput.ReplyId!, noteInput.activityId, noteInput.comment!.Commentid);
  }
}
class AddReactionsToCommentUseCase extends UseCase<Unit,NoteInput> {
  final ActivityCommentRepo commentRepository;

  AddReactionsToCommentUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(NoteInput noteInput) async {
    return await commentRepository.AddReactions(noteInput.reaction!, noteInput.CommentId!);
  }
}
class AddReactionsToReplyUseCase extends UseCase<Unit,NoteInput> {
  final ActivityCommentRepo commentRepository;

  AddReactionsToReplyUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(NoteInput noteInput) async {
    return await commentRepository.AddReactionsToReply(noteInput.reaction!, noteInput.CommentId!, noteInput.ReplyId!);
  }
}
class UpdateReactionsToCommentUseCase extends UseCase<Unit,NoteInput> {
  final ActivityCommentRepo commentRepository;

  UpdateReactionsToCommentUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(NoteInput noteInput) async {
    return await commentRepository.UpdateReactions(noteInput.reaction!, noteInput.CommentId!);
  }
}
class UpdateReactionsToReplyUseCase extends UseCase<Unit,NoteInput> {
  final ActivityCommentRepo commentRepository;

  UpdateReactionsToReplyUseCase(this.commentRepository);

  @override
  Future<Either<Failure,Unit>> call(NoteInput noteInput) async {
    return await commentRepository.UpdateReactionsToReply(noteInput.reaction!, noteInput.CommentId!, noteInput.ReplyId!,);
  }
}