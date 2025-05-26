part of 'role_management__cubit.dart';

 class RoleManagementState extends Equatable {
  const RoleManagementState({
    this.rolesCategory
 });
  final CibleType? rolesCategory;


  @override
  // TODO: implement props
  List<Object?> get props => [rolesCategory];
}

final class RoleManagementInitial extends RoleManagementState {
  @override
  List<Object> get props => [];
}
