part of 'calendar_cubit.dart';

 class CalendarState extends Equatable {
  const CalendarState({this.selectedDate, this.activities = const []});
  final DateTime? selectedDate ;
  final List<Activity> activities ;
  //state copy with
  CalendarState copyWith({DateTime? selectedDate , List<Activity>? activities}) {
    return CalendarState(selectedDate: selectedDate ?? this.selectedDate,
      activities: activities ?? this.activities);
  }
  @override
  List<Object> get props => [selectedDate!,activities];
}

class CalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}
