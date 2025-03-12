import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/domain/Dtos/ActivityParam.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/PV/pv_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Poll/poll_bloc.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/PermissionsBLoc/permissions_bloc.dart';
import '../../domain/enums/ActivityCommentEnum.dart';
import '../../domain/enums/ParticipantWithEvents.dart';

class ActivityDetailsPage extends StatefulWidget {
  final String Activity;
  final String id;
  final int index;
  const ActivityDetailsPage({Key? key, required this.Activity, required this.id, required this.index}) : super(key: key);

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  late activity act;
  @override
  void initState() {
    Refreshable();
context.read<ActivityCommentBloc>().add( GetActivitysComment(widget.id));
context.read<PollBloc>().add( FetchPolls( ActivityId: widget.id));
context.read<PvBloc>().add( GetPvList(  widget.id));


    // TODO: implement initState
    super.initState();
  }

  void Refreshable() {
       if (widget.Activity == 'Meetings') {
      final result=        activityParams(type: activity.Meetings, act: null,Eventid: widget.id, name: '');
      context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));
    }
    else if (widget.Activity == 'Trainings') {
      final result=        activityParams(type: activity.Trainings, act: null,Eventid: widget.id, name: '');
      context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));

    }
    else if (widget.Activity == 'Events') {
      final result=        activityParams(type: activity.Events, act: null,Eventid: widget.id, name: '');
      context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));
    }
  }
  @override
  Widget build(BuildContext context) {

    return  BlocBuilder<AcivityFBloc, AcivityFState>(
  builder: (context, state) {
    return Scaffold(

      body: RefreshIndicator(
        color: ColorsApp .SecondaryColor,
        onRefresh: ()async {
          Refreshable();
        },
        child: SingleChildScrollView(
          child: BlocListener<ParticpantsBloc, ParticpantsState>(
  listener: (context, state) {
    if (state.status == ParticpantsStatus.success) {
      //pop

      //show snackbar
      SnackBarMessage.showSuccessSnackBar(message: state.message, context: context);

    }
    else if (state.status == ParticpantsStatus.failed) {
      //show snackbar
      SnackBarMessage.showErrorSnackBar(message: state.message, context: context);
    }
    // TODO: implement listener
  },
  child: BlocListener<ActivityCommentBloc, ActivityCommentState>(
          listener: (context, state) {
            if (state.activityCommentEnum ==ActivityCommentEnum.ERROR){
        SnackBarMessage.showErrorSnackBar(
          message: state.message,
          context: context,
        );}
            else if (state.activityCommentEnum ==ActivityCommentEnum.ADD_COMMENT){



            }
            // TODO: implement listener
          },
          child: BlocBuilder<ActivityCubit, ActivityState>(
            builder: (context, state) {
              return buildActivityDetailsBody(context, state.selectedActivity, widget.id,widget.index);
            },
          ),
        ),
),
        ),
      ),
    );
  },
);
  }
}
