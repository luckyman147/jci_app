import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';
import 'package:jci_app/features/Teams/presentation/bloc/commentsdFile/comment_file_bloc.dart';

import '../../../../../Home/Activity_Global.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class TaskCommentWidget extends StatefulWidget {
  final TaskComment comment;
  final String teamId,taskId;

  const TaskCommentWidget({Key? key, required this.comment, required this.teamId, required this.taskId}) : super(key: key);

  @override
  State<TaskCommentWidget> createState() => _TaskCommentWidgetState();
}

class _TaskCommentWidgetState extends State<TaskCommentWidget> {
  bool isEditing = false;
  late TextEditingController _controller;
  bool showEmojiPicker = false;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.comment.content);
    super.initState();
  }




  void _showAlert(String? commentId) {
    if (commentId == null || commentId.isEmpty) {
      // Show error dialog if ID is invalid
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text("Cannot Delete",style: PoppinsSemiBold(16, ColorsApp.textColorBlack, TextDecoration.none),),
          content:  Text("You can't delete this comment. Please refresh and try again.",style: PoppinsRegular(13, ColorsApp.textColorBlack, )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text("OK",style:
              PoppinsSemiBold(14, ColorsApp.ThirdColor, TextDecoration.none),),
            ),
          ],
        ),
      );
    } else {
      // Show delete confirmation dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text("Deleting this comment",style: PoppinsSemiBold(16, ColorsApp.textColorBlack, TextDecoration.none),),
          content:  Text("Are you sure you want to delete this comment?",style: PoppinsRegular(13, ColorsApp.ThirdColor,),),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",style: PoppinsSemiBold(14, ColorsApp.ThirdColor, TextDecoration.none),),
            ),
            TextButton(
              onPressed: () {
                context.read<CommentFileBloc>().add(DeleteCommentsEvent(widget.comment.Id,teamId: widget.teamId,taskId: widget.taskId));
                // TODO: Implement your delete logic using commentId
                Navigator.pop(context);
              },
              child:  Text(
                "Delete",
                style: PoppinsSemiBold(14, Colors. red, TextDecoration.none),
              ),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Avatar
            CircleAvatar(
              backgroundImage: NetworkImage(widget.comment.avatar!),
            ),
            const SizedBox(width: 8),

            // Content Bubble
            GestureDetector(
                onLongPress:()=> _showAlert(widget.comment.Id),
                onDoubleTap: () {
                  setState(() => isEditing = true);
                },

                child: Container(

                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(width: MediaQuery.of(context).size.width*.5,
    child: AutoSizeText(_controller.text,style: PoppinsRegular(15, ColorsApp.textColorBlack), )),
                ),
              ),



          ],
        ),

        // Time + React
        Padding(
          padding: const EdgeInsets.only(left: 48, top: 4),
          child: Row(
            children: [
              Text(
                timeago.format(widget.comment.CreatedAt),
                style: PoppinsRegular(13, ColorsApp.textColor),
              ),

            ],
          ),
        ),

        // Emoji picker
        if (showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _controller.text += emoji.emoji;
              },
              config:  Config(
                height: 256,

                checkPlatformCompatibility: true,
              ),
            ),
          ),
      ],
    );
  }
}
