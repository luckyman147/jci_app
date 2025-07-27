import 'package:auto_route/auto_route.dart';
import 'package:jci_app/features/Home/domain/entities/poll/Poll.dart';
import 'package:jci_app/features/Home/domain/enums/ActionImage.dart';

import '../../../../../core/util/snackbar_message.dart';
import '../../../../MemberSection/domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../../../MemberSection/domain/entity/ActionDetails.dart';
import '../../../../MemberSection/domain/entity/Objectif.dart';
import '../../../../MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import '../../../../auth/AuthWidgetGlobal.dart';
import '../../../Activity_Global.dart';
import '../../../domain/enums/ActivityCommentEnum.dart';
import '../../../domain/enums/ActivityEnum.dart';
import '../../../domain/enums/PollEnum.dart';
import '../../bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import '../../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../../bloc/Poll/poll_bloc.dart';

class Listeners {

  static void handlePollState(BuildContext context, PollState state, String activityId) {
    switch (state.pollEnum) {
      case PollEnum.Error:
        _handleErrorState(context, activityId);
        break;

      case PollEnum.CreatedPoll:
        _handleAddedState(context, activityId);
        break;

      case PollEnum.Deleted:
        _handleDeletedState(context, activityId);
        break;

      case PollEnum.Voted:
      case PollEnum.Unvoted:
        _handleVotedState(context,state);
        break;
      case PollEnum.Updated:
        break;
      default:
        break;
    }
  }

// Handle Error State
 static void _handleErrorState(BuildContext context, String activityId) {
    SnackBarMessage.showErrorSnackBar(message: "Failed to delete", context: context);

    context.read<PollBloc>().add(ReseTSTate());
    context.read<PollBloc>().add(FetchPolls(ActivityId: activityId));
  }

// Handle Added State
 static void _handleAddedState(BuildContext context, String activityId) {
    SnackBarMessage.showSuccessSnackBar(message: "Poll created Successfully", context: context);
    context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
      UpdateObjectiveProgressDTO(
        userId: '', // Provide the actual user ID
        actionType: ObjectifActionType.Create.name,
        feature: [FeaturesType.Votes.name],
        progress: 1,
      ),
    );
    context.read<PollBloc>().add(ReseTSTate());
    context.read<PollBloc>().add(FetchPolls(ActivityId: activityId));


  }

// Handle Deleted State
 static void _handleDeletedState(BuildContext context, String activityId) {
    SnackBarMessage.showSuccessSnackBar(message: "Poll Deleted Successfully", context: context);
    context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
      UpdateObjectiveProgressDTO(
        userId: '', // Provide the actual user ID
        actionType: ObjectifActionType.Delete.name,
        feature: [FeaturesType.Votes.name],
        progress: 1,
      ),
    );
    context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
      UpdateObjectiveProgressDTO(
        userId: '', // Provide the actual user ID
        actionType: ObjectifActionType.Create.name,
        feature: [FeaturesType.Votes.name],
        progress: -1,
      ),
    );
    Future.delayed(Duration(seconds: 1));
    context.read<PollBloc>().add(FetchPolls(ActivityId: activityId));
    context.read<PollBloc>().add(ReseTSTate());


  }

// Handle Voted State
 static void _handleVotedState(BuildContext context,PollState state) {
    SnackBarMessage.showSuccessSnackBar(message: "Voted Successfully", context: context);

    context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
      UpdateObjectiveProgressDTO(
        userId: '', // Provide the actual user ID
        actionType: ObjectifActionType.VoteIn.name,
        feature: [FeaturesType.Meetings.name],
        progress:state.pollEnum==PollEnum.Unvoted?-1:1 ,
      ),
    );
  }











 static  void handleActivityCommentState(BuildContext context, ActivityCommentState state) {
    if (state.activityCommentEnum == ActivityCommentEnum.ERROR) {
      SnackBarMessage.showErrorSnackBar(
        message: state.message,
        context: context,
      );
      return;
    }

    // Use a switch statement for better readability and maintainability
    switch (state.activityCommentEnum) {
      case ActivityCommentEnum.ADD_COMMENT:
      case ActivityCommentEnum.DELETE_COMMENT:
        context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
          UpdateObjectiveProgressDTO(
            userId: '', // Provide the actual user ID
            actionType: ObjectifActionType.Send.name,
            feature: [FeaturesType.Comments.name],
            progress: state.activityCommentEnum == ActivityCommentEnum.DELETE_COMMENT ? -1 : 1,
          ),
        );
        break;
      case ActivityCommentEnum.DELETE_REPLY:
      case ActivityCommentEnum.ADD_REPLY:
        context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
          UpdateObjectiveProgressDTO(
            userId: '', // Provide the actual user ID
            actionType: ObjectifActionType.ReplyTo.name,
            feature: [FeaturesType.Comments.name],
          ),
        );
        break;

      case ActivityCommentEnum.ADD_EMOJI:
        context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
          UpdateObjectiveProgressDTO(
            userId: '', // Provide the actual user ID
            actionType: ObjectifActionType.ReactTo.name,
            feature: [FeaturesType.Comments.name,],
          ),
        );
        break;
      case ActivityCommentEnum.UPDATE_COMMENT:
      case ActivityCommentEnum.UPDATE_REPLY:
      case ActivityCommentEnum.UpdateEmoji:
        context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
          UpdateObjectiveProgressDTO(
            userId: '', // Provide the actual user ID
            actionType: ObjectifActionType.Update.name,
            feature: [
              state.activityCommentEnum==ActivityCommentEnum.UpdateEmoji?FeaturesType.Emojis.name:
              state.activityCommentEnum==ActivityCommentEnum.UPDATE_COMMENT?FeaturesType.Comments.name:
              FeaturesType.Replys.name
            ],
          ),
        );
        break;
    // Handle other cases if needed
      case ActivityCommentEnum.LOADING:
      case ActivityCommentEnum.INITIAL:

      case ActivityCommentEnum.GET_COMMENTS:
      case ActivityCommentEnum.GET_COMMENT_BY_ID:


      case ActivityCommentEnum.GET_REPLIES:
      case ActivityCommentEnum.GET_REPLY_BY_ID:

      case ActivityCommentEnum.SEND_NOTIFICATION:
      // No action needed for these cases
        break;

      default:
        break;
    }
  }

static   void ListentoJoinButton(AcivityFState state, BuildContext context,String act) {
  if (state.activityfetchState == ActivityFetchState.Participate) {
    Logger().wtf("lezemha tatlaa");
    context.read<UserObjectifProgressCubit>().updateProgressUserObjective(UpdateObjectiveProgressDTO(
        userId: '',
        actionType: ObjectifActionType.Join.name,
        feature: [FeaturesType.Activities.name,act], progress: 1));
  }
  else if (state.activityfetchState == ActivityFetchState.Left) {
    Logger().wtf("lezemha tatlaa");
    context.read<UserObjectifProgressCubit>().updateProgressUserObjective(UpdateObjectiveProgressDTO(
        userId: '',
        actionType: ObjectifActionType.Join.name,
        feature: [FeaturesType.Activities.name,act], progress: -1));
  }
}
  static void Listener(AddDeleteUpdateState ste, BuildContext context) {
    if (ste is ErrorAddDeleteUpdateState) {
      SnackBarMessage.showErrorSnackBar(
          message: ste.message, context: context);
    }
    if (ste is MessageAddDeleteUpdateState) {
      Navigator.of(context).pop();
      SnackBarMessage.showSuccessSnackBar(
          message: ste.message, context: context);

      context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
        UpdateObjectiveProgressDTO(
            userId: '', // Provide the actual user ID
            actionType: ObjectifActionType.Create.name,
            feature: [FeaturesType.Activities.name,  context.read<ActivityCubit>().state.selectedActivity.name, ],
            progress: 1
        ),
      );
    }
    if (ste is ActivityUpdatedState) {
      SnackBarMessage.showSuccessSnackBar(
          message: ste.message, context: context);
      context.read<TaskVisibleBloc>().add(const ChangeImageEvent("",ActionImage.PREVIOUS));
      context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
        UpdateObjectiveProgressDTO(
            userId: '', // Provide the actual user ID
            actionType: ObjectifActionType.Update.name,
            feature: [FeaturesType.Activities.name,  context.read<ActivityCubit>().state.selectedActivity.name, ],
            progress: -1
        ),
      );
      context.back();
    }
    if (ste is DeletedActivityMessage) {
      SnackBarMessage.showSuccessSnackBar(
          message: ste.message, context: context);
      context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
        UpdateObjectiveProgressDTO(
            userId: '', // Provide the actual user ID
            actionType: ObjectifActionType.Create.name,
            feature: [FeaturesType.Activities.name,  context.read<ActivityCubit>().state.selectedActivity.name, ],
            progress: -1
        ),
      );
      context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
        UpdateObjectiveProgressDTO(
            userId: '', // Provide the actual user ID
            actionType: ObjectifActionType.Delete.name,
            feature: [FeaturesType.Activities.name,  context.read<ActivityCubit>().state.selectedActivity.name, ],
            progress: 1
        ),
      );
      context.back();
    }
    if (ste is LoadingAddDeleteUpdateState) {
      const LoadingWidget();
    }
  }
}