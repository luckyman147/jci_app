import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/features/Home/presentation/bloc/Calendar/calendar_cubit.dart';
import 'package:jci_app/core/app_theme.dart';

import '../../../../../changelanguages/presentation/bloc/locale_cubit.dart';

class EventTimelineCalendar extends StatelessWidget {
  const EventTimelineCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, calendarState) {
            // Convert activities to SfCalendar appointments
            final appointments = calendarState.activities.map((activity) {
              final start = activity.activityBasics.activityBeginDate;
              final end = start.add(const Duration(hours: 1)); // adjust duration
              return Appointment(
                startTime: start,
                endTime: end,
                subject: activity.activityBasics.name,
                color: ColorsApp.PrimaryColor.withOpacity(0.7),
                notes: activity.activityBasics.activityAdress,
              );
            }).toList();

            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: ColorsApp.PrimaryColor, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              height: MediaQuery.of(context).size.height / 2,
              child: SfCalendar(
                view: CalendarView.day,
                firstDayOfWeek: 1,
                timeSlotViewSettings: const TimeSlotViewSettings(
                  startHour: 8,
                  endHour: 23,
                  timeIntervalHeight: 60,
                ),

                dataSource: AppointmentDataSource(appointments),
                todayHighlightColor: ColorsApp.PrimaryColor,
              ),
            );
          },
        );

  }
}
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

