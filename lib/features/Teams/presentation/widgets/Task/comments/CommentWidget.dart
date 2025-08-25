import 'package:flutter/material.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';

import '../../../utils/CommentsUtils.dart';
import '../../common/CommentTextField.dart';
import '../../common/EditableTextField.dart';
import 'CommentTreeWidget.dart';

class CommentsWidget extends StatefulWidget {
  final List<TaskComment> commentWidgets;
final String teamId,taskId;
final bool haspermission;

  const CommentsWidget({
    required this.haspermission,
     required  this.teamId,required this.taskId,
    Key? key,
    required this.commentWidgets,

  }) : super(key: key);

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final TextEditingController _controller = TextEditingController();

  void _submitComment(String content) {


CommentsUtils.AddCommentFunction(context, teamId: widget.teamId, taskId: widget.taskId, content:  content.trim()) ;

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Comments list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: widget.commentWidgets.length,
            itemBuilder: (context, index) => TaskCommentWidget(comment:widget.commentWidgets[index], teamId: widget.teamId,taskId: widget.taskId,),
          ),
        ),

        const Divider(),

        // Comment input
       Visibility(
           visible: widget.haspermission,
           child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              // Input field

               CommentInputField(teamId: widget.teamId,taskId: widget.taskId, onSend:(s){ _submitComment(s);})

        )),
      ],
    );
  }
}
