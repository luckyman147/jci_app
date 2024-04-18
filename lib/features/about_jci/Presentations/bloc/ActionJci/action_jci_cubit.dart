import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'action_jci_state.dart';

class ActionJciCubit extends Cubit<ActionJciState> {
  ActionJciCubit() : super(ActionJciInitial());
  void changeAction(PresidentsAction action){
    emit(state.copyWith(action: action));
  }
  void changeYear(String year){
    emit(state.copyWith(year: year));
  }
  void changeCloneYear(String cloneYear){
    emit(state.copyWith(cloneYear: cloneYear));
  }
}
