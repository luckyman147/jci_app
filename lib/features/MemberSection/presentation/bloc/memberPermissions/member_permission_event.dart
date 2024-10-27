part of 'member_permission_bloc.dart';

abstract class MemberPermissionEvent extends Equatable {
  const MemberPermissionEvent();
}
class CheckPermissions extends MemberPermissionEvent{

  CheckPermissions();
  @override
  List<Object> get props => [];

}
class checkIsowner extends MemberPermissionEvent{
  final String memberID;
  checkIsowner(this.memberID);
  @override
  List<Object> get props => [memberID];
}
class checkIsSuper extends MemberPermissionEvent{

  checkIsSuper();
  @override
  List<Object> get props => [];
}
class checkIsAdmin extends MemberPermissionEvent{

  checkIsAdmin();
  @override
  List<Object> get props => [];
}
class CheckIsSuperAdminNoOwner{
  final String memberID;
  CheckIsSuperAdminNoOwner(this.memberID);
  @override
  List<Object> get props => [memberID];
}