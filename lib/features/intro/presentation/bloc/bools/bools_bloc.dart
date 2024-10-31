

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'bools_event.dart';
part 'bools_state.dart';

class BoolBloc extends Bloc<BoolEvent, BoolState> {
  BoolBloc() : super(const Bool1State(true)) {
    on<SetBool1Event>(_onBool1);
    on<SetBool2Event>(_onBool2);
    on<SetBool3Event>(_onBool3);
    on<resetEvent>((event, emit) => _reset());

  }

  void _reset() {
    add( SetBool1Event(true));
    add( SetBool2Event(false));
    add( SetBool3Event(false));
  }
  void _onBool1(
    SetBool1Event event,
    Emitter<BoolState> emit,
      ){
    emit(Bool1State(event.value));
    if(event.value){
      emit(const Bool2State(false));
      emit(const Bool3State(false));
    }
  }
  void _onBool2(
    SetBool2Event event,
    Emitter<BoolState> emit,
      ){
    emit(Bool2State(event.value));
    if(event.value){
      emit(const Bool1State(false));
      emit(const Bool3State(false));
    }
  }
  void _onBool3(
    SetBool3Event event,
    Emitter<BoolState> emit,
      ){
    emit(Bool3State(event.value));
    if(event.value){
      emit(const Bool1State(false));
      emit(const Bool2State(false));
    }
  }
}
