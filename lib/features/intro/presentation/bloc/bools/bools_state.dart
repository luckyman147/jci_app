part of 'bools_bloc.dart';

abstract class BoolState extends Equatable {
  final bool value;

  const BoolState(this.value);

  @override
  List<Object?> get props => [value];
}

class Bool1State extends BoolState {
  const Bool1State(bool value) : super(value);
}

class Bool2State extends BoolState {
  const Bool2State(bool value) : super(value);
}

class Bool3State extends BoolState {
  const Bool3State(bool value) : super(value);
}

