part of 'comment_file_bloc.dart';

abstract class CommentFileEvent {}

class UploadFilesEvent extends CommentFileEvent {
  final String teamId;
  final String taskId;
  final List<File> files;

  UploadFilesEvent({
    required this.teamId,
    required this.taskId,
    required this.files,
  });
}

class AddFileToUploadEvent extends CommentFileEvent {
  final List<File> files;

  AddFileToUploadEvent({required this.files});
}

class RemoveFileFromUploadEvent extends CommentFileEvent {
  final File file;

  RemoveFileFromUploadEvent({required this.file});
}

class GetCommentsEvent extends CommentFileEvent {
  final String teamId;
  final String taskId;

   GetCommentsEvent({required this.teamId, required this.taskId});

  @override
  List<Object> get props => [teamId, taskId];
}
class ChangeStatusEvent extends CommentFileEvent {
  final CommentStatus status;
  ChangeStatusEvent  (this.status);

}

class UpdateCommentsEvent extends CommentFileEvent {
  final CommentParams params;


  UpdateCommentsEvent(this.params);

  @override
  List<Object> get props => [params];
}class DeleteCommentsEvent extends CommentFileEvent {
  final String teamId;
  final String taskId;

  final String commentId;


  DeleteCommentsEvent( this.commentId, {required this.teamId, required this.taskId});

  @override
  List<Object> get props => [teamId, taskId,commentId];
}
class AddCommentEvent extends CommentFileEvent {
final TaskComment comment;
AddCommentEvent({required this.comment});

  @override
  List<Object> get props => [comment];
}
