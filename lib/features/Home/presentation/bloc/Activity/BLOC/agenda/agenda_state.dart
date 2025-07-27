part of 'agenda_cubit.dart';

 class AgendaState extends Equatable {
final List<Agenda> points;

  const AgendaState({this.points=const [],  });
AgendaState copyWith({List<Agenda>? agendas}){
  return AgendaState(points: agendas??points);

}

  @override
  // TODO: implement props
  List<Object?> get props => [points];
}

 class AgendaInitial extends AgendaState {
  @override
  List<Object> get props => [];
}
