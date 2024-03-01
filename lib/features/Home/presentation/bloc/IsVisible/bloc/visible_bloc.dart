import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'visible_event.dart';
part 'visible_state.dart';

class VisibleBloc extends Bloc<VisibleEvent, VisibleState> {
  VisibleBloc() : super(VisibleInitial(false,false )) {
    on<VisibleEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<VisibleIsPaidToggleEvent>(_toggleIsPaid);
    on<VisibleEndDateToggleEvent>(_toggleEndDate);
    on<ResetEvent>(_reset);
  }
  void _toggleEndDate(
    VisibleEndDateToggleEvent event,
    Emitter<VisibleState> emit,
  ) {
    emit(state.copyWith(
      isVisible: event.isvisible
    ));
  }

  void _reset(
    ResetEvent event,
    Emitter<VisibleState> emit,
  ) {
    emit(VisibleInitial(false, false));
  }

  void _toggleIsPaid(
    VisibleIsPaidToggleEvent event,
    Emitter<VisibleState> emit,
  ) {
    emit(state.copyWith(isPaid: event.ispaid));
  }
}
