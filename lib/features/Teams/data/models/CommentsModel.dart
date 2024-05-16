import 'dart:developer';

import 'package:jci_app/features/Teams/domain/entities/Comment.dart';

class CommentModel extends Comment{
  CommentModel({required super.TaskId, required super.comment, required super.MemberId, required super.id, required super.CreatedAt});
  //from entity to model
  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      TaskId: comment.TaskId,
      comment: comment.comment,
      MemberId: comment.MemberId,
      id: comment.id,
      CreatedAt: comment.CreatedAt,
    );
  }


  factory CommentModel.fromJson(Map<String, dynamic> json) {
    log("CommentModel.fromJson: $json");
    return CommentModel(
      TaskId: json['TaskId'] ?? "",
      comment: json['comment'] ?? "" ,
      MemberId: json['MemberId'] == null ? [] : (json['MemberId'] as List<dynamic>).map((e) => e as dynamic).toList(),
      id: json['id'] ?? json['_id'] ?? "",
      CreatedAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt'] ) : DateTime.now(),
    );
  }
   Map<String, dynamic> toJson() => {
  'TaskId': TaskId,
  'comment': comment,
  'MemberId': MemberId,
  'id': id,
  'CreatedAt': CreatedAt.toIso8601String(),
};
}