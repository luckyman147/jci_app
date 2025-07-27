import 'package:flutter/material.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../../../auth/AuthWidgetGlobal.dart';
import '../../bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import '../Functions/ActivityDetailsFunctions.dart';
import '../components/stuff/NetworkCachedImageWidget.dart';

class CommentWidget extends StatefulWidget {
  final ActivityComment comment;
  final Function(String) onReplyAdded;
  final String id;

  const CommentWidget(
      {super.key,
      required this.comment,
      required this.onReplyAdded,
      required this.id});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<String> _getUserReaction(List<Reaction> reactions) async {
    final reaction =
        reactions.singleWhere((element) => element.users.contains(widget.id));
    return reaction.reaction; // Return the reaction value
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return BuildRepliesTreeWidget(mediaquery);
  }

  SizedBox buildSizedBox(BuildContext context, bool isReply,
      List<Reaction> ractions, DateTime created) {
    final height = 50.h;
    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height,
              child: Padding(
                padding: paddingSemetricVerticalHorizontal(),
                child: Text(timeago.format(created).toString(),
                    style: PoppinsSemiBold(
                        14.sp, ColorsApp.ThirdColor, TextDecoration.none)),
              ),
            ),
            SizedBox(
              height: height,
              child: Visibility(
                visible: isReply,
                child: Padding(
                  padding: paddingSemetricVerticalHorizontal(),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<ActivityCommentBloc>()
                          .add(InitComment(widget.comment, false));
                    },
                    child: Text('Reply',
                        style: PoppinsSemiBold(
                            14.sp, ColorsApp.ThirdColor, TextDecoration.none)),
                  ),
                ),
              ),
            ),
            FutureBuilder<String>(
                future: _getUserReaction(ractions),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(); // Show loading indicator while waiting
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data == null) {
                    return SizedBox(
                      height: height,
                      child: Padding(
                        padding: paddingSemetricVerticalHorizontal(),
                        child: InkWell(
                          onTap: () {
                            ActivityDetailsFunctions.AddEmojiFunctions(
                                widget.comment, "❤️", widget.id, context);
                          },
                          child: Text('Like',
                              style: PoppinsSemiBold(14.sp,
                                  ColorsApp.ThirdColor, TextDecoration.none)),
                        ),
                      ),
                    );
                  } else {
                    final reaction = snapshot.data!;
                    return SizedBox(
                      height: height,
                      child: Padding(
                        padding: paddingSemetricVerticalHorizontal(),
                        child: InkWell(
                          onTap: () {},
                          child: Text(reaction,
                              style: PoppinsSemiBold(15.sp,
                                  ColorsApp.ThirdColor, TextDecoration.none)),
                        ),
                      ),
                    );
                  }
                }),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: SizedBox(
                height: 30,
                width: 100.w,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                            color: ColorsApp.BackWidgetColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorsApp
                                    .textColorWhite, // Shadow color with some transparency
                                spreadRadius: 5, // Spread radius
                                blurRadius:
                                    20, // Blur radius for a softer shadow
                                // Offset: 0 for horizontal, positive Y for bottom shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: paddingSemetricHorizontal(),
                                  child: Text(ractions[index].reaction,
                                      style: PoppinsSemiBold(
                                          15.sp,
                                          ColorsApp.ThirdColor,
                                          TextDecoration.none)),
                                ),
                                Text(ractions[index].numberOfUsers.toString(),
                                    style: PoppinsSemiBold(
                                        15.sp,
                                        ColorsApp.textColorBlack,
                                        TextDecoration.none)),
                              ],
                            ),
                          ));
                    },
                    separatorBuilder: (ctx, index) => const SizedBox(
                          width: 3,
                        ),
                    itemCount: ractions.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CommentTreeWidget<ActivityComment, ReplyComment> BuildRepliesTreeWidget(
      MediaQueryData mediaquery) {
    return CommentTreeWidget<ActivityComment, ReplyComment>(
      widget.comment, // Pass the current comment as the root
      widget.comment.replies, // Pass the replies of the current comment
      treeThemeData:
          TreeThemeData(lineColor: ColorsApp.PrimaryColor, lineWidth: 4),
      avatarRoot: (context, data) => PreferredSize(
        preferredSize: const Size(36, 36),
        child: ClipOval(
            child: CachedNetworkImageWidget(
          item: data.user!.Images.isNotEmpty ? data.user!.Images[0] : null,
          height: 36,
          width: 36,
        )),
      ),
      contentRoot: (context, data) => GestureDetector(
        onHorizontalDragEnd: (details) {
          context
              .read<ActivityCommentBloc>()
              .add(InitComment(widget.comment, false));
        },
        child: ContentRootWidget(context, mediaquery, data),
      ),

      avatarChild: (context, data) => PreferredSize(
        preferredSize: const Size(24, 24),
        child: ClipOval(
            child: CachedNetworkImageWidget(
                item:
                    data.user!.Images.isNotEmpty ? data.user!.Images[0] : null,
                height: 24,
                width: 24)),
      ),
      contentChild: (context, data) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              // wrap your message widget with a [GestureDectector] or [InkWell]

              onLongPress: () {
                // navigate with a custom [HeroDialogRoute] to [ReactionsDialogWidget]
                //   ActivityDetailsFunctions.ReactionMethod(context,widget.comment,MessageWidget(mediaquery,data.user.firstName, data.content));
              },
              child: MessageWidget(
                  mediaquery, data.content, data.Replyid, data.user!.firstName),
            ),
            buildSizedBox(context, false, data.Reactions, data.createdAt)
          ],
        );
      },
    );
  }

  Column ContentRootWidget(
      BuildContext context, MediaQueryData mediaquery, ActivityComment data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          // wrap your message widget with a [GestureDectector] or [InkWell]

          onLongPress: () {
            context
                .read<ActivityCommentBloc>()
                .add(ToggleExpandForItemEvent(data.Commentid));

            // navigate with a custom [HeroDialogRoute] to [ReactionsDialogWidget]
            ActivityDetailsFunctions.ReactionMethod(
                context,
                widget.comment,
                MessageWidget(mediaquery, data.content, data.Commentid,
                    data.user!.firstName,
                    isExapnded: true),
                widget.id);
          },
          child: Hero(
              tag: data.Commentid,
              child: MessageWidget(mediaquery, data.content, data.Commentid,
                  data.user!.firstName)),
        ),
        buildSizedBox(context, true, data.Reactions, data.createdAt),
      ],
    );
  }

  Widget MessageWidget(
      MediaQueryData media, String content, String id, String name,
      {bool isExapnded = false}) {
    final isLongText = content.length > 100;
    final isExpanded =
        context.read<ActivityCommentBloc>().state.expandedItems[id] ?? false;
    final displayText =
        isExpanded || !isLongText ? content : '${content.substring(0, 100)}...';
    return Stack(
      children: [
        SizedBox(
          width: media.size.width,
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: BackWidgetColor, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            color: textColorWhite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: PoppinsSemiBold(
                        14.sp, ColorsApp.textColorBlack, TextDecoration.none),
                  ),
                  Text(
                    displayText,
                    overflow: !isExapnded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: PoppinBold(
                        16.sp, ColorsApp.textColorBlack, TextDecoration.none),
                  ),
                  if (isLongText)
                    TextButton(
                      onPressed: () {
                        context
                            .read<ActivityCommentBloc>()
                            .add(ToggleExpandForItemEvent(id));
                      },
                      child: Text(
                        isExpanded ? "See Less" : "See More",
                        style: PoppinsSemiBold(
                            14.sp, ColorsApp.PrimaryColor, TextDecoration.none),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Reactions positioned above the card
      ],
    );
  }
}
