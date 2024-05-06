
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';
import 'package:jci_app/features/Home/presentation/widgets/GuestWidget.dart';


import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/widgets/Text.dart';
import '../../domain/entities/Activity.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';

import '../bloc/PageIndex/page_index_bloc.dart';
import 'ActivityDetailsComponents.dart';
import 'ActivityDetailsWidget.dart';
import 'ErrorDisplayMessage.dart';
import 'EventListWidget.dart';
import 'EventOfweek.dart';
import 'Functions.dart';
import 'ShimmerEffects.dart';



Future<void> onRefresh(BuildContext context, activity act, List<Activity> actu) async {
  context.read<ParticpantsBloc>().add(initstateList(act: ActivityAction.mapObjects(actu)));

  context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent(act: act));

}

Future<void> onAllRefresh(BuildContext context, activity act,
    List<Activity> actu) async {
  context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: act));
  context.read<ParticpantsBloc>().add(initstateList(act: ActivityAction.mapObjects(actu)));

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
              return ReloadDetailsPage();
            } else if (state is ACtivityByIdLoadedState) {

              return ActivityDetail(activitys: state.activity, act: Act, index: index,);
            }
            else if (state is ErrorActivityState) {
              return ReloadDetailsPage();
            }
            else {
              return ReloadDetailsPage();
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


                return

                  onAllRefresh(context, act, state.activitys);
              },
              child:
              BlocBuilder<ParticpantsBloc, ParticpantsState>(
  builder: (context, ste) {
switch (ste.status){


  case ParticpantsStatus.initial:
    context.read<ParticpantsBloc>().add(initstateList(act: ActivityAction.mapObjects(state.activitys)));
    return LoadingWidget();

  case ParticpantsStatus.loading:
    return LoadingWidget();

  case ParticpantsStatus.failed:
    return LoadingWidget();

  case ParticpantsStatus.success:
  case ParticpantsStatus.changed:
  case ParticpantsStatus.loaded:
  case ParticpantsStatus.empty:
  case ParticpantsStatus.LoadedGuests:


    if  (ste.isParticipantAdded.length==state.activitys.length ){

    return ActivityWidget(Activities: state.activitys, act: act,);
  }
    else{

      context.read<ParticpantsBloc>().add(initstateList(act: ActivityAction.mapObjects(state.activitys)));
      return LoadingWidget();
    }
    break;
  default:
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
Widget AddButtonWi(Color color,Color IconColor, IconData ICON ,Function() onPressed){
  return BlocBuilder<AddDeleteUpdateBloc, AddDeleteUpdateState>(
    builder: (context, state) {
      if (state is PermissionState) {

        if (state.hasPermission) {

          return AddButton(
            color: color, IconColor: IconColor, icon: ICON, onPressed:onPressed,);
        }
        return SizedBox();
      }
      return Container();
    },
  );
}
Widget AddDots(Activity activitys,MediaQueryData mediaQuery){
  return BlocBuilder<AddDeleteUpdateBloc, AddDeleteUpdateState>(
    builder: (context, state) {
      if (state is PermissionState) {

        if (state.hasPermission) {

          return             ActivityDetailsComponent.dots(context, mediaQuery, activitys);

      }
        return SizedBox();
      }
      return Container();
    },
  );
}
Widget ShowPartipants(String activityId){
  return BlocBuilder<ParticpantsBloc, ParticpantsState>(
    builder: (context, state) {
    switch(state.status){
      case ParticpantsStatus.initial:
        context.read<ParticpantsBloc>().add(LoadIsParttipatedList(activityId: activityId));
        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.loading:
        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.failed:
        context.read<ParticpantsBloc>().add(LoadIsParttipatedList(activityId: activityId));

        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.loaded:
      case ParticpantsStatus.changed:
      case ParticpantsStatus.success:
      case ParticpantsStatus.LoadedGuests:
      case ParticpantsStatus.empty:

        return ActivityDetailsComponent.ParticipantsWidget( state.members,activityId,context);
      default:
        context.read<ParticpantsBloc>().add(LoadIsParttipatedList(activityId: activityId));

        return ShimmerButton.shimmerparticipants();
    }
    },
  );

}
Widget ShowGuests(String activityId){
  return BlocBuilder<ParticpantsBloc, ParticpantsState>(
    builder: (context, state) {
    switch(state.status){
      case ParticpantsStatus.initial:

        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.loading:
        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.failed:
        context.read<ParticpantsBloc>().add(GetGuestsEvent(activityId: activityId));

        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.loaded:
        context.read<ParticpantsBloc>().add(GetGuestsEvent(activityId: activityId));
return ShimmerButton.shimmerparticipants();
        case ParticpantsStatus.changed:
          context.read<ParticpantsBloc>().add(GetGuestsEvent(activityId: activityId));
          return ShimmerButton.shimmerparticipants();
          
          
          case ParticpantsStatus.empty:
          return SizedBox();
            
            case ParticpantsStatus.success:
          case ParticpantsStatus.LoadedGuests:
            
            
            log("sssss"+state.guests.toString());
        return GuestWidget(guests: state.guests, activityId: activityId,);
      default:
        context.read<ParticpantsBloc>().add(GetGuestsEvent(activityId: activityId));

        return ShimmerButton.shimmerparticipants();
    }
    },
  );

}



