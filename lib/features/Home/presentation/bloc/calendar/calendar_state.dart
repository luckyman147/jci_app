part of 'calendar_cubit.dart';

 class CalendarState extends Equatable {
  const CalendarState({this.selectedDate});
  final DateTime? selectedDate ;
  //state copy with
  CalendarState copyWith({DateTime? selectedDate}) {
    return CalendarState(selectedDate: selectedDate ?? this.selectedDate);
  }
  @override
  List<Object> get props => [selectedDate!];
}

class CalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}
