import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'num_pages_event.dart';
part 'num_pages_state.dart';

class NumPagesBloc extends Bloc<NumPagesEvent, NumPagesState> {
  NumPagesBloc() : super(NumPagesInitial()) {
     on<NumPagesChanged>(_onNumberOfPageChanged);
    on<NumberOfPageChanged>(_onCurrentPageChanged);
  }

void _onNumberOfPageChanged(
    NumPagesChanged event, Emitter<NumPagesState> emit) {
    emit(state.copyWith(numPages: event.numPages));
  }
  void _onCurrentPageChanged(
      NumberOfPageChanged event, Emitter<NumPagesState> emit) {
    emit(state.copyWith(CurrentPage: event.numPage));
  }
}
