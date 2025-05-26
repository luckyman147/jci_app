import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_reactions/flutter_chat_reactions.dart';
import 'package:flutter_chat_reactions/model/menu_item.dart';
import 'package:flutter_chat_reactions/utilities/hero_dialog_route.dart';

import '../../../../../core/config/services/MemberStore.dart';
import '../../../../auth/AuthWidgetGlobal.dart';
import '../../../Activity_Global.dart';
import '../../../domain/Dtos/NoteInput.dart';
import '../../../domain/entities/poll/Poll.dart';
import '../../../domain/entities/poll/PollOption.dart';
import '../../bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import '../../bloc/Poll/poll_bloc.dart';
import '../Activity/ActivityChoiceDots.dart';

class ActivityDetailsFunctions {
  ActivityDetailsFunctions();
  static void ReactionMethod(BuildContext context, ActivityComment comment,
      Widget MessageWidget, String id) {
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: ReactionsDialogWidget(
                  widgetAlignment: Alignment.topCenter,
                  reactions: const [
                    "❤️",
                    "😀",
                    "😍",
                    "😂",
                    "😢",
                    "👍",
                    "🙏",
                  ],
                  menuItems: const [
                    MenuItem(
                        label: 'Copy',
                        icon: Icons.copy_sharp,
                        isDestuctive: true),
                    MenuItem(
                        label: 'Reply', icon: Icons.reply, isDestuctive: true),
                    MenuItem(
                        label: 'Delete',
                        icon: Icons.delete,
                        isDestuctive: true),
                  ],
                  id: comment.Commentid, // unique id for message
                  messageWidget: SingleChildScrollView(
                    child: Expanded(
                      child: MessageWidget,
                    ),
                  ), // message widget
                  onReactionTap: (reaction) async {
                    final listofReactionsUsersExisted = comment.Reactions.where(
                        (element) => element.users.contains(id)).toList();
                    // Add Emoji
                    if (listofReactionsUsersExisted.isEmpty) {
                      AddEmojiFunctions(comment, reaction, id, context);
                    }
                    // Update Emoji
                    else {
                      // Logic for updating emoji
                    }
                  },
                  onContextMenuTap: (menuItem) async {
                    if (menuItem.label == 'Reply') {
                      // Handle reply logic
                      Logger().i(
                          'Reply selected for comment: ${comment.Commentid}');
                      context
                          .read<ActivityCommentBloc>()
                          .add(InitComment(comment, false));
                      SnackBarMessage.showErrorSnackBar(
                        message: "Copied successfully",
                        context: context,
                      );
                    } else if (menuItem.label == 'Copy') {
                      // Handle copy logic
                      Logger()
                          .i('Copy selected for comment: ${comment.Commentid}');
                      Clipboard.setData(ClipboardData(text: comment.content))
                          .then((_) {
                        SnackBarMessage.showErrorSnackBar(
                          message: "Copied successfully",
                          context: context,
                        );
                      }).catchError((error) {
                        Logger().e('Failed to copy to clipboard: $error');
                        SnackBarMessage.showErrorSnackBar(
                          message: "Failed to copy",
                          context: context,
                        );
                      });
                    } else if (menuItem.label == 'Delete') {
                      context
                          .read<ActivityCommentBloc>()
                          .add(InitComment(comment, true));

                      // Handle delete logic
                      Logger().e(
                          'Delete selected for comment: ${comment.Commentid}');
                      final note = NoteInput(
                        comment.activityId,
                        comment,
                        null,
                        comment.Commentid,
                        null,
                        null,
                      );
                      context
                          .read<ActivityCommentBloc>()
                          .add(DeleteActivityComment(note));
                    }
                    context
                        .read<ActivityCommentBloc>()
                        .add(ToggleExpandForItemEvent(comment.Commentid));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static void AddEmojiFunctions(ActivityComment comment, String reaction,
      String? userId, BuildContext context) {
    final reactionExisted =
        comment.Reactions.any((element) => element.reaction == reaction);
    if (reactionExisted) {
      final listOfUsers = comment.Reactions.firstWhere(
          (element) => element.reaction == reaction);
      listOfUsers.copyWith(
          numberOfUsers: listOfUsers.numberOfUsers + 1,
          users: [...listOfUsers.users, userId!]);
      final commentInput = NoteInput(
          comment.activityId,
          comment,
          null,
          comment.Commentid,
          Reaction(
              reaction: reaction,
              numberOfUsers: listOfUsers.numberOfUsers,
              users: listOfUsers.users,
              ActivityId: comment.activityId),
          null);
      context.read<ActivityCommentBloc>().add(AddEmojiComment(commentInput));
      return;
    } else {
      final newReaction = Reaction(
          reaction: reaction,
          numberOfUsers: 1,
          users: [userId!],
          ActivityId: comment.activityId);
      final commentInput = NoteInput(comment.activityId, comment, null,
          comment.Commentid, newReaction, null);
      context.read<ActivityCommentBloc>().add(AddEmojiComment(commentInput));
      return;
    }
  }

  static Future<void> CreateReplyToComment(String content, BuildContext context,
      String activityId, String CommentId) async {
    var ReplyCommentsd = ReplyComment(
      Commentid: CommentId,
      Replyid: DateTime.now().millisecondsSinceEpoch.toString(),
      activityId: activityId,
      content: content,
      user: null,
      createdAt: DateTime.now(),
    );

    context.read<ActivityCommentBloc>().add(AddReplyComment(ReplyCommentsd));
  }

  static Future<void> SendingCommentTextField(BuildContext context,
      String activityId, TextEditingController controller) async {
    var activityComment = ActivityComment(
      Commentid: DateTime.now().millisecondsSinceEpoch.toString(),
      activityId: activityId,
      content: controller.text,
      user: null,
      createdAt: DateTime.now(),
      Reactions: [],
    );
    final comment = NoteInput(activityId, activityComment, null,
        activityComment.activityId, null, null);
    controller.clear();
    context.read<ActivityCommentBloc>().add(AddActivityComment(comment));
  }

  static void showEmojiBottomSheet({
    required ActivityComment message,
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 310,
          child: EmojiPicker(
            onEmojiSelected: ((category, emoji) {
              // pop the bottom sheet
              Navigator.pop(context);
            }),
          ),
        );
      },
    );
  }

  static void AddPollDFunction(
      BuildContext context,
      String ActivityId,
      TextEditingController titleController,
      TextEditingController optionController,
      bool isTemplate) {
    final poll = Poll(
        isTemplate: isTemplate,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text,
        options: context.read<PollBloc>().state.options,
        ActivityId: ActivityId,
        createdAt: DateTime.now());
    context.read<PollBloc>().add(AddPollEvent(poll: poll));
    titleController.clear();
    optionController.clear();
    Navigator.of(context).pop();
  }

  static void AddOption(
      BuildContext context, TextEditingController optionController) {
    final Polloption = PollOptions(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: optionController.text,
        votes: const []);
    context.read<PollBloc>().add(AddOptionEvent(pollOptions: Polloption));
    optionController.clear();
  }

  static Future<void> showDeleteDialog({
    required BuildContext context,
    required VoidCallback onDelete,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Delete",
            style: PoppinsRegular(15, ColorsApp.textColorBlack),
          ),
          content: Text(
            "Are you sure you want to delete this poll?",
            style: PoppinsSemiBold(
                15, ColorsApp.textColorBlack, TextDecoration.none),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without action
              },
              child: Text(
                "Cancel",
                style: PoppinsRegular(15, ColorsApp.ThirdColor),
              ),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.of(context).pop(); // Close dialog after delete action
              },
              child: Text(
                "Delete",
                style: PoppinsSemiBold(15, Colors.red, TextDecoration.none),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showGridModalBottomSheet(
      BuildContext context, Activity activity) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return ActivityChoiceDots(
            activity: activity,
          );
        });
  }
}
