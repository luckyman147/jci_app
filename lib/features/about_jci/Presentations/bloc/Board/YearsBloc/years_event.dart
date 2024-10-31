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
  const ChangeRoleEvent({required this.role});

  @override
  // TODO: implement props
  List<Object?> get props => [role];





}

class AddRoleEvent extends YearsEvent {
  final BoardRole role;

  const AddRoleEvent({required this.role});

  @override


  List<Object?> get props => [role];}
class GetBoardRolesEvent extends YearsEvent {
  final int priority;

  const GetBoardRolesEvent({required this.priority});

  @override
  List<Object?> get props => [priority];
}
class ChangeCloneYear extends YearsEvent {
  final String year;
  const ChangeCloneYear({required this.year});

  @override

  List<Object?> get props => [year];
}
class ChangeBoardYears extends YearsEvent {
  final String year;
  const ChangeBoardYears({required this.year});

  @override
  // TODO: implement props
  List<Object?> get props => [year];
}

class AddYear extends YearsEvent {
  final String year;
  const AddYear({required this.year});

  @override
  // TODO: implement props
  List<Object?> get props => [year];
}
class RemoveYear extends YearsEvent {
  final String year;
  const RemoveYear({required this.year});

  @override

  List<Object?> get props => [year];}

class AddPosition extends YearsEvent {
  final PostField postField;

  const AddPosition({required this.postField});

  @override
  // TODO: implement props
  List<Object?> get props => [postField];


}
class RemovePosition extends YearsEvent {
  final PostField post;

  const RemovePosition({required this.post});

  @override
  // TODO: implement props
  List<Object?> get props => [post];
}


class AddNewRole extends YearsEvent {
  final BoardRole role;
  const AddNewRole({required this.role});

  @override

  List<Object?> get props => [role];}
class RemoveRole extends YearsEvent {
  final String  roleid;
  const RemoveRole({required this.roleid});

  @override
  List<Object?> get props => [roleid];



}






