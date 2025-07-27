part of 'index_bloc.dart';

abstract class IndexEvent extends Equatable {


  const IndexEvent();
}
class SetIndexEvent extends IndexEvent {
  final int index;

  const SetIndexEvent({required this.index});

  @override
  List<Object> get props => [index];
}class resetIndex extends IndexEvent {
  @override
  // TODO: implement props
  List<Object?> get props => []
;
}