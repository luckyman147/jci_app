import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/Activitys/Activity.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitial());
  void selectDate(DateTime date) {

    emit(state.copyWith(selectedDate: date));
  }
  void selectActivity(List<Activity>  activity) {
    emit(state.copyWith(activities: activity));
  }
}
