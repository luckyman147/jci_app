import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/domain/Dtos/ActivityParam.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/PV/pv_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Poll/poll_bloc.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:logger/logger.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../core/util/ObjectifProgressTopSnackBar.dart';

import '../../../MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';

import '../../domain/enums/ActivityEnum.dart';
import '../../domain/enums/ParticipantWithEvents.dart';
import '../widgets/Functions/Listeners.dart';
import 'package:jci_app/core/config/env/Constants.dart';

@RoutePage()
class ActivityDetailsPage extends StatefulWidget {
  final String activityType;
  final String id;
  final int index;

  const ActivityDetailsPage({
    Key? key,
    required this.activityType,
    required this.id,
    required this.index,
  }) : super(key: key);

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {


  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  void _initializePage() {
    final ActivityType=activity.values.firstWhere((te) => te.name == widget.activityType);
    context.read<PermissionsBloc>().add(LoadPermissionOfMasterEvent(featuresId: [

    if (ActivityType==activity.Events) Constants.MANAGE_EVENTS,
      if (ActivityType==activity.Meetings)  Constants.MANAGE_MEETINGS,
      if (ActivityType==activity.Trainings) Constants.MANAGE_TRAININGS]));
    _refreshData(ActivityType);
    context.read<ActivityCommentBloc>().add(GetActivitysComment(widget.id));
    context.read<PollBloc>().add(FetchPolls(ActivityId: widget.id));
    context.read<PvBloc>().add(GetPvList(widget.id));
  }

  void _refreshData(activity act) {
    final result = activityParams(
      type: act,
      act: null,
      Eventid: widget.id,
      name: '',
    );
    context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));
  }

  @override
  Widget build(BuildContext context) {
    return
      ShowCaseWidget(


          builder: (context)=>
      BlocBuilder<AcivityFBloc, AcivityFState>(
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            color: ColorsApp.SecondaryColor,
            onRefresh: () async {
              _refreshData(activity.values.firstWhere((te) => te.name == widget.activityType));
            },
            child: SingleChildScrollView(
              child: _buildBlocListeners(),
            ),
          ),
        );
      },
    ));
  }

  Widget _buildBlocListeners() {
    return MultiBlocListener(
      listeners: [

        BlocListener<UserObjectifProgressCubit,UserObjectifProgressState>(
        listener: (context,objState){
    Logger().wtf(objState.progresStatus);
   // TopSnackbar.show(objState.userProgresUpdates, context);

    }),
        BlocListener<AcivityFBloc, AcivityFState>(
          listener: (context, state) {
            if (state.activityfetchState==ActivityFetchState.Error){
              context.back();
            }

            Listeners.ListentoJoinButton(state, context, widget.activityType);
          },
        ),

        BlocListener<PollBloc,PollState>(listener: (context,state){

          Listeners.handlePollState(context, state, widget.id);

        }),


        BlocListener<ParticpantsBloc, ParticpantsState>(
          listener: (context, state) {
            if (state.status == ParticpantsStatus.success) {
              SnackBarMessage.showSuccessSnackBar(
                message: state.message,
                context: context,
              );
            } else if (state.status == ParticpantsStatus.failed) {
              SnackBarMessage.showErrorSnackBar(
                message: state.message,
                context: context,
              );
            }
          },
        ),



        BlocListener<ActivityCommentBloc, ActivityCommentState>(
          listener: (context, state) {
           Listeners. handleActivityCommentState(context,state);
          },
        ),
      ],
      child: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, state) {
          return buildActivityDetailsBody(
            context,
            state.selectedActivity,
            widget.id,
            widget.index,
          );
        },
      ),
    );
  }
}