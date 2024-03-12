import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';


import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/widgets/Text.dart';
import '../../domain/entities/Activity.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';

import '../bloc/PageIndex/page_index_bloc.dart';
import 'ActivityDetailsWidget.dart';
import 'ErrorDisplayMessage.dart';
import 'EventListWidget.dart';
import 'EventOfweek.dart';
import 'Functions.dart';

Future<void> ACtivityDetailRefresh(BuildContext context, activity act,index,


String id) async {
//context.read<ParticpantsBloc>().add(initstateList(act: mapObjects(widget.Activities)));
context.read<AcivityFBloc>().add(GetActivitiesByid(id: id, act: act));
}

Future<void> onRefresh(BuildContext context, activity act, List<Activity> actu) async {
  context.read<ParticpantsBloc>().add(initstateList(act: mapObjects(actu)));

  context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent(act: act));

}

Future<void> onAllRefresh(BuildContext context, activity act,
    List<Activity> actu) async {
  context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: act));
  context.read<ParticpantsBloc>().add(initstateList(act: mapObjects(actu)));



  debugPrint('refreshed');
}

Widget BlocMonthlyWeeklyActivity(activity act,MediaQueryData mediaQuery) =>
    BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, actState) {
 
    return BlocConsumer<AcivityFBloc, AcivityFState>(
      builder: (context, state) {
        if (state is ActivityLoadingState) {
          return LoadingWidget();
        } else if (state is ActivityLoadedMonthState) {


          return RefreshIndicator(
              onRefresh: () {
                print(state.activitys.length);

                return

                  onAllRefresh(context, act,state.activitys);
              },
              child:

          MonthWeekBuild(actState.selectedActivity, state, mediaQuery)

          );
        }
        else if (state is ErrorActivityState) {
          return MessageDisplayWidget(message: state.message);
        }
        return LoadingWidget();
      }, listener: (BuildContext context, AcivityFState state) {

    },


    );
  },

);

Widget ActivityDetails(activity Act, String id,index) {
  return BlocBuilder<ParticpantsBloc, ParticpantsState>(
    builder: (context, ss) {
      return BlocBuilder<AcivityFBloc, AcivityFState>(
          builder: (context, state) {
            if (state is ActivityLoadingState) {
              return LoadingWidget();
            } else if (state is ACtivityByIdLoadedState) {
              print(ss.isParticipantAdded[index]);
              print(index);

              return RefreshIndicator(
                  onRefresh: () {
                    print(state.activity);
                    return

                      ACtivityDetailRefresh(context, Act,index, id);
                  },
                  child: ActivityDetail(activitys: state.activity, bools: ss.isParticipantAdded[index]['isPart'], act: Act, index: index,)
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
    },
  );
}


Widget ALLActivities(activity act) =>
    BlocConsumer<AcivityFBloc, AcivityFState>(
      builder: (context, state) {
        if (state is ActivityLoadingState) {
          return LoadingWidget();
        } else if (state is ActivityLoadedState) {


          return RefreshIndicator(
              onRefresh: () {
                print(state.activitys.length);

                return

                  onAllRefresh(context, act, state.activitys);
              },
              child:
              BlocBuilder<ParticpantsBloc, ParticpantsState>(
  builder: (context, ste) {
   debugPrint(ste.toString());
    if  ((ste.isParticipantAdded.length==state.activitys.length&& (ste is ParticipantChanged || ste is ParticipantSuccessState )) ){

    return ActivityWidget(Activities: state.activitys, act: act,);
  }
    else{
      context.read<ParticpantsBloc>().add(initstateList(act: mapObjects(state.activitys)));
      return LoadingWidget();
    }
    },
)


          );
        }
        else if (state is ErrorActivityState) {
          return MessageDisplayWidget(message: state.message);
        }
        return LoadingWidget();
      }, listener: (BuildContext context, AcivityFState state) {

    },


    );




