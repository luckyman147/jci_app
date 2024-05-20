import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/app_theme.dart';
import '../../../changelanguages/presentation/bloc/locale_cubit.dart';
import '../../domain/entities/Activity.dart';
import '../bloc/calendar/calendar_cubit.dart';
import 'Compoenents.dart';

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
    _selectedEvents = ValueNotifier(_getEventsForDay(DateTime.now()));

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
                SizedBox(height: 20,),
                EvnetBuilder(state)],

            ),
          );
        },

    );

  }

  Widget EvnetBuilder(LocaleState ste) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width,
                child: ValueListenableBuilder(valueListenable: _selectedEvents, builder: (context, value, child) {
                  return BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, state) {
    return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: paddingSemetricHorizontal(),
                        child: Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: textColorBlack),
                     gradient: LinearGradient(
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                     colors: [PrimaryColor, textColorWhite]),
                     boxShadow: [
                       BoxShadow(
                         color: textColorBlack.withOpacity(0.5),
                         spreadRadius: 5,
                         blurRadius: 7,
                         offset: Offset(0, 3), // changes position of shadow
                       ),
                     ],

                     ),
                          child: listTileCalendar(context, value, index, state,ste),
                        ),
                      );
                    },
                  );
  },
);
                }


                ),
              );
  }

  ListTile listTileCalendar(BuildContext context, List<Activity> value, int index, ActivityState state,LocaleState lste) {
    String formattedDate = DateFormat('dd MMM yyyy', lste.locale == Locale("en") ? "en_US" : "fr_FR").format(value[index].ActivityBeginDate);
    String formattedTime = DateFormat('HH:mm').format(value[index].ActivityBeginDate);
    String formattedDateTime = lste.locale == Locale("en") ? "$formattedDate At $formattedTime" : "$formattedDate A $formattedTime";

    return ListTile(
                          onTap: (){
                            context.go(
                                '/activity/${ value[index].id}/${state
                                    .selectedActivity.name}/$index');
                          },

                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: textColorBlack)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: PrimaryColor,),
                          title: SizedBox(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(value[index].name,  overflow: TextOverflow.ellipsis,   style: PoppinsSemiBold(16, textColorWhite,TextDecoration.none),),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: paddingSemetricHorizontal(),
                                      child: Icon(Icons.location_on,color: textColorWhite,),
                                    ),

                                    Text(value[index].ActivityAdress,overflow: TextOverflow.ellipsis,style: PoppinsRegular(16, textColorWhite,),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: paddingSemetricVertical(),
                            child: Row(
                              children: [
                                Padding(
                                  padding: paddingSemetricHorizontal(),
                                  child: Icon(Icons.calendar_today_rounded,color: textColorWhite,),
                                ),
                                    Text(formattedDateTime,style: PoppinsRegular(14, textColorWhite),),
                              ],
                            ),
                          ),
                        );
  }

  BlocBuilder<CalendarCubit, CalendarState> calendar(LocaleState state) {
    return BlocBuilder<CalendarCubit, CalendarState>(
                builder: (context, se) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      surfaceTintColor:backgroundColored,
                      elevation: 9,
                      child: TableCalendar(

                        calendarStyle: CalendarStyle(
                       markersAutoAligned: true,

                          markerDecoration: BoxDecoration(
                            color: PrimaryColor,
                            border: Border.all(color: PrimaryColor),
                          ),
                    weekNumberTextStyle: PoppinsRegular(16, textColorWhite),

                          todayTextStyle: PoppinsRegular(16, textColorBlack),
                          selectedTextStyle: PoppinsRegular(16, textColorBlack),
                      markersAlignment: Alignment.topCenter,
                          selectedDecoration: BoxDecoration(

                              border: Border(

                                top: BorderSide(color: SecondaryColor,width: 2),
                              )
                          ),
                          todayDecoration: BoxDecoration(

                           border: Border(

                             top: BorderSide(color: PrimaryColor,width: 2),
                           )
                          ),
                          defaultTextStyle: PoppinsRegular(16, textColorBlack),
                          outsideTextStyle: PoppinsRegular(16, textColorBlack),
                          outsideDecoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),

                          outsideDaysVisible: true,
                         ),
                        eventLoader: (day) => _getEventsForDay(day),
                        locale: state.locale==Locale("en")?"en_Us":"fr_FR",
                        rowHeight: 40,
                        headerStyle: HeaderStyle(
                          titleTextStyle: PoppinsSemiBold(20, textColorBlack, TextDecoration.none),
                          formatButtonVisible: false,
                          leftChevronIcon: Icon(Icons.arrow_back_ios_rounded,color: textColorBlack,),
                          rightChevronIcon: Icon(Icons.arrow_forward_ios_rounded,color: textColorBlack,),
                          titleCentered: true,
                          headerPadding: EdgeInsets.all(0),
                          headerMargin: EdgeInsets.all(0),


                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {

                            context.read<CalendarCubit>().selectDate(selectedDay);
                      _selectedEvents.value = _getEventsForDay(selectedDay);
                            log('${se.selectedDate}');
                          });



                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(se.selectedDate, day);
                        }
                        ,
                        availableGestures: AvailableGestures.all,
                        focusedDay: se.selectedDate!, firstDay: DateTime(2024,1,1), lastDay: DateTime.now().add(Duration(days: 356)),),
                    ),
                  );
                },
              );
  }

  List<Activity> _getEventsForDay(DateTime dateTime) {
    return widget.activities.where((element) => isSameDay(element.ActivityBeginDate, dateTime)).toList();
  }
}
