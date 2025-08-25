part of 'page_index_bloc.dart';
enum Viewsection{Initial,About ,Description,Agenda,Comment,Poll,PV}
 class PageIndexState  extends Equatable{
  final int index;
    final int section;
    final Viewsection viewsection;
    final int ParticipantIndex;

    //copy with
  PageIndexState copyWith({int? index,int? section,Viewsection? viewsection,int? ParticipantIndex}) {
    return PageIndexState(index:index??this.index,section: section??this.section,viewsection: viewsection??this.viewsection,ParticipantIndex: ParticipantIndex??this.ParticipantIndex);
  }


   const PageIndexState({this.section=0,this.index=4,this.viewsection=Viewsection.Initial,this.ParticipantIndex=0});
  @override
  List<Object> get props => [index,section,viewsection,ParticipantIndex];
}


class PageIndexInitial extends PageIndexState {

  PageIndexInitial();
  @override
  List<Object> get props => [];
}

