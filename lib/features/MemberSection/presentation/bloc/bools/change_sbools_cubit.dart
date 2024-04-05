import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_sbools_state.dart';

class ChangeSboolsCubit extends Cubit<ChangeSboolsState> {
  ChangeSboolsCubit() : super(ChangeSboolsInitial());
  void changeState(StatesBool value){
    emit(state.copyWith(state: value));
  }
  void changeSettings(SettingsBools value){
    emit(state.copyWith(settings: value));
  }
}
