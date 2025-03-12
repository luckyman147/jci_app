import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'visible_event.dart';
part 'visible_state.dart';

class VisibleBloc extends Bloc<VisibleEvent, VisibleState> {
  VisibleBloc() : super(VisibleInitial( )) {
    on<VisibleEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<VisibleIsPaidToggleEvent>(_toggleIsPaid);
    on<VisibleEndDateToggleEvent>(_toggleEndDate);
    on<ResetEvent>(_reset);
    on<ChangePrivacy>(_ChangePrivacy);
    on<ChangeOnline>(_changeOnline);
  }
  void _toggleEndDate(
    VisibleEndDateToggleEvent event,
    Emitter<VisibleState> emit,
  ) {
    emit(state.copyWith(
      isVisible: event.isvisible
    ));
  }
  void _ChangePrivacy(
      ChangePrivacy event, Emitter<VisibleState> emit) {
    emit(state.copyWith(
      isPrivate: event.isPrivate,
    ));
  }
  void _changeOnline(
      ChangeOnline event, Emitter<VisibleState> emit) {
    emit(state.copyWith(
      IsOnline   : event.IsOnline,
    ));
  }
  void _reset(
    ResetEvent event,
    Emitter<VisibleState> emit,
  ) {
    emit(state.copyWith(
      isPrivate: false,isPaid: false,
      isVisible: false,IsOnline: false
    ));
  }

  void _toggleIsPaid(
    VisibleIsPaidToggleEvent event,
    Emitter<VisibleState> emit,
  ) {
    emit(state.copyWith(isPaid: event.ispaid));
  }
}
