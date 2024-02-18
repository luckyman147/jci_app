part of 'toggle_bool_bloc.dart';

class ToggleBooleanState {
  final bool value;

  ToggleBooleanState({required this.value});

  ToggleBooleanState copyWith({bool? value}) => ToggleBooleanState(value: value ?? this.value);
}

// reset state
class ResetBooleanState extends ToggleBooleanState {
  ResetBooleanState() : super(value: true);
}