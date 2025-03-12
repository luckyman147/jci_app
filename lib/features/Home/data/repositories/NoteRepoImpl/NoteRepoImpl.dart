
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/ReplyCommentModel.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';


import '../../../../../core/Handlers/Handler.dart';
import '../../../../../core/error/Failure.dart';
import '../../../domain/entities/Note.dart';
import '../../../domain/repsotories/NotesRepo.dart';
import '../../datasources/notes/CommentLocalDataSources.dart';
import '../../datasources/notes/CommentRemoteDataSources.dart';
import '../../model/CommentModel.dart';
import '../../model/ReactioNModel.dart';

class ActivityCommentRepoImpl extends ActivityCommentRepo{
  final CommentLocalDataSource commentLocalDataSource;
  final CommentRemoteDataSources commentRemoteDataSource;
  final Handler<Unit> unitHandler;
  final Handler<List<ActivityComment>> commentHandler;

  ActivityCommentRepoImpl({required this.commentLocalDataSource, required this.commentRemoteDataSource, required this.unitHandler, required this.commentHandler});

  @override
  Future<Either<Failure, Unit>> AddReply(ReplyComment ReplyActivityComment)async {
    return await unitHandler.handle(

      onCall: () {
        final comment = ReplyCommentModel.fromEntity(ReplyActivityComment);
        commentRemoteDataSource.AddReply(comment);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );

  }

  @override
  Future<Either<Failure, Unit>> DeleteReply(String ReplyActivityCommentId, String ActivityId, String ActivityCommentId) async{
    return await unitHandler.handle(

      onCall: () {
        commentRemoteDataSource.DeleteReply(ReplyActivityCommentId, ActivityId, ActivityCommentId);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> UpdateActivityComments(ActivityComment ActivityComment) async{
    return await unitHandler.handle(

      onCall: () {
        final comment = ActivityCommentModel.fromEntity(ActivityComment);
        commentRemoteDataSource.UpdateComment(comment, ActivityComment.Commentid);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );

  }

  @override
  Future<Either<Failure, Unit>> UpdateReply(ReplyComment ReplyActivityComment, ) async{
    return await unitHandler.handle(

      onCall: () {
        final comment = ReplyCommentModel.fromEntity(ReplyActivityComment);
        commentRemoteDataSource.UpdateReply(comment,);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );

  }

  @override
  Future<Either<Failure, Unit>> addActivityComments(String activityId, ActivityComment ActivityComment)async {
    return await unitHandler.handle(

      onCall: () {
        final comment = ActivityCommentModel.fromEntity(ActivityComment);
        commentRemoteDataSource.CreateComment(comment, activityId);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );

  }

  @override
  Future<Either<Failure, Unit>> deleteActivityComments(String activityId, String ActivityCommentId) async{
    return await unitHandler.handle(

      onCall: () {
        commentRemoteDataSource.DeleteComment( ActivityCommentId,activityId,);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );
  }

  @override
  Stream<Either<Failure, List<ActivityComment>>> getAllActivityComments(String activityId, String? startAfterCreatedAt, int limit) async*{
    yield* commentHandler.handleSTream(
      onCall: () async*{ final comments= commentRemoteDataSource.getComments(activityId, startAfterCreatedAt,  limit);

        yield* comments;
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> saveExcelFile(Uint8List file, String filename) {
    // TODO: implement saveExcelFile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> AddReactions(Reaction reaction, String StringActivityCommentId) async{
    return await unitHandler.handle(

      onCall: () {
        final reactionModel=ReactionModel.fromEntity(reaction);
        commentRemoteDataSource.AddReactions(reactionModel, StringActivityCommentId);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> UpdateReactions(Reaction reaction, String StringActivityCommentId) async{
    return await unitHandler.handle(

      onCall: () {
        final reactionModel=ReactionModel.fromEntity(reaction);
        commentRemoteDataSource.UpdateReactions(reactionModel, StringActivityCommentId);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> AddReactionsToReply(Reaction reaction, String StringActivityCommentId, String replyId) async{
    return await unitHandler.handle(

      onCall: () {
        final reactionModel=ReactionModel.fromEntity(reaction);
        commentRemoteDataSource.AddReactionsToReply(reactionModel, StringActivityCommentId, replyId);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> UpdateReactionsToReply(Reaction reaction, String StringActivityCommentId, String replyId)   async{
    return await unitHandler.handle(

      onCall: () {
        final reactionModel=ReactionModel.fromEntity(reaction);
        commentRemoteDataSource.UpdateReactionsToReply(reactionModel, StringActivityCommentId, replyId);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> SendCommentNotifications(ActivityComment ActivityComment)async {
    return await unitHandler.handle(

      onCall: () {
        final comment = ActivityCommentModel.fromEntity(ActivityComment);
        commentRemoteDataSource.SendCommentNotifications(comment);
        return Future.value(unit);
        },
      onError: (e)  {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },
    );

  }

  @override
  Future<Either<Failure, Unit>> SendReactionNotifications(Reaction reaction, String StringActivityCommentId) {
    // TODO: implement SendReactionNotifications
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> SendReplyNotifications(ReplyComment ReplyActivityComment) {
    // TODO: implement SendReplyNotifications
    throw UnimplementedError();
  }


}