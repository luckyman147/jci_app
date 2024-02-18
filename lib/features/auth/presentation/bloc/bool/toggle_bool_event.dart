part of 'toggle_bool_bloc.dart';

sealed class ToggleBooleanEvent extends Equatable {
  const ToggleBooleanEvent();

  @override
  List<Object> get props => [];
}

class ToggleBoolean extends ToggleBooleanEvent {}
class ResetBoolean extends ToggleBooleanEvent {}