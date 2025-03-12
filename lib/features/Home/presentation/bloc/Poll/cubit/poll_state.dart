part of 'poll_cubit.dart';

 class PollCubitState extends Equatable {
  final Map<int, bool> expanded;

   PollCubitState({this.expanded = const {}});
  //copywith
  PollCubitState copyWith({Map<int, bool>? expanded}) {
    return PollCubitState(expanded: expanded ?? this.expanded);
  }

  @override
  List<Object> get props => [expanded];
}

final class PollInitial extends PollCubitState {
  @override
  List<Object> get props => [];
}
