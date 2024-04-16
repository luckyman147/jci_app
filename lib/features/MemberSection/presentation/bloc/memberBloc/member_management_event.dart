part of 'member_management_bloc.dart';

abstract class MemberManagementEvent extends Equatable {
  const MemberManagementEvent();
}
class initMemberEvent extends MemberManagementEvent{
  final bool isUpdated;
  final List<bool> cotisation;
  final double points;
  final String role;
  final List<dynamic> objectifs;
  initMemberEvent({required this.isUpdated,required this.cotisation,required this.points,required this.role,required this.objectifs});
  @override
  List<Object> get props => [isUpdated,cotisation,points,role,objectifs];}

class UpdateCotisation extends MemberManagementEvent{
final UpdateCotisationParams updateCotisationParams;
  UpdateCotisation({ required this.updateCotisationParams});
  @override
  List<Object> get props => [updateCotisationParams];}

class UpdatePoints extends MemberManagementEvent{
final UpdatePointsParams updatePointsParams;
  UpdatePoints({ required this.updatePointsParams});
  @override
  List<Object> get props => [updatePointsParams];}

class ChangeRoleEvent extends MemberManagementEvent {
  final ChangeRoleParams changeRoleParams;

  ChangeRoleEvent(this.changeRoleParams);

  @override
  List<Object?> get props => [changeRoleParams];
}


class validateMember extends MemberManagementEvent{
final String memberid;
  validateMember({ required this.memberid});
  @override
  List<Object> get props => [memberid];
}
class AddPoints extends MemberManagementEvent{

  AddPoints();
  @override
  List<Object> get props => [];
}
class RemovePoints extends MemberManagementEvent{
  RemovePoints();
  @override
  List<Object> get props => [];
}
class AddCotisation extends MemberManagementEvent{
  AddCotisation();
  @override
  List<Object> get props => [];
}
