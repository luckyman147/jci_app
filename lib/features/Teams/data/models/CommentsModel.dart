import 'dart:developer';

import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';

import '../../../../core/PrimitiveUser/UserModel.dart';

class CommentModel extends TaskComment{
  CommentModel({required super.TaskId,  required super.Id,
    required super.CreatedAt, required super.avatar, required super.userName, required super.content, required super.TeamId,});
  //from entity to model
  factory CommentModel.fromEntity(TaskComment comment) {
    return CommentModel(
      TeamId: comment.TeamId,
      avatar: comment.avatar,

      userName: comment.userName,
      content: comment.content,

      TaskId: comment.TaskId,

      Id: comment.Id,
      CreatedAt: comment.CreatedAt,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    log("CommentModel.fromJson: $json");
    return CommentModel(
      TeamId: json['TeamId'] ?? "",
      TaskId: json['TaskId'] ?? "",
      avatar: json['avatar'] ?? "",
      userName: json['userName'] ?? "",
      content: json['content'] ?? "",












      Id: json['Id'] ?? json['_id'] ?? "",
      CreatedAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt'] ) : DateTime.now(),
    );
  }
   Map<String, dynamic> toJson() => {
  'TaskId': TaskId,
  'avatar': avatar,
  'userName': userName,
     'TeamId':TeamId,
  'content': content,
     "Id":Id,

  'CreatedAt': CreatedAt.toIso8601String(),
};
}