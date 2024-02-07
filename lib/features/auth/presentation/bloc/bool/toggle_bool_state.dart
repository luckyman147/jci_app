part of 'toggle_bool_bloc.dart';

class ToggleBooleanState {
  final bool value;

  ToggleBooleanState({required this.value});

  ToggleBooleanState copyWith({bool? value}) => ToggleBooleanState(value: value ?? this.value);
}