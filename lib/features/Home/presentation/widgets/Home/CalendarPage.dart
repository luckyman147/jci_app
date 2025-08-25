
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/features/Home/presentation/widgets/Activity/EventListWidget.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/config/env/Constants.dart';
import '../../../../../core/route/app_router.dart';
import '../../../../changelanguages/presentation/bloc/locale_cubit.dart';
import '../../../domain/Dtos/ActivityParam.dart';
import '../../../domain/entities/Activitys/Activity.dart';
import '../../bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import '../../bloc/calendar/calendar_cubit.dart';
import '../Functions/ActivityFunctions.dart';
import '../components/calendar/EventTimelineCalendar.dart';

class CalendarPage extends StatefulWidget {
  final List<Activity> activities;
  const CalendarPage({Key? key, required this.activities}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime today = DateTime.now();
  late final ValueNotifier<List<Activity>> _selectedEvents;
  @override
  void initState() {
    context.read<CalendarCubit>().selectDate(DateTime.now());
    context.read<CalendarCubit>().selectActivity(
_getEventsForDay(DateTime.now()));

    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<localeCubit,LocaleState >(
        builder: (context, state) {
          return Container(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                calendar(state),
                const SizedBox(height: 20,),
                EventTimeline(state)
            //

              ],

            ),
          );
        },

    );

  }Widget EventTimeline(LocaleState ste) {
    final hours = List.generate(16, (index) => 5 + index); // 08:00 → 23:00

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: ColorsApp.textColorWhite,
        border: Border.all(color: ColorsApp.PrimaryColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      height: MediaQuery.of(context).size.height / 2,
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          Logger().w(widget.activities.length);

          return ListView.builder(
            itemCount: hours.length,
            itemBuilder: (context, index) {
              final hour = hours[index];

              // Find events that start OR are ongoing during this hour
              final matchingEvents = state.activities.where((e) {
                final start = e.activityBasics.activityBeginDate;
                final end = e.activityBasics.activityEndDate;
                return hour >= start.hour && hour <= end.hour;
              }).toList();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hour label
                    SizedBox(
                      width: 60,
                      height: 39,
                      child: Text(
                        "${hour.toString().padLeft(2, '0')}:00",
                        textAlign: TextAlign.center,
                        style: PoppinsRegular(18, ColorsApp.textColorBlack),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Timeline vertical line
                    SizedBox(
                      height: 60,
                      width: 40,
                      child: VerticalDivider(
                        color: ColorsApp.SecondaryColor,
                        width: 10,
                        thickness: 3,
                      ),
                    ),

                    // Events
                    Expanded(
                      child: matchingEvents.isEmpty
                          ? const SizedBox(height: 60)
                          : GridView.count(
                        crossAxisCount: matchingEvents.length > 1 ? 2 : 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 7,
                             childAspectRatio:2,

                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: matchingEvents.map((event) {

                          return

                            InkWell(
                              onTap: (){
                                context.pushRoute(ActivityDetailsRoute(
                                  id: event.activityBasics.id,
                                  activityType: context.read<ActivityCubit>().state.selectedActivity.name,
                                  index: widget.activities.indexOf(event),
                                ));
                              },

                                child:
                            Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColorsApp.PrimaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.activityBasics.name,
                                  style: PoppinsSemiBold(
                                    16,
                                    ColorsApp.textColorWhite,
                                    TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event.activityBasics.activityAdress,
                                  style: PoppinsRegular(
                                    12,
                                    ColorsApp.textColorWhite,
                                  ),
                                ),
                              ],
                            ),
                          ));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }


  ListTile listTileCalendar(BuildContext context, List<Activity> value, int index, ActivityState state,LocaleState lste) {
    String formattedDate = DateFormat('dd MMM yyyy', lste.locale == const Locale("en") ? "en_US" : "fr_FR").format(value[index].activityBasics.activityBeginDate);
    String formattedTime = DateFormat('HH:mm').format(value[index].activityBasics.activityBeginDate);
    String formattedDateTime = lste.locale == const Locale("en") ? "$formattedDate At $formattedTime" : "$formattedDate A $formattedTime";

    return ListTile(
                          onTap: (){
                            context.pushRoute(ActivityDetailsRoute(
                              id: value[index].activityBasics.id,
                              activityType: state.selectedActivity.name,
                              index: index,
                            ));
                          },

                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: const BorderSide(color: textColorBlack)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,color: textColorWhite,),


                          title: SizedBox(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: Row(

                              children: [
                                AsyncComponents.buildFutureBuilder(    ReminderButton(context, value, index), PermissionType.canUpdate,""),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(value[index].activityBasics.name,  overflow: TextOverflow.ellipsis,   style: PoppinsSemiBold(16, textColorWhite,TextDecoration.none),),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: paddingSemetricHorizontal(),
                                          child: const Icon(Icons.location_on,color: textColorWhite,),
                                        ),

                                        SizedBox(
                                            width: MediaQuery.of(context).size.width/2.5,
                                            child: Text(value[index].activityBasics.activityAdress,overflow: TextOverflow.ellipsis,style: PoppinsRegular(16, textColorWhite,),)),


                                      ],

                                    ),
                                    Padding(
                                      padding: paddingSemetricVertical(),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: paddingSemetricHorizontal(),
                                            child:const  Icon(Icons.calendar_today_rounded,color: textColorWhite,),
                                          ),
                                          Text(formattedDateTime,style: PoppinsRegular(14, textColorWhite),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        );
  }

  IconButton ReminderButton(BuildContext context, List<Activity> value, int index) {
    return IconButton(icon:
      const Icon(Icons.alarm_on_outlined,color: textColorWhite,), onPressed: () {
      context.read<ParticpantsBloc>().add(SendReminderEvent(reminderParams: ReminderParams(value[index].activityBasics.activityAdress,ActivityName: value[index].activityBasics.name,
          ActivityBeginDate: value[index].activityBasics.activityBeginDate.toIso8601String())));

    }
      ,);
  }
  BlocBuilder<CalendarCubit, CalendarState> calendar(LocaleState state) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, se) {
     return   BlocBuilder<ActivityCubit,ActivityState>(builder: (context,Astate)=>
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: ColorsApp.PrimaryColor, // ✅ Primary color background
            elevation: 9,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TableCalendar(

                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: PoppinsRegular(10, ColorsApp.textColorWhite),
                      weekendStyle:  PoppinsRegular(10, ColorsApp.textColorWhite),
                    ),

                    calendarFormat: CalendarFormat.week,
                    availableCalendarFormats: const {
                      CalendarFormat.week: 'Week', // ✅ Only week view
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    calendarStyle: CalendarStyle(
                      markersAutoAligned: true,
                      markerDecoration: BoxDecoration(
                        color: Colors.white, // Markers white
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: PoppinsRegular(16, Colors.white),
                      selectedTextStyle: PoppinsRegular(16, ColorsApp.PrimaryColor),
                      markersAlignment: Alignment.topCenter,
                      selectedDecoration: const BoxDecoration(
                        shape: BoxShape.circle, // ✅ Circle for selected day
                        color: Colors.white,
                      ),
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      weekendTextStyle: PoppinsRegular(16, Colors.white), // ✅ weekends
                      defaultTextStyle: PoppinsRegular(16, Colors.white),
                      outsideTextStyle: PoppinsRegular(16, Colors.white.withOpacity(0.5)),
                      outsideDaysVisible: true,
                    ),
                    eventLoader: (day) => _getEventsForDay(day),
                    locale: state.locale == const Locale("en") ? "en_US" : "fr_FR",
                    rowHeight: 40,
                    headerStyle: HeaderStyle(
                      titleTextStyle: PoppinsSemiBold(20, Colors.white, TextDecoration.none),
                      formatButtonVisible: false,
                      leftChevronIcon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                      rightChevronIcon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                      titleCentered: true,
                    ),
                    onDaySelected: (selectedDay, focusedDay) {

                        context.read<CalendarCubit>().selectDate(selectedDay);
                        context.read<CalendarCubit>().selectActivity(_getEventsForDay(selectedDay));


                    },
                    selectedDayPredicate: (day) => isSameDay(se.selectedDate, day),
                    availableGestures: AvailableGestures.all,
                    focusedDay: se.selectedDate!,
                    firstDay: DateTime(2024, 1, 1),
                    lastDay: DateTime.now().add(const Duration(days: 356)),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // ✅ White button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        ActivityFunctions.   NavigateActivity(context,Astate.selectedActivity);                      // Navigate to Create Event

                        // TODO: Navigate to Create Activity screen
                      },
                      icon: Icon(Icons.add, color: ColorsApp.PrimaryColor),
                      label: Text(
                        "Create Activity",
                        style: PoppinsSemiBold(16, ColorsApp.PrimaryColor, TextDecoration.none),
                      ),
                    ),
                  ).withPermission(PermissionType.canCreate,  Astate.selectedActivity==activity.Events?
                  Constants.MANAGE_EVENTS
                      :   Astate.selectedActivity==activity.Trainings?
                  Constants.MANAGE_TRAININGS
                      :Constants.MANAGE_MEETINGS)
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  List<Activity> _getEventsForDay(DateTime dateTime) {
    return widget.activities.where((element) => isSameDay(element.activityBasics.activityBeginDate, dateTime)).toList();
  }
}
