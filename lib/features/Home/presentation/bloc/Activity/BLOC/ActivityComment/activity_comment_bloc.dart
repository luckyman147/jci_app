import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/features/Home/domain/Dtos/NoteInput.dart';
import 'package:jci_app/features/Home/domain/enums/ActivityCommentEnum.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../../../core/error/Failure.dart';
import '../../../../../domain/entities/Note.dart';
import '../../../../../domain/usercases/ActivityCommentUsesCase.dart';

part 'activity_comment_event.dart';
part 'activity_comment_state.dart';

class ActivityCommentBloc extends Bloc<ActivityCommentEvent, ActivityCommentState> {
  ActivityCommentBloc(this.getCommentsOfActivityUseCase,
      this.addCommentToActivityUseCase, this.updateCommentToActivityUseCase,
      this.deleteCommentToActivityUseCase, this.addReplyToCommentUseCase,
      this.updateReplyToCommentUseCase, this.deleteReplyToCommentUseCase, this.addReactionsToCommentUseCase, this.addReactionsToReplyUseCase, this.updateReactionsToCommentUseCase, this.updateReactionsToReplyUseCase, this.sendCommentNotificationsUseCase)
      : super(ActivityCommentInitial()) {
    on<ActivityCommentEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetActivitysComment>(_GetComments);
    on<AddActivityComment>(_AddComment);
    on<AddReplyComment>(_AddReply);
    on<DeleteActivityComment>(_DeleteComment);
    on<DeleteReplyComment>(_DeleteReply);
    on<UpdateActivityComment>(_UpdateComment);
    on<AddEmojiComment>(_AddEmoji);
    on<AddReactionReplyComment>(_AddReactionToReply);
    on<UpdateReactionComment>(_UpdateReaction);
    on<UpdateReactionReplyComment>(_UpdateReactionReply);
    on<UpdateReplyComment>(_UpdateReply);
    on<InitComment>(_InitComment);
    on<SendCommentNotification>(_SendCommentNotification);
    on<ToggleExpandForItemEvent>((event,emit){
      emit(state.copyWith(expandedItems: {
        ...state.expandedItems,
        event.index: !state.expandedItems[event.index]!,
      }));
    });
    on<CheckIsAlreadyReacted>((event,emit)async{
      final user=await const Store().getUserId();
      emit(state.copyWith(isReacted: event.reactions.contains(user)));
    });
  }

  final GetCommentsOfActivityUseCase getCommentsOfActivityUseCase;
  final AddCommentToActivityUseCase addCommentToActivityUseCase;
  final UpdateCommentToActivityUseCase updateCommentToActivityUseCase;
  final DeleteCommentToActivityUseCase deleteCommentToActivityUseCase;
  final AddReplyToCommentUseCase addReplyToCommentUseCase;
  final UpdateReplyToCommentUseCase updateReplyToCommentUseCase;
  final DeleteReplyToCommentUseCase deleteReplyToCommentUseCase;
  final AddReactionsToCommentUseCase addReactionsToCommentUseCase;
  final AddReactionsToReplyUseCase addReactionsToReplyUseCase;
  final UpdateReactionsToCommentUseCase updateReactionsToCommentUseCase;
  final UpdateReactionsToReplyUseCase updateReactionsToReplyUseCase;
  final SendCommentNotificationsUseCase sendCommentNotificationsUseCase;



  FutureOr<void> _SendCommentNotification(SendCommentNotification event, Emitter<ActivityCommentState> emit) async{
    final result=await sendCommentNotificationsUseCase.call(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.SEND_NOTIFICATION)));
  }

  FutureOr<void> _UpdateReply(UpdateReplyComment event,
      Emitter<ActivityCommentState> emit) async{
    emit (state.copyWith(activityCommentEnum: ActivityCommentEnum.LOADING));
    final result = await updateReplyToCommentUseCase.call(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.UPDATE_REPLY)));
  }

  FutureOr<void> _AddEmoji(AddEmojiComment event,
      Emitter<ActivityCommentState> emit) async{
    emit (state.copyWith(activityCommentEnum: ActivityCommentEnum.LOADING));
    final result = await addReactionsToCommentUseCase.call(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.ADD_EMOJI)));

  }

  FutureOr<void> _UpdateComment(event, Emitter<ActivityCommentState> emit) async{
    emit (state.copyWith(activityCommentEnum: ActivityCommentEnum.LOADING));
    final result = await updateCommentToActivityUseCase.call(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.UPDATE_COMMENT)));

  }

  FutureOr<void> _DeleteReply(DeleteReplyComment event,
      Emitter<ActivityCommentState> emit) async{
    emit (state.copyWith(activityCommentEnum: ActivityCommentEnum.LOADING));
    final result = await deleteReplyToCommentUseCase.call(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.DELETE_REPLY)));
  }

  FutureOr<void> _DeleteComment(DeleteActivityComment event,
      Emitter<ActivityCommentState> emit) async{

    final result = await deleteCommentToActivityUseCase.call(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.LOADING)));
  }

  FutureOr<void> _AddReply(AddReplyComment event,
      Emitter<ActivityCommentState> emit)async {

    final result = await addReplyToCommentUseCase.call(event.comment);

    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.ADD_REPLY)));

  }

  FutureOr<void> _AddComment(AddActivityComment event,
      Emitter<ActivityCommentState> emit)async {

    final result = await addCommentToActivityUseCase.call(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.ADD_COMMENT)));
  }

  Future<void> _GetComments(
      GetActivitysComment event,
      Emitter<ActivityCommentState> emit,
      ) async {
    // Emit loading state
    emit(state.copyWith(activityCommentEnum: ActivityCommentEnum.LOADING));

    try {
      final lastFetchedComment = state.comments.isNotEmpty
          ? state.comments.last.createdAt
          : null;
      // Listen to the comment stream from the use case
      await emit.forEach<Either<Failure,List<ActivityComment>>>(

        //today
        getCommentsOfActivityUseCase.call(event.activityId, lastFetchedComment?.toString()),
        onData: (comments) {

          final commentsList = comments.getOrElse(() => []);
          final ExpanedItems={ for (var comment in commentsList) comment.Commentid : false };
          return state.copyWith(
            activityCommentEnum: ActivityCommentEnum.GET_COMMENTS,
            comments: commentsList,
            expandedItems: ExpanedItems,
          );
        },
        onError: (error, stackTrace) {
          Logger().e(error);
          return state.copyWith(
            activityCommentEnum: ActivityCommentEnum.ERROR,
            message:mapFailureToMessage(error as Failure),
          );
        },
      );
    } catch (e) {
      // Handle unexpected errors
      Logger().e(e);
      emit(state.copyWith(
        activityCommentEnum: ActivityCommentEnum.ERROR,
        message: e.toString(),
      ));
    }


  }ActivityCommentState _eitherSuccessOrFailure<T>(
      Either<Failure, T >result, Function(T) onSuccess ) {
    return result.fold(
          (l) {
            Logger().e(l);
            return state.copyWith(activityCommentEnum: ActivityCommentEnum.ERROR,message: mapFailureToMessage(l));
          },
          (r) => onSuccess(r),
    );
  }

  FutureOr<void> _UpdateReactionReply(UpdateReactionReplyComment event, Emitter<ActivityCommentState> emit) async{
    final result=await updateReactionsToReplyUseCase(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.UpdateEmoji,)));


  }

  FutureOr<void> _AddReactionToReply(AddReactionReplyComment event, Emitter<ActivityCommentState> emit) async{
    final result=await updateReactionsToReplyUseCase(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.ADD_EMOJI,)));
  }

  FutureOr<void> _UpdateReaction(UpdateReactionComment event, Emitter<ActivityCommentState> emit)async {
    final result=await updateReactionsToReplyUseCase(event.comment);
    emit(_eitherSuccessOrFailure(result, (r) => state.copyWith(activityCommentEnum: ActivityCommentEnum.ADD_EMOJI,)));
  }

  FutureOr<void> _InitComment(InitComment event, Emitter<ActivityCommentState> emit) {
    if (event.isEmpty == true) {
      emit(state.copyWith(comment: null,isReply: false));
    } else {
    emit(state.copyWith(comment: event.comment,isReply: true));
    }
  }
}

