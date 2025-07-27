part of 'activity_comment_bloc.dart';

sealed class ActivityCommentEvent extends Equatable {
  const ActivityCommentEvent();
}

class GetActivitysComment extends ActivityCommentEvent {
  final String activityId;
  const GetActivitysComment(this.activityId);
  @override
  List<Object> get props => [activityId];
}
class AddActivityComment extends ActivityCommentEvent {
  final NoteInput noteInput;
  const AddActivityComment(this.noteInput);
  @override
  List<Object> get props => [noteInput];
}

class ToggleExpandForItemEvent extends ActivityCommentEvent {
  final String index;

  const ToggleExpandForItemEvent(this.index);

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}
class AddReplyComment extends ActivityCommentEvent {
  final ReplyComment comment;
  const AddReplyComment(this.comment);
  @override
  List<Object> get props => [comment];
}
class CheckIsAlreadyReacted extends ActivityCommentEvent {
  final List<String> reactions;
  const CheckIsAlreadyReacted(this.reactions);
  @override
  List<Object> get props => [reactions];
}
class DeleteActivityComment extends ActivityCommentEvent {
  final NoteInput comment;
  const DeleteActivityComment(this.comment);
  @override
  List<Object> get props => [comment];
}
class DeleteReplyComment extends ActivityCommentEvent {
  final NoteInput comment;
  const DeleteReplyComment(this.comment);
  @override
  List<Object> get props => [comment];
}
class UpdateActivityComment extends ActivityCommentEvent {
  final NoteInput comment;
  const UpdateActivityComment(this.comment);
  @override
  List<Object> get props => [comment];
}
class AddEmojiComment extends ActivityCommentEvent {
  final NoteInput comment;
  const AddEmojiComment(this.comment);
  @override
  List<Object> get props => [comment];
}
class UpdateReplyComment extends ActivityCommentEvent {
  final ReplyComment comment;
  const UpdateReplyComment(this.comment);
  @override
  List<Object> get props => [comment];
}
class UpdateReactionComment extends ActivityCommentEvent {
  final NoteInput comment;
  const UpdateReactionComment(this.comment);
  @override
  List<Object> get props => [comment];
}
class AddReactionReplyComment extends ActivityCommentEvent {
  final NoteInput comment;
  const AddReactionReplyComment(this.comment);
  @override
  List<Object> get props => [comment];
}
class UpdateReactionReplyComment extends ActivityCommentEvent {
  final NoteInput comment;
  const UpdateReactionReplyComment(this.comment);
  @override
  List<Object> get props => [comment];
}
class InitComment extends ActivityCommentEvent {
  final ActivityComment comment;
  final bool isEmpty;
  const InitComment(this.comment,this.isEmpty);
  @override
  List<Object> get props => [comment,isEmpty];

}
class SendCommentNotification extends ActivityCommentEvent {
  final ActivityComment comment;
  const SendCommentNotification(this.comment);
  @override
  List<Object> get props => [comment];
}

