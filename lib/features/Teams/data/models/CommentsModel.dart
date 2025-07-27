import 'dart:developer';

import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';

import '../../../../core/PrimitiveUser/UserModel.dart';

class CommentModel extends Comment{
  CommentModel({required super.TaskId, required super.comment, required super.Member, required super.Id,
    required super.CreatedAt,});
  //from entity to model
  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      TaskId: comment.TaskId,
      comment: comment.comment,
      Member: comment.Member,
      Id: comment.Id,
      CreatedAt: comment.CreatedAt,
    );
  }


  factory CommentModel.fromJson(Map<String, dynamic> json) {
    log("CommentModel.fromJson: $json");
    return CommentModel(
      TaskId: json['TaskId'] ?? "",
      comment: json['comment'] ?? "" ,
      Member:  UserModel.fromJson(json['Member'],false) ,










      Id: json['Id'] ?? json['_id'] ?? "",
      CreatedAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt'] ) : DateTime.now(),
    );
  }
   Map<String, dynamic> toJson() => {
  'TaskId': TaskId,
  'comment': comment,
  'Member':UserModel.fromEntity(Member).toJson(false),
  'Id': Id,
  'CreatedAt': CreatedAt.toIso8601String(),
};
}