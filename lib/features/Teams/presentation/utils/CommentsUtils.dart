import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Teams/domain/dto/TaskIdParams.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';
import 'package:jci_app/features/Teams/presentation/bloc/commentsdFile/comment_file_bloc.dart';

class CommentsUtils{


  static AddCommentFunction(BuildContext context,{required String teamId,required String taskId,required String content,}){
    final comment=TaskComment(avatar: '', TeamId: teamId, TaskId: taskId, Id: "", CreatedAt: DateTime.now(), userName: "", content: content);
    context.read<CommentFileBloc>().add(AddCommentEvent(comment: comment));

  }  static UpdateCommentFunction(BuildContext context,{required String teamId,required String taskId,required String content,required String commentId}){
    final comment=CommentParams( teamId: teamId, taskId: taskId, comment: content, commentId: commentId,);
    context.read<CommentFileBloc>().add(UpdateCommentsEvent( comment));

  }
 static DeleteCommentFunction(BuildContext context,{required String teamId,required String taskId,required String commentId}){
    context.read<CommentFileBloc>().add(DeleteCommentsEvent(commentId, teamId: teamId,taskId: taskId));
  }
  static List<TaskComment> addComment(List<TaskComment> checkLists,TaskComment? checklist) {

    // Check if the checklist already exists
    return [...checkLists, checklist!];


  }
  static List<TaskComment> updateEmptyIdWithNewId(
      List<TaskComment> comments, String newId) {
    final index = comments.indexWhere((comment) => comment.Id.isEmpty);

    if (index == -1) return comments; // No comment with empty ID found

    final updatedComment = comments[index].copyWith(Id: newId);

    final updatedList = [...comments];
    updatedList[index] = updatedComment;

    return updatedList;
  }

}