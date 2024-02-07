

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'toggle_bool_event.dart';
part 'toggle_bool_state.dart';

class ToggleBooleanBloc extends Bloc<ToggleBooleanEvent, ToggleBooleanState> {
  ToggleBooleanBloc({bool initialValue = true}) : super(ToggleBooleanState(value: initialValue)) {
    on<ToggleBoolean>((event, emit) {
      emit(state.copyWith(value: !state.value));
    });
  }
}
