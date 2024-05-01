part of 'years_bloc.dart';

abstract class YearsEvent extends Equatable {
  const YearsEvent();
}
class GerBoardYearsEvent extends YearsEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];



}
class ChangeRoleEvent  extends YearsEvent{
  final BoardRole? role;
  ChangeRoleEvent({required this.role});

  @override
  // TODO: implement props
  List<Object?> get props => [role];





}

class AddRoleEvent extends YearsEvent {
  final BoardRole role;

  AddRoleEvent({required this.role});

  @override


  List<Object?> get props => [role];}
class GetBoardRolesEvent extends YearsEvent {
  final int priority;

  GetBoardRolesEvent({required this.priority});

  @override
  List<Object?> get props => [priority];
}
class ChangeCloneYear extends YearsEvent {
  final String year;
  ChangeCloneYear({required this.year});

  @override

  List<Object?> get props => [year];
}
class ChangeBoardYears extends YearsEvent {
  final String year;
  ChangeBoardYears({required this.year});

  @override
  // TODO: implement props
  List<Object?> get props => [year];
}

class AddYear extends YearsEvent {
  final String year;
  AddYear({required this.year});

  @override
  // TODO: implement props
  List<Object?> get props => [year];
}
class RemoveYear extends YearsEvent {
  final String year;
  RemoveYear({required this.year});

  @override

  List<Object?> get props => [year];}

class AddPosition extends YearsEvent {
  final PostField postField;

  AddPosition({required this.postField});

  @override
  // TODO: implement props
  List<Object?> get props => [postField];


}
class RemovePosition extends YearsEvent {
  final PostField post;

  RemovePosition({required this.post});

  @override
  // TODO: implement props
  List<Object?> get props => [post];
}


class AddNewRole extends YearsEvent {
  final BoardRole role;
  AddNewRole({required this.role});

  @override

  List<Object?> get props => [role];}
class RemoveRole extends YearsEvent {
  final String  roleid;
  RemoveRole({required this.roleid});

  @override
  List<Object?> get props => [roleid];



}






