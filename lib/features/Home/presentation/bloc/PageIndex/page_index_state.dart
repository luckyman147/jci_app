part of 'page_index_bloc.dart';

abstract class PageIndexState  extends Equatable{
  final int index;

   const PageIndexState(this.index);
}


class PageIndexInitial extends PageIndexState {

  PageIndexInitial(super.index);
  @override
  List<Object> get props => [index];
}
class IndexLoaded extends PageIndexState {


   IndexLoaded(super.index);

  @override
  List<Object> get props => [index];
}
class ResetState extends PageIndexState {

  ResetState(super.index);
  @override
  List<Object> get props => [index];
}
