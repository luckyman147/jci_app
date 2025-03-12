part of 'page_index_bloc.dart';


 abstract class PageIndexEvent extends Equatable {

}
class SetIndexEvent extends PageIndexEvent {
  final int index;

   SetIndexEvent({required this.index});

  @override
  List<Object> get props => [index];
}
class ChangeViewSectionEvent extends PageIndexEvent {
  final Viewsection viewsection;

  ChangeViewSectionEvent({required this.viewsection});

  @override
  List<Object> get props => [viewsection];
}
class SetParticipantIndexEvent extends PageIndexEvent {
  final int ParticipantIndex;

  SetParticipantIndexEvent({required this.ParticipantIndex});

  @override
  List<Object> get props => [ParticipantIndex];
}
class SetSectionEvent extends PageIndexEvent {
  final int section;

  SetSectionEvent({required this.section});

  @override
  List<Object> get props => [section];
}
class resetIndex extends PageIndexEvent {
  @override
  // TODO: implement props
  List<Object?> get props => []
  ;
}

