import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../bloc/Activity/BLOC/acivity_f_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';

import 'ActivityDetailsWidget.dart';
import 'ErrorDisplayMessage.dart';
import 'EventListWidget.dart';
import 'EventOfweek.dart';

Future<void> ACtivityDetailRefresh(BuildContext context,activity act,String id) async {
  context.read<AcivityFBloc>().add(GetActivitiesByid( id: id, act: act));
}

Future<void> onRefresh(BuildContext context,activity act) async {


    context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent(act: act));
    context.read<ActivityOfweekBloc>().add(GetOfWeekActivitiesEvent(act: act));



}Future<void> onAllRefresh(BuildContext context,activity act) async {
  context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: act));

}

Widget BlocMonthlyActivity(activity act)=>BlocConsumer<AcivityFBloc, AcivityFState>(
  builder: (context, state) {
    if (state is ActivityLoadingState) {
      return LoadingWidget();
    } else if (state is ActivityLoadedMonthState) {
      return RefreshIndicator(
          onRefresh: () {
            print(state.activitys.length);
            return

              onRefresh(context,act);
          },
          child:


          ActivityOfMonthListWidget(Activities: state.activitys,)

      );
    }
    else if (state is ErrorActivityState) {
      return MessageDisplayWidget(message: state.message);
    }
    return LoadingWidget();
  }, listener: (BuildContext context, AcivityFState state) {

},


);

Widget ActivityDetails(activity Act ,String id){

  return BlocBuilder<AcivityFBloc, AcivityFState>(
    builder: (context, state) {
      if (state is ActivityLoadingState) {
        return LoadingWidget();
      } else if (state is ACtivityByIdLoadedState) {
        return RefreshIndicator(
            onRefresh: () {
              print(state.activity);
              return

                ACtivityDetailRefresh(context,Act,id);
            },
            child:ActivityDetail( activity: state.activity,)
        );
      }
      else if (state is ErrorActivityState) {
        return MessageDisplayWidget(message: state.message);
      }
      else {
        return LoadingWidget();
      }
}
  );
}


Widget ALLActivities(activity act)=>BlocConsumer<AcivityFBloc, AcivityFState>(
  builder: (context, state) {
    if (state is ActivityLoadingState) {
      return LoadingWidget();
    } else if (state is ActivityLoadedState) {
      return RefreshIndicator(
          onRefresh: () {
            print(state.activitys.length);
            return

              onAllRefresh(context,act);
          },
          child:


          ActivityWidget(Activities: state.activitys,)

      );
    }
    else if (state is ErrorActivityState) {
      return MessageDisplayWidget(message: state.message);
    }
    return Text("data");
  }, listener: (BuildContext context, AcivityFState state) {

},


);







Widget BlocWeekActivity(activity act){
  return BlocBuilder<ActivityOfweekBloc, ActivityOfweekState>(
    builder: (context, state) {
      if (state is ActivityOfTheWeekLoadingState) {
        return LoadingWidget();
      } else if (state is ActivityWeekLoaded) {
        return RefreshIndicator(
            onRefresh: () {
              print(state.act.length);
              return

                onRefresh(context,act);
            },
            child:

            ActivityOfWeekListWidget(activity: state.act,)
        );
      } else if (state is ACtivityWeekError) {
        return MessageDisplayWidget(message: state.message);
      }
      return LoadingWidget();
    },
  );
}

