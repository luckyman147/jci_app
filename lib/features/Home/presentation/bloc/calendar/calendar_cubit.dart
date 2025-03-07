import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitial());
  void selectDate(DateTime date) {

    emit(state.copyWith(selectedDate: date));
  }
}
