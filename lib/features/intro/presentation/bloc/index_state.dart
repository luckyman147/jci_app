part of 'index_bloc.dart';

abstract class IndexState extends Equatable {
  const IndexState();
}

class IndexInitial extends IndexState {
  final int index;
  IndexInitial(this.index);
  @override
  List<Object> get props => [index];
}
class IndexLoaded extends IndexState {
  final int currentIndex;

  const IndexLoaded(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}
class ResetState extends IndexState {
  final int index;
  ResetState(this.index);
  @override
  List<Object> get props => [index];
}
class IndexError extends IndexState {
  final String error;
  IndexError(this.error);
  @override
  List<Object> get props => [error];
}