import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timeline_event.dart';
part 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  TimelineBloc() : super(TimelineInitial()) {
    on<TimelineEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<initTimeline>(_initTimeline);
    on<onStartDateChanged>(_onStartDateChanged);
    on<onEndDateDateChanged>(_onEndDateDateChanged);
  }

  void _onStartDateChanged(onStartDateChanged event, Emitter<TimelineState> emit)
  {
    Map<String, dynamic> clonedMap = Map<String, dynamic>.from(state.timeline);
    clonedMap['StartDate'] = event.startdate;
    int comparisonResult = event.startdate.compareTo(clonedMap['Deadline']);
    log(comparisonResult.toString() + " " + event.startdate.toString() + " " + clonedMap['Deadline'].toString());
    if(comparisonResult > 0)
    {
      clonedMap['Deadline'] = event.startdate.add(const Duration(days: 1));
    }

    emit(state.copyWith(timeline: clonedMap));
  }
  void _initTimeline(initTimeline event, Emitter<TimelineState> emit)
  {
    emit(state.copyWith(timeline: event.timelines));
  }
  void _onEndDateDateChanged(onEndDateDateChanged event, Emitter<TimelineState> emit)
  {
    Map<String, dynamic> clonedMap = Map<String, dynamic>.from(state.timeline);
    int comparisonResult = clonedMap['StartDate'].compareTo(event.enddate);
    if(comparisonResult > 0)
    {
      emit(state.copyWith(timeline: clonedMap));
    }
else
    {
      clonedMap['Deadline'] = event.enddate;
      emit(state.copyWith(timeline: clonedMap));
    }

  }
}
