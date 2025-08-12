import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../MemberSection/global-pres.dart';
import '../../../bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import '../../Functions/ActivityDetailsFunctions.dart';
import 'SendingTextField.dart';

class CommentTextField extends StatelessWidget {
  const CommentTextField({super.key, required this.state, required this.activityId, required this.controller});
final ActivityCommentState state;
final String activityId;
final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    final mediaquery=MediaQuery.of(context);
    return Container(
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
    );
  }
}
