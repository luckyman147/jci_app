import 'dart:typed_data';



import '../../../auth/domain/usecases/USesCasesGlobal.dart';
import '../entities/Note.dart';

abstract class ActivityCommentRepo {
  Stream<Either<Failure,List<ActivityComment>>> getAllActivityComments(String activityId, String? startAfterCreatedAt, int limit);
  Future<Either<Failure,Unit>> addActivityComments(String activityId,ActivityComment ActivityComment);
  Future<Either<Failure,Unit>> SendCommentNotifications(ActivityComment ActivityComment);
  Future<Either<Failure,Unit>> SendReplyNotifications(ReplyComment ReplyActivityComment,);
  Future<Either<Failure,Unit>> SendReactionNotifications(Reaction reaction, String StringActivityCommentId, );
  Future<Either<Failure,Unit>> deleteActivityComments(String activityId,String ActivityCommentId);
  Future<Either<Failure,Unit>> UpdateActivityComments(ActivityComment ActivityComment);
  Future<Either<Failure,Unit>> AddReactions(Reaction reaction, String StringActivityCommentId, );
  Future<Either<Failure,Unit>> AddReactionsToReply(Reaction reaction, String StringActivityCommentId,String replyId );
  Future<Either<Failure,Unit>> UpdateReactions(Reaction reaction, String StringActivityCommentId, );
  Future<Either<Failure,Unit>> UpdateReactionsToReply(Reaction reaction, String StringActivityCommentId, String replyId);


  Future<Either<Failure,Unit>> AddReply(ReplyComment ReplyActivityComment, );
  Future<Either<Failure,Unit>> DeleteReply(String ReplyActivityCommentId, String ActivityId,String ActivityCommentId);
  Future<Either<Failure,Unit>> UpdateReply(ReplyComment ReplyActivityComment, );

  Future<Either<Failure,Unit>>saveExcelFile(Uint8List file, String filename);
}