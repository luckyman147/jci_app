part of 'role__bloc.dart';

sealed class RoleEvent extends Equatable {
  const RoleEvent();
}
class CreateRoleEvent extends RoleEvent{
  final Role role;

  CreateRoleEvent({required this.role});

  @override
  // TODO: implement props
  List<Object?> get props =>[role];
}
class UpdateRoleInfosEvent extends RoleEvent{
  final Role role;

  UpdateRoleInfosEvent({required this.role});

  @override
  // TODO: implement props
  List<Object?> get props =>[role];
}class UpdateRolePermissionsEvent extends RoleEvent{
  final RolePermissionsDto rolePermissionsDto;

  UpdateRolePermissionsEvent({required this.rolePermissionsDto});

  @override
  // TODO: implement props
  List<Object?> get props =>[rolePermissionsDto];
}

class ChangeRoleOfUserEvent extends RoleEvent{
  final ChangeRoleParams changeRoleParams;

  ChangeRoleOfUserEvent({required this.changeRoleParams});

  @override
  // TODO: implement props
  List<Object?> get props =>[changeRoleParams];
}
class FetchRolesEvent extends RoleEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];



}
class FetchRoleByNameEvent extends RoleEvent{
  final String roleId;

  FetchRoleByNameEvent({required this.roleId});
  @override
  // TODO: implement props
  List<Object?> get props => [roleId];



}