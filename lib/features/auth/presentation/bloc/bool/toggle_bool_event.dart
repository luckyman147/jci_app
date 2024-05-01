part of 'toggle_bool_bloc.dart';

sealed class ToggleBooleanEvent extends Equatable {
  const ToggleBooleanEvent();

  @override
  List<Object> get props => [];
}

class ToggleBoolean extends ToggleBooleanEvent {}
class ResetBoolean extends ToggleBooleanEvent {}
class ChangeIscompleted extends ToggleBooleanEvent {
  final bool isCompleted;
  ChangeIscompleted({required this.isCompleted});
}
class ChangeIsEnabled extends ToggleBooleanEvent {
  final bool isEnabled;
  ChangeIsEnabled({required this.isEnabled});
}