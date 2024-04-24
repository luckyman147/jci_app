part of 'boord_bloc.dart';

abstract class BoordEvent extends Equatable {
  const BoordEvent();
}
class FetchBoardYearsEvent extends BoordEvent {
 final  String year;
  FetchBoardYearsEvent({required this.year});
  @override
  List<Object> get props => [year];
}
class AddBoardEvent extends BoordEvent {
  final String year;
  AddBoardEvent({required this.year});
  @override
  List<Object> get props => [year];
}
class RemoveBoardEvent extends BoordEvent {
  final String year;
  RemoveBoardEvent({required this.year});
  @override
  List<Object> get props => [year];
}
class AddMemberEvent extends BoordEvent {
  final PostField postField;
  AddMemberEvent({required this.postField});
  @override
  List<Object> get props => [postField];

}class RemoveMemberEvent extends BoordEvent {
  final PostField postField;
  RemoveMemberEvent({required this.postField});
  @override
  List<Object> get props => [postField];

}