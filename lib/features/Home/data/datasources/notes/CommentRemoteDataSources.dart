import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/shared.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:jci_app/features/Home/data/model/ReactioNModel.dart';
import 'package:jci_app/features/Home/data/model/ReplyCommentModel.dart';
import 'package:jci_app/features/Home/domain/entities/Note.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import "package:http/http.dart" as http;

import 'package:firebase_database/firebase_database.dart';

import '../../../../../core/config/env/urls.dart';
import '../../model/CommentModel.dart';
abstract class CommentRemoteDataSources{
  Future<Unit> CreateComment(ActivityCommentModel comment,String ActivityId, );
  Future<Unit> UpdateComment( ActivityCommentModel comment, String ActivityId, );
  Future<Unit> DeleteComment(String CommentId, String ActivityId, );
  Future<Unit> AddReply(ReplyCommentModel Replycomment, );
  Future<Unit> UpdateReply(ReplyCommentModel Replycomment, );
  Future<Unit> DeleteReply(String ReplycommentId, String ActivityId,String CommentId, );



  Stream<List<ActivityCommentModel>> getComments(String ActivityId, String? startAfterCreatedAt, int limit );

  Future<Unit>  UpdateReactionsToReply(ReactionModel reactionModel, String stringActivityCommentId, String replyId,) ;

  Future<Unit>  AddReactionsToReply(ReactionModel reactionModel, String stringActivityCommentId, String replyId, ) ;

  Future<Unit>  AddReactions(ReactionModel reactionModel, String stringActivityCommentId ,) ;

  Future<Unit>  UpdateReactions(ReactionModel reaction, String stringActivityCommentId,) ;

  Future<Unit > SendCommentNotifications(ActivityCommentModel comment) ;
}
class CommentRemoteDataSourcesImpl implements CommentRemoteDataSources {
  final FirebaseDatabase databaseReference;
  final Logger logger ;

  CommentRemoteDataSourcesImpl(this.logger, {required this.databaseReference});
  @override
  Future<Unit> CreateComment(ActivityCommentModel comment, String ActivityId) async{

try {
  Logger().d(ActivityId);
  Logger().d(comment.toJson());
  await    databaseReference.ref("Comments").child(ActivityId).child('comments').child(comment.Commentid).set(comment.toJson());
  logger.d("sssssss");
  await SendCommentNotifications(comment);
  logger.d('sended');
  return unit;
} on FirebaseException catch (e) {
  // Handle Firebase-specific exceptions
  switch (e.code) {
    case 'permission-denied':
      throw UnauthorizedException();
      break;
    case 'unavailable':
   throw NotFoundException();
   
    default:
      logger.e(e);
     rethrow;
  }
} catch (e) {
 logger.e(e);
  rethrow; 
  
}
  }

  @override
  Future<Unit> DeleteComment(String CommentId, String ActivityId)async {
    try {
      logger.d(CommentId);
      logger.d(ActivityId);

      await databaseReference.ref("Comments").child(ActivityId).child('comments').child(CommentId).remove();
      logger.d(CommentId);    return unit;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw UnauthorizedException();
        case 'unavailable':
          throw NotFoundException();
        default:
          Logger().e(e);
          rethrow;
      }
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> UpdateComment(ActivityCommentModel comment, String ActivityId)async {
    try {
      await databaseReference.ref("Comments").child(ActivityId).child('comments').child(comment.Commentid).update(comment.toJson());
      return unit;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw UnauthorizedException();
        case 'unavailable':
          throw NotFoundException();
        default:
          Logger().e(e);
          rethrow;
      }
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }
  @override
  Stream<List<ActivityCommentModel>> getComments(String activityId, String? startAfterCreatedAt, int limit ) async* {
    try {
      final commentsRef = databaseReference
          .ref("Comments")
          .child(activityId)
          .child('comments')
          .orderByChild('createdAt')

          ;

      if (startAfterCreatedAt != null) {
        commentsRef.startAt(startAfterCreatedAt);
      }

      // If there's a startAfterCreatedAt, fetch comments after that point

 // Start after the provided `createdAt`


      // Limit the results to the specified 'limit'
      commentsRef.limitToFirst(limit);

      // Listen for real-time updates
      yield* commentsRef.onValue.map((event) {
        final dataSnapshot = event.snapshot.value;

        // Log the raw data for debugging

        if (dataSnapshot == null) {
          return []; // No comments available
        }

        // Ensure the data is a Map
        final rawValue = dataSnapshot as Map<Object?, Object?>;

        if (rawValue.isEmpty) {
          return []; // No comments available
        }

        // Map the entries to ActivityCommentModel instances
        final data = rawValue.entries.map((entry) {
          final commentData = entry.value as Map<Object?, Object?>;
          return ActivityCommentModel.fromJson(Map<String, dynamic>.from(commentData));
        }).toList();

        // Sort the data by createdAt (descending order)
       data.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // Return the data (most recent first)
        return data;
      });
    } on FirebaseException catch (e) {
      // Handle Firebase-specific exceptions
      if (e.code == 'permission-denied') throw UnauthorizedException();
      if (e.code == 'unavailable') throw NotFoundException();
      rethrow;
    } catch (e) {
      // Handle generic errors
      logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<Unit> AddReply(ReplyCommentModel Replycomment,) async{
    try {
      logger.d(Replycomment.toJson());
      await databaseReference.ref("Comments").child(Replycomment.activityId).child('comments').child(Replycomment.Commentid).child('replies').child(Replycomment.Replyid).set(Replycomment.toJson());
      await SendReplyNotifications(Replycomment);
      return unit;
    } on FirebaseException catch (e) {
      // Handle Firebase-specific exceptions
      switch (e.code) {
        case 'permission-denied':
          throw UnauthorizedException();
        case 'unavailable':
          throw NotFoundException();
        default:
          logger.e(e);
          rethrow;
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> DeleteReply(String ReplycommentId, String ActivityId, String CommentId) async{
    try {
      await databaseReference.ref("Comments").child(ActivityId).child('comments').child(CommentId).child('replies').child(ReplycommentId).remove();
      return unit;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw UnauthorizedException();
        case 'unavailable':
          throw NotFoundException();
        default:
          Logger().e(e);
          rethrow;
      }
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> UpdateReply(ReplyCommentModel Replycomment, )async {
    try {
      await databaseReference.ref("Comments").child(Replycomment.activityId).child('comments').child(Replycomment.Commentid).child('replies').child(Replycomment.Replyid).update(Replycomment.toJson());
      return unit;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw UnauthorizedException();
        case 'unavailable':
          throw NotFoundException();
        default:
          Logger().e(e);
          rethrow;
      }
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> AddReactions(ReactionModel reactionModel, String stringActivityCommentId, )async {
    try {
      await databaseReference.ref("Comments")
          .child(reactionModel.ActivityId)
          .child("comments")
          .child(stringActivityCommentId)
          .child("reactions")
          .child(reactionModel.reaction)  // Use the unique reaction ID
          .update(reactionModel.toJson());  // Update the reaction with new data
      return unit;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw UnauthorizedException();
        case 'unavailable':
          throw NotFoundException();
        default:
          Logger().e(e);
          rethrow;
      }
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }


  @override
  Future<Unit> AddReactionsToReply(ReactionModel reactionModel, String stringActivityCommentId, String replyId,)async {
    try {
      await databaseReference.ref("Comments").child(reactionModel.ActivityId).child("comments").child(stringActivityCommentId).child('replies').child(replyId).child('reactions').push().set(reactionModel.toJson());
      return unit;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw UnauthorizedException();
        case 'unavailable':
          throw NotFoundException();
        default:
          Logger().e(e);
          rethrow;
      }
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> UpdateReactions(ReactionModel reaction, String stringActivityCommentId,) async{
    try {
      await databaseReference.ref("Comments").child(reaction.ActivityId).child("comments").child(stringActivityCommentId).update(reaction.toJson());
      return unit;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw UnauthorizedException();
        case 'unavailable':
          throw NotFoundException();
        default:
          Logger().e(e);
          rethrow;
      }
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> UpdateReactionsToReply(ReactionModel reactionModel, String stringActivityCommentId, String replyId,) async{
    try {
      await databaseReference.ref("Comments").child(reactionModel.ActivityId).child("comments").child(stringActivityCommentId).child('replies').child(replyId).update(reactionModel.toJson());
      return unit;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw UnauthorizedException();
        case 'unavailable':
          throw NotFoundException();
        default:
          Logger().e(e);
          rethrow;
      }
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> SendCommentNotifications(ActivityCommentModel comment) async{
try {
  final user=await const Store().getUserId();
  final images=comment.user.Images.isNotEmpty?comment.user.Images[0]:null;
    final url =Urls. OnCommentCreatedUrl(comment, user, images);
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      Logger().i('ParticiActionActivity: $response');
      return Future.value(unit);
    } else if (response.statusCode == 400) {
      throw WrongCredentialsException();
    } else {
      Logger().e ('ParticiActionActivity: ${response.body}');
      throw NotVerifiedException();
    }


  } catch (e) {
  Logger().e('ParticiActionActivity: $e');
  throw ServerException();
  }
  }


  Future<Unit> SendReplyNotifications(ReplyComment ReplyActivityComment,)async{
try {
  final user=await const Store().getUserId();
    final url =Urls. ReplyUrl(ReplyActivityComment, user);
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      Logger().i('ParticiActionActivity: $response');
      return Future.value(unit);
    } else if (response.statusCode == 400) {
      throw WrongCredentialsException();
    } else {
      Logger().e ('ParticiActionActivity: ${response.body}');
      throw NotVerifiedException();
    }


  } catch (e) {
  Logger().e('ParticiActionActivity: $e');
  throw ServerException();
  }
  }

}