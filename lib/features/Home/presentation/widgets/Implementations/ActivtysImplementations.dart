
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../Activity_Global.dart';
import '../../../domain/Dtos/ActivityParam.dart';
import '../../../domain/enums/ActivityEnum.dart';
import '../../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../Activity/ActivityDetailsComponents.dart';
import '../Activity/ActivityDetailsWidget.dart';
import '../Activity/ActivityImplWidgets.dart';
import '../Activity/EventListWidget.dart';
import '../Home/CalendarPage.dart';
import '../shimmer/Shimmer_list.dart';
import '../shimmer/reload_details.dart';

Widget BlocMonthlyWeeklyActivity(activity act, MediaQueryData mediaQuery) =>
    BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, actState) {
        return BlocConsumer<AcivityFBloc, AcivityFState>(
          builder: (context, state) {

            switch (state.activityfetchState) {
              case ActivityFetchState.Error:
              case ActivityFetchState.Empty:
              case ActivityFetchState.Loading:

                return const ActivityMonth();
              case ActivityFetchState.ActivityLoaded:
              case ActivityFetchState.ActivityChanged:
              case ActivityFetchState.LoadingButton:

              case ActivityFetchState.ACtivityLoadedMonth:
                return RefreshIndicator(
                    onRefresh: () {
                      return onRefresh(context, act, state.activitiesSearch);
                    },
                    child: MonthWeekBuild(actState.selectedActivity, state, mediaQuery)

                );
              default:
                return const ActivityMonth();
            }


          }, listener: (BuildContext context, AcivityFState state) {

        },


        );
      },

    );

Widget ActivityDetails(activity Act, String id, index) {
  return BlocBuilder<ParticpantsBloc, ParticpantsState>(
    builder: (context, ss) {
      return BlocBuilder<AcivityFBloc, AcivityFState>(
          builder: (context, state) {
            switch (state.activityfetchState) {
              case ActivityFetchState.Error:
                context.read<AcivityFBloc>().add(
                    GetActivitiesByid(params: activityParams(
                        type: Act, act: null, Eventid: id, name: '')));
                return const ReloadDetailsPage();
              case ActivityFetchState.ActivityLoaded:
              case ActivityFetchState.ActivityChanged:
              case ActivityFetchState.LoadingButton:

              case ActivityFetchState.ActivityByIdLoaded:
                if (state.activityById == null) {
                  context.read<AcivityFBloc>().add(
                      GetActivitiesByid(params: activityParams(
                          type: Act, act: null, Eventid: id, name: '')));
                  return const ReloadDetailsPage();
                }

                return ActivityDetail(
                  activitys: state.activityById!, act: Act, index: index,);
              default:
                context.read<AcivityFBloc>().add(
                    GetActivitiesByid(params: activityParams(
                        type: Act, act: null, Eventid: id, name: '')));

                return const ReloadDetailsPage();
            }

          }
      );
    },
  );
}

Widget ShowCalendarWidget() =>
    BlocBuilder<AcivityFBloc, AcivityFState>(
        builder: (context, state) {

          switch (state.activityfetchState) {
            case ActivityFetchState.Error:
            case ActivityFetchState.Empty:
              return const SizedBox();
            case ActivityFetchState.ActivityLoaded:
              return CalendarPage(activities: state.activitiesSearch,);
            default:
              return const SizedBox();
          }}
    );




Widget ALLActivities( activity act,) {
  return BlocBuilder<AcivityFBloc, AcivityFState>(
    builder: (context, state) {
      return RefreshIndicator(
          onRefresh: () => onAllRefresh(context, act, state.activitiesSearch),
          child: _handleParticipantStates(context, state, act)

      );
    },
  );
}

Widget _handleParticipantStates(BuildContext context, AcivityFState state,
    activity act) {
//switch

  switch (state.activityfetchState) {

    case ActivityFetchState.Empty:
      return Text("No Activities", style: PoppinsRegular(17, textColorBlack));

    case ActivityFetchState.ActivityLoaded:
    case ActivityFetchState.ActivityChanged:
    case ActivityFetchState.LoadingButton:
      return ActivityWidget(Activities: state.activitiesSearch, act: act);
    case ActivityFetchState.Error:

      return const ShimmerEventList();
    default:
      return const ShimmerEventList();
  }
}


Widget AddButtonWi(Color color, Color IconColor, IconData ICON,
    Function() onPressed) {
  return BlocBuilder<AddDeleteUpdateBloc, AddDeleteUpdateState>(
    builder: (context, state) {
      return AddButton(
        color: color, IconColor: IconColor, icon: ICON, onPressed: onPressed,);
    },
  );
}

Widget AddDots(Activity activitys, MediaQueryData mediaQuery) {
  return BlocBuilder<AddDeleteUpdateBloc, AddDeleteUpdateState>(
    builder: (context, state) {

      //if (state.hasPermission) {

      return ActivityDetailsComponent.dots(context, mediaQuery, activitys);

      // }




    },
  );
}
