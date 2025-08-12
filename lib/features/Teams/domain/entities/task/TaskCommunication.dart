import 'package:jci_app/features/Teams/data/models/CommentsModel.dart';

import 'Comment.dart';

class TaskCommunication {
  final List<TaskComment> comments;

  factory TaskCommunication.empty() {
    return TaskCommunication(
      comments: [],
    );
  }
  TaskCommunication({
    required this.comments,
  });
  TaskCommunication copyWith({
    List<TaskComment>? comments,
  }) {
    return TaskCommunication(
      comments: comments ?? this.comments,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'comments': comments.map((e) =>CommentModel.fromEntity(e).toJson()).toList(),
    };
  }
  factory TaskCommunication.fromJson(Map<String, dynamic> json) {
    return TaskCommunication(
      comments: (json['comments'] as List)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
