import '../entities/Note.dart';

class NoteInput {
  final String activityId;
  final ActivityComment? comment;
  final String? ReplyId;
  final String? CommentId;
  final Reaction? reaction;
  final ReplyComment? reply;

  NoteInput(
      this.activityId,
      this.comment,
      this.ReplyId,
      this.CommentId,
      this.reaction,
      this.reply,
      );

  NoteInput copyWith({
    String? activityId,
    ActivityComment? comment,
    String? ReplyId,
    String? CommentId,
    Reaction? reaction,
    ReplyComment? reply,
  }) {
    return NoteInput(
      activityId ?? this.activityId,
      comment ?? this.comment,
      ReplyId ?? this.ReplyId,
      CommentId ?? this.CommentId,
      reaction ?? this.reaction,
      reply ?? this.reply,
    );
  }
}
