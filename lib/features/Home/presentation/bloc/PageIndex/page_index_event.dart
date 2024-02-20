part of 'page_index_bloc.dart';


 abstract class PageIndexEvent extends Equatable {

}
class SetIndexEvent extends PageIndexEvent {
  final int index;

   SetIndexEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class resetIndex extends PageIndexEvent {
  @override
  // TODO: implement props
  List<Object?> get props => []
  ;
}
