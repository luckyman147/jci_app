import 'package:comment_tree/data/comment.dart';

import '../../../../../core/PrimitiveUser/User.dart';

class TaskComment extends Comment{
  final String TaskId;
  final String TeamId;

  final String Id;
  final DateTime CreatedAt;

  TaskComment({required super.avatar,
    required this.TeamId,
  required this.TaskId, required this.Id, required this.CreatedAt,

    required super.userName, required super.content});



  // copywityh


  TaskComment copyWith({
    String? avatar,
    String? userName,
    String? content,
    String? TaskId,
    String? TeamId,
    String? Id,
    DateTime? CreatedAt,
  }) {
    return TaskComment(
      avatar: avatar ?? this.avatar,
      userName: userName ?? this.userName,
      content: content ?? this.content,
      TaskId: TaskId ?? this.TaskId,
      TeamId: TeamId ?? this.TeamId,
      Id: Id ?? this.Id,
      CreatedAt: CreatedAt ?? this.CreatedAt,
    );
  }




}
extension TaskCommentExtension on Comment {
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'userName': userName,
      'content': content,

    };
  }
}