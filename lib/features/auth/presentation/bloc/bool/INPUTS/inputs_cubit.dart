import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'inputs_state.dart';

class InputsCubit extends Cubit<InputsState> {
  InputsCubit() : super(InputsInitial());
  void ActivateEmail(){
    emit(state.copyWith(
  inputsValue:
        Inputs.Email

    ));
  }


  void resetInputs(){
    emit(state.copyWith(
      inputsValue: Inputs.Google
    ));
  }



}
