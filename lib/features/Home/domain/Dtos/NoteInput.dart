import '../entities/Note.dart';

class NoteInput{
  final String activityId;
  final ActivityComment? comment;
  final String? ReplyId;
  final String? CommentId;
  final Reaction? reaction;
  final ReplyComment? reply;



  NoteInput(this.activityId, this.comment, this.ReplyId, this.CommentId, this.reaction, this.reply);
}