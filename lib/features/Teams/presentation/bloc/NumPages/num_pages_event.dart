part of 'num_pages_bloc.dart';

abstract class NumPagesEvent extends Equatable {
  const NumPagesEvent();
}
class NumberOfPageChanged extends NumPagesEvent {
  final int numPage;

  const NumberOfPageChanged({required this.numPage});

  @override
  List<Object> get props => [numPage];
}
class NumPagesChanged extends NumPagesEvent {

  final List<int> numPages;

  const NumPagesChanged({required this.numPages});
  @override
  List<Object> get props => [numPages];
}