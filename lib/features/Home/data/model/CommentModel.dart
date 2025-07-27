import 'package:jci_app/features/Home/domain/entities/Note.dart';

import '../../../../core/PrimitiveUser/UserModel.dart';
import 'ReactioNModel.dart';
import 'ReplyCommentModel.dart';

class ActivityCommentModel extends ActivityComment {
  ActivityCommentModel(
      {required super.Commentid,
      required super.activityId,
      required super.user,
      required super.content,
      required super.Reactions,
      required super.replies,
      required super.createdAt});

  factory ActivityCommentModel.fromJson(Map<Object?, Object?> json) {
    // Safely convert the map to Map<String, dynamic>
    final Map<String, dynamic> mappedJson = json.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    return ActivityCommentModel(
      createdAt: mappedJson['createdAt'] != null
          ? DateTime.parse(mappedJson['createdAt'] as String)
          : DateTime.now(),
      activityId: mappedJson['activityId'] as String,
      content: mappedJson['content'] as String,
      Commentid: mappedJson['Commentid'] as String,
      user: UserModel.fromObject(mappedJson['user'], true),
      replies: mappedJson['replies'] != null
          ? (mappedJson['replies'] as Map).entries.map((entry) {
              final commentData = entry.value as Map<Object?, Object?>;
              var replyCommentModel = ReplyCommentModel.fromJson(commentData);

              return replyCommentModel;
            }).toList()
          : [],
      Reactions: mappedJson['reactions'] != null
          ? (mappedJson['reactions'] as Map).entries.map((reaction) {
              final reactionData = reaction.value as Map<Object?, Object?>;

              return ReactionModel.fromJson(reactionData);
            }).toList()
          : [],
    );
  }

  factory ActivityCommentModel.fromEntity(ActivityComment comment) {
    return ActivityCommentModel(
        createdAt: comment.createdAt,
        Commentid: comment.Commentid,
        activityId: comment.activityId,
        user: UserModel.fromEntity(comment.user!),
        content: comment.content,
        replies: comment.replies
            .map((reply) => ReplyCommentModel.fromEntity(reply))
            .toList(),
        Reactions: comment.Reactions.map(
            (reaction) => ReactionModel.fromEntity(reaction)).toList());
  }
  // toJson

  Map<String, dynamic> toJson() {
    return {
      'Commentid': Commentid,
      "user": UserModel.fromEntity(user!).toJson(true),
      'content': content,
      "activityId": activityId,
      'replies': replies
          .map((reply) => ReplyCommentModel.fromEntity(reply).toJson())
          .toList(),
      'Reactions': Reactions.map(
          (reaction) => ReactionModel.fromEntity(reaction).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
