part of 'add_delete_update_bloc.dart';

abstract class AddDeleteUpdateState{}

class AddDeleteUpdateInitial extends AddDeleteUpdateState {
  @override
  List<Object> get props => [];
}

class LoadingAddDeleteUpdateState extends AddDeleteUpdateState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ErrorAddDeleteUpdateState extends AddDeleteUpdateState {
  final String message;

  ErrorAddDeleteUpdateState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddDeleteUpdateState extends AddDeleteUpdateState {
  final String message;

  MessageAddDeleteUpdateState({required this.message});

  @override
  List<Object> get props => [message];
}
