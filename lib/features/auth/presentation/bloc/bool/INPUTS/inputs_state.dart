part of 'inputs_cubit.dart';
enum Inputs{
  Google,Email

}
 class InputsState extends Equatable {     final Inputs inputsValue;

  InputsState({ this.inputsValue=Inputs.Google});
InputsState copyWith({
  Inputs? inputsValue,
}) {
  return InputsState(
    inputsValue: inputsValue ?? this.inputsValue,
  );
}

  @override
  // TODO: implement props
  List<Object?> get props => [inputsValue];

}

final class InputsInitial extends InputsState {


  @override
  List<Object> get props => [];
}
