import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/domain/Dtos/ActivityParam.dart';
import 'package:jci_app/features/Home/domain/entities/poll/Poll.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/PV/pv_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Poll/poll_bloc.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:logger/logger.dart';

import '../../../../core/util/ObjectifProgressTopSnackBar.dart';
import '../../../MemberSection/domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../../MemberSection/domain/entity/ActionDetails.dart';
import '../../../MemberSection/domain/entity/Objectif.dart';
import '../../../MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import '../../domain/enums/ActivityCommentEnum.dart';
import '../../domain/enums/ActivityEnum.dart';
import '../../domain/enums/ParticipantWithEvents.dart';
import '../widgets/Functions/Listeners.dart';

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
  late activity act;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  void _initializePage() {
    _refreshData();
    context.read<ActivityCommentBloc>().add(GetActivitysComment(widget.id));
    context.read<PollBloc>().add(FetchPolls(ActivityId: widget.id));
    context.read<PvBloc>().add(GetPvList(widget.id));
  }

  void _refreshData() {
    final result = activityParams(
      type: activity.values.firstWhere((te) => te.name == widget.activityType),
      act: null,
      Eventid: widget.id,
      name: '',
    );
    context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcivityFBloc, AcivityFState>(
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            color: ColorsApp.SecondaryColor,
            onRefresh: () async {
              _refreshData();
            },
            child: SingleChildScrollView(
              child: _buildBlocListeners(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBlocListeners() {
    return MultiBlocListener(
      listeners: [

        BlocListener<UserObjectifProgressCubit,UserObjectifProgressState>(
        listener: (context,objState){
    Logger().wtf(objState.progresStatus);
    TopSnackbar.show(objState.userProgresUpdates, context);

    }),
        BlocListener<AcivityFBloc, AcivityFState>(
          listener: (context, state) {

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