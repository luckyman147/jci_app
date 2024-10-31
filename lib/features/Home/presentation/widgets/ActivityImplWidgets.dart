
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/CalendarPage.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';
import 'package:jci_app/features/Home/presentation/widgets/GuestWidget.dart';


import '../../../../core/app_theme.dart';
import '../../domain/entities/Activity.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../bloc/Activity/BLOC/notesBloc/notes_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';

import 'ActivityDetailsComponents.dart';
import 'ActivityDetailsWidget.dart';
import 'EventListWidget.dart';
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
          return  ReloadDetailsPage.ActivityMonth();
        } else if (state is ActivityLoadedMonthState) {


          return RefreshIndicator(
              onRefresh: () {


                return

                  onAllRefresh(context, act,state.activitys);
              },
              child:



          MonthWeekBuild(actState.selectedActivity, state, mediaQuery)

          );
        }
        else if (state is ErrorActivityState) {
          return  ReloadDetailsPage.ActivityMonth();
        }
        return  ReloadDetailsPage.ActivityMonth();
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
              return const ReloadDetailsPage();
            } else if (state is ACtivityByIdLoadedState) {

              return ActivityDetail(activitys: state.activity, act: Act, index: index,);
            }
            else if (state is ErrorActivityState) {
              return const ReloadDetailsPage();
            }
            else {
              return const ReloadDetailsPage();
            }
          }
      );
    },
  );
}
Widget ShowCalendarWidget()=>BlocBuilder<AcivityFBloc, AcivityFState>(
builder: (context, state) {
if (state is ActivityLoadingState) {
return const SizedBox();
} else if (state is ActivityLoadedState) {

  return CalendarPage(activities: state.activitys,);

}
else if (state is ActivityLoadedMonthState){
return CalendarPage(activities: state.activitys,);
}
else if (state is ErrorActivityState) {
  return const SizedBox();
}
return const SizedBox();
},
);



Widget ALLActivities(activity act) =>
    BlocConsumer<AcivityFBloc, AcivityFState>(
      builder: (context, state) {
        if (state is ActivityLoadingState) {
          return ReloadDetailsPage.buildshimmerreventlist();
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
    return ReloadDetailsPage.buildshimmerreventlist();




  case ParticpantsStatus.failed:  case ParticpantsStatus.loading:
    return ReloadDetailsPage.buildshimmerreventlist();

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
      return ReloadDetailsPage.buildshimmerreventlist();
    }
    break;
  default:
    return ReloadDetailsPage.buildshimmerreventlist();

}

    },
)


          );
        }
        else if (state is ErrorActivityState) {
          return ReloadDetailsPage.buildshimmerreventlist();
        }
        return ReloadDetailsPage.buildshimmerreventlist();
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
        return const SizedBox();
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
        return const SizedBox();
      }
      return Container();
    },
  );
}
Widget ShowPartipants(String activityId){
  return BlocBuilder<ParticpantsBloc, ParticpantsState>(
    builder: (context, state) {
    switch(state.status){
      case ParticpantsStatus.loading:
        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.initial:      case ParticpantsStatus.failed:
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
      case ParticpantsStatus.loading: case ParticpantsStatus.ToMember:
        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.loaded:  case ParticpantsStatus.changed: case ParticpantsStatus.failed:
        context.read<ParticpantsBloc>().add(GetGuestsOfActivityEvent(activityId: activityId));
return ShimmerButton.shimmerparticipants();


          
          
          case ParticpantsStatus.empty:
          return const SizedBox();
            
            case ParticpantsStatus.success:
          case ParticpantsStatus.LoadedGuests:


            

        return GuestWidget(guests: state.guestsSearch, activityId: activityId, index: 0,);
      default:
        context.read<ParticpantsBloc>().add(GetGuestsOfActivityEvent(activityId: activityId));

        return ShimmerButton.shimmerparticipants();
    }
    },
  );

}
Widget ShowAllGuests(String activityId){
  return BlocBuilder<ParticpantsBloc, ParticpantsState>(
    builder: (context, state) {
    switch(state.status){
      case ParticpantsStatus.initial:
      case ParticpantsStatus.loading:

        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.failed:  case ParticpantsStatus.changed:
        context.read<ParticpantsBloc>().add(const GetAllGuestsEvent(isUpdated: true));

        return ShimmerButton.shimmerparticipants();
      case ParticpantsStatus.loaded:
      case ParticpantsStatus.ToMember:

        context.read<ParticpantsBloc>().add(const GetAllGuestsEvent());
        return ShimmerButton.shimmerparticipants();
          case ParticpantsStatus.empty:
          return const SizedBox();

            case ParticpantsStatus.success:
          case ParticpantsStatus.LoadedGuests:
        return GuestWidget.GuestALL(context,state.Allguests,activityId);
      default:
        context.read<ParticpantsBloc>().add(const GetAllGuestsEvent());

        return ShimmerButton.shimmerparticipants();
    }
    },
  );

}
BlocConsumer<NotesBloc, NotesState> NotesImpl(Widget widget, String activityId    ){
  return BlocConsumer<NotesBloc, NotesState>(
    builder: (context, state) {
      switch (state.status){
        case NotesStatus.initial:
          return ReloadDetailsPage.loadNotesShimer(3);
        case NotesStatus.success:
          if (state.notes.isEmpty) {
            return  Center(child: Text('No Notes',style: PoppinsRegular(17, textColorBlack),));
          }
          return widget;
        case NotesStatus.failure:
          log(activityId);
          context.read<NotesBloc>().add(Notesfetched(activityId: activityId, isUpdated: true));

          return ReloadDetailsPage.loadNotesShimer(3);

        default:
          context.read<NotesBloc>().add(Notesfetched(activityId: activityId, isUpdated: false));

          return ReloadDetailsPage.loadNotesShimer(3);
      }
    }, listener: (BuildContext context, NotesState state) {
    if (state.status == NotesStatus.failure) {
      context.read<NotesBloc>().add(Notesfetched(activityId: activityId, isUpdated: true));

    }
  },
  );
}




