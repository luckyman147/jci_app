part of 'num_pages_bloc.dart';

abstract class NumPagesEvent extends Equatable {
  const NumPagesEvent();
}
class NumberOfPageChanged extends NumPagesEvent {
  final int numPage;

  NumberOfPageChanged({required this.numPage});

  @override
  List<Object> get props => [numPage];
}
class NumPagesChanged extends NumPagesEvent {

  final List<int> numPages;

  NumPagesChanged({required this.numPages});
  @override
  List<Object> get props => [numPages];
}