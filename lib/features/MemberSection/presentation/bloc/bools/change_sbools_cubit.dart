import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_sbools_state.dart';

class ChangeSboolsCubit extends Cubit<ChangeSboolsState> {
  ChangeSboolsCubit() : super(ChangeSboolsInitial());
  void changeState(StatesBool value){
    emit(state.copyWith(state: value));
  }
  void changeObscur(bool value){
    emit(state.copyWith(isObscur: value));
  }
  void changeSettings(SettingsBools value){
    emit(state.copyWith(settings: value));
  }
  void ChangePages(String prepage,String nextpage){
    emit(state.copyWith(previosPages: [...state.previosPages,prepage],upcomingPages: [...state.upcomingPages,nextpage]));
  }
  void changeJciState(JciStates value){
    emit(state.copyWith(jciState: value));
  }

  void changeActive(bool value){
    emit(state.copyWith(IsActive: value));
  }

}
