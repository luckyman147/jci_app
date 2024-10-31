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
  const initMemberEvent({required this.isUpdated,required this.cotisation,required this.points,required this.role,required this.objectifs});
  @override
  List<Object> get props => [isUpdated,cotisation,points,role,objectifs];}

class UpdateCotisation extends MemberManagementEvent{
final UpdateCotisationParams updateCotisationParams;
  const UpdateCotisation({ required this.updateCotisationParams});
  @override
  List<Object> get props => [updateCotisationParams];}

class UpdatePoints extends MemberManagementEvent{
final UpdatePointsParams updatePointsParams;
  const UpdatePoints({ required this.updatePointsParams});
  @override
  List<Object> get props => [updatePointsParams];}

class ChangeRoleEvent extends MemberManagementEvent {
  final ChangeRoleParams changeRoleParams;

  const ChangeRoleEvent(this.changeRoleParams);

  @override
  List<Object?> get props => [changeRoleParams];
}


class validateMember extends MemberManagementEvent{
final String memberid;
  const validateMember({ required this.memberid});
  @override
  List<Object> get props => [memberid];
}
class AddPoints extends MemberManagementEvent{

  const AddPoints();
  @override
  List<Object> get props => [];
}
class RemovePoints extends MemberManagementEvent{
  const RemovePoints();
  @override
  List<Object> get props => [];
}
class AddCotisation extends MemberManagementEvent{
  const AddCotisation();
  @override
  List<Object> get props => [];
}
class ChangeLanguageEvent extends MemberManagementEvent{
  final String language;
  const ChangeLanguageEvent({required this.language});
  @override
  List<Object> get props => [language];
}
class SendMembershipReportEvent extends MemberManagementEvent{
  final String id;
  const SendMembershipReportEvent({required this.id});
  @override
  List<Object> get props => [id];
}
class SendInactivityReportEvent extends MemberManagementEvent{
  final String id;
  const SendInactivityReportEvent({required this.id});
  @override
  List<Object> get props => [id];
}
class deleteMemberEvent extends MemberManagementEvent{
  final String id;
  const deleteMemberEvent({required this.id});
  @override
  List<Object> get props => [id];
}
