part of 'toggle_bool_bloc.dart';

class ToggleBooleanState extends Equatable {
  final bool value;
  final bool isCompleted;
  final bool isEnbled;

  ToggleBooleanState({ this.value=true, this.isCompleted = false,this.isEnbled=true});

  ToggleBooleanState copyWith({bool? value,bool?isCompleted,bool? isEnabled}) => ToggleBooleanState(value: value ?? this.value, isCompleted: isCompleted ?? this.isCompleted,isEnbled: isEnabled??this.isEnbled);

  @override
  // TODO: implement props
  List<Object?> get props => [value,isCompleted,isEnbled];
}

// reset state
class ResetBooleanState extends ToggleBooleanState {


  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}