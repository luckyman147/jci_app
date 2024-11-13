

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/notesBloc/notes_bloc.dart';


part 'toggle_bool_event.dart';
part 'toggle_bool_state.dart';

class ToggleBooleanBloc extends Bloc<ToggleBooleanEvent, ToggleBooleanState> {
  ToggleBooleanBloc() : super(const ToggleBooleanState()) {
    on<ToggleBoolean>((event, emit) {
      emit(state.copyWith(value: !state.value));
    });
    on<ResetBoolean>(reset);
    on<ChangeIscompleted>(ChangeBoolean);
    on<ChangeIsEnabled>(ChangeisEnbled);
    on<ChangeIsImage1>(ChangeImage1);
  }
  void ChangeImage1(
      ChangeIsImage1 event,
      Emitter<ToggleBooleanState> emit,
      ) {
    emit(state.copyWith(IsImage1: !state.IsImage1));
  }
void ChangeisEnbled(
      ChangeIsEnabled event,
      Emitter<ToggleBooleanState> emit,
      ) {
    emit(state.copyWith(isEnabled: event.isEnabled));
  }
 void reset(
     ResetBoolean event , Emitter<ToggleBooleanState> emit,
     ) {
emit (state.copyWith(value: true));
  }
  void ChangeBoolean(
      ChangeIscompleted event,
      Emitter<ToggleBooleanState> emit,
      ) {
    emit(state.copyWith(isCompleted: event.isCompleted));
  }

}
