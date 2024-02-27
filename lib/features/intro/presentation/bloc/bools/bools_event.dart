part of 'bools_bloc.dart';

// Events
abstract class BoolEvent {}

class SetBool1Event extends BoolEvent {
  final bool value;

  SetBool1Event(this.value);
}

class SetBool2Event extends BoolEvent {
  final bool value;

  SetBool2Event(this.value);
}

class SetBool3Event extends BoolEvent {
  final bool value;

  SetBool3Event(this.value);
}
class resetEvent extends BoolEvent {
  resetEvent();
}
