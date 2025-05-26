import '../../../../core/PrimitiveUser/UserModel.dart';
import '../../domain/entities/Note.dart';

class ReplyCommentModel extends ReplyComment {
  ReplyCommentModel(
      {required super.Commentid,
      required super.activityId,
      required super.user,
      required super.content,
      required super.Replyid,
      required super.createdAt});

  /// factory method to convert json to model

  factory ReplyCommentModel.fromJson(Map<Object?, Object?> json) {
    // Safely convert the map to Map<String, dynamic>
    final Map<String, dynamic> mappedJson = json.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    return ReplyCommentModel(
      createdAt: mappedJson['createdAt'] != null
          ? DateTime.parse(mappedJson['createdAt'] as String)
          : DateTime.now(),
      activityId: mappedJson['activityId'] as String,
      content: mappedJson['content'] as String,
      Commentid: mappedJson['Commentid'] as String,
      user: UserModel.fromObject(mappedJson['user'], true),
      Replyid: mappedJson['Replyid'] as String,
    );
  }
  // from entity

  factory ReplyCommentModel.fromEntity(ReplyComment reply) {
    return ReplyCommentModel(
      createdAt: reply.createdAt,
      Commentid: reply.Commentid,
      activityId: reply.activityId,
      user: UserModel.fromEntity(reply.user!),
      content: reply.content,
      Replyid: reply.Replyid,
    );
  }

//toJson
  Map<String, dynamic> toJson() {
    return {
      'Commentid': Commentid,
      "user": UserModel.fromEntity(user!).toJson(true),
      'content': content,
      "activityId": activityId,
      'Replyid': Replyid,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
