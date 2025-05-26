import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/domain/Dtos/NoteInput.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';

import '../Activity/ActivityImplWidgets.dart';
import '../Functions/ActivityDetailsFunctions.dart';
import '../Implementations/CommentsImpl.dart';
import '../components/SendingTextField.dart';
import 'CommentWidget.dart';

class CommentsScreen extends StatelessWidget {
  final String activityId;
  final String id;
  final TextEditingController controller = TextEditingController();

  CommentsScreen({super.key, required this.activityId, required this.id});

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return BlocBuilder<ActivityCommentBloc, ActivityCommentState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Expanded(
                child: ActivityCommentImpl((comments) {
              return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentWidget(
                      comment: comments[index],
                      onReplyAdded: (content) async {
                        await ActivityDetailsFunctions.CreateReplyToComment(
                            content,
                            context,
                            activityId,
                            comments[index].Commentid);
                      },
                      id: id,
                    );
                  });
            }, activityId)),
            Container(
              width: mediaquery.size.width,
              color: Colors.white,
              child: Column(
                children: [
                  state.comment != null && state.isReply
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: mediaquery.size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:
                                    ColorsApp.textColorBlack.withOpacity(0.8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Reply To:",
                                          style: PoppinsLight(
                                            13.sp,
                                            ColorsApp.textColorWhite,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              context
                                                  .read<ActivityCommentBloc>()
                                                  .add(InitComment(
                                                      state.comment!, true));
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: ColorsApp.textColorWhite,
                                              size: 20,
                                            ))
                                      ],
                                    ),
                                    Text(
                                      state.comment!.content,
                                      style: PoppinsRegular(
                                        15.sp,
                                        ColorsApp.textColorWhite,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SendingTextField(
                    controller: controller,
                    activityId: activityId,
                    onSend: (controller, content) async {
                      if (controller.text.isEmpty) {
                        return;
                      }
                      if (!state.isReply) {
                        await ActivityDetailsFunctions.SendingCommentTextField(
                            context, content, controller);
                      } else {
                        await ActivityDetailsFunctions.CreateReplyToComment(
                            controller.text,
                            context,
                            activityId,
                            state.comment!.Commentid);
                        context
                            .read<ActivityCommentBloc>()
                            .add(InitComment(state.comment!, true));
                        controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
