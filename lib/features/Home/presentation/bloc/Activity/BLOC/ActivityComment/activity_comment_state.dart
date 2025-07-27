part of 'activity_comment_bloc.dart';

 class ActivityCommentState extends Equatable {
   final Map<String ,bool> expandedItems;
   final ActivityComment? comment;
   final List<ActivityComment> comments;
    final bool isReply;
    final String message;
    final isReachedMax;
    final bool isReacted;
    final ActivityCommentEnum activityCommentEnum;
  const ActivityCommentState({this.comment,
     this.isReacted=false,
    this.comments = const [],this.expandedItems=const {}, this.isReply = false, this.message = '', this.activityCommentEnum = ActivityCommentEnum.INITIAL, this.isReachedMax = false});
// CopyWIUth
  ActivityCommentState copyWith({ActivityComment? comment,

    Map<String ,bool>? expandedItems,

    bool? isReacted,

  bool? isReachedMax,
    List<ActivityComment>? comments, bool? isReply, String? message, ActivityCommentEnum? activityCommentEnum}) {
    return ActivityCommentState(
      isReachedMax: isReachedMax ?? this.isReachedMax,
      comment: comment ?? this.comment,
      comments: comments ?? this.comments,
      isReply: isReply ?? this.isReply,
      message: message ?? this.message,
      isReacted: isReacted ?? this.isReacted,
      expandedItems: expandedItems ?? this.expandedItems,
      activityCommentEnum: activityCommentEnum ?? this.activityCommentEnum,
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [comment,isReachedMax,isReacted, expandedItems, comments, isReply, message, activityCommentEnum];
}

final class ActivityCommentInitial extends ActivityCommentState {
  @override
  List<Object> get props => [];
}
