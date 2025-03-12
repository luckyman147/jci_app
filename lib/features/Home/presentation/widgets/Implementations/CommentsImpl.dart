
import 'dart:developer';

import '../../../Activity_Global.dart';
import '../../../domain/enums/ActivityCommentEnum.dart';
import '../../bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import '../shimmer/NotesShimmer.dart';

BlocConsumer<ActivityCommentBloc, ActivityCommentState> ActivityCommentImpl(Widget Function(List<ActivityComment>) widget,
    String activityId) {
  return BlocConsumer<ActivityCommentBloc, ActivityCommentState>(
    builder: (context, state) {
      switch (state.activityCommentEnum) {
        case ActivityCommentEnum.INITIAL:
          return const LoadNotesShimmer(count: 3);
        case ActivityCommentEnum.GET_COMMENTS:
        case ActivityCommentEnum.DELETE_COMMENT:

          if (state.comments.isEmpty) {
            return Center(child: Text(
              'No Comments', style: PoppinsRegular(17, textColorBlack),));
          }
          return widget(state.comments);
        case ActivityCommentEnum.ERROR:
          log(activityId);
          context.read<ActivityCommentBloc>().add(
              GetActivitysComment(activityId));

          return const LoadNotesShimmer(count: 3);

        default:
          context.read<ActivityCommentBloc>().add(
              GetActivitysComment(activityId));

          return const LoadNotesShimmer(count: 3);
      }
    }, listener: (BuildContext context, ActivityCommentState state) {
    if (state.activityCommentEnum == ActivityCommentEnum.ERROR) {
      SnackBarMessage.showErrorSnackBar(message: "Failed to delete", context: context);

    }
    if (state.activityCommentEnum == ActivityCommentEnum.ADD_COMMENT ||
        state.activityCommentEnum == ActivityCommentEnum.DELETE_COMMENT) {


    }
  },
  );
}
