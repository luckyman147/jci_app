part of 'permissions_bloc.dart';

// permission_state.dart
abstract class PermissionsState {}

class PermissionsLoadingState extends PermissionsState {}

class PermissionsLoadedState extends PermissionsState {
  final Map<String, Map<String, bool>> permissions;

  PermissionsLoadedState({required this.permissions});
}

class PermissionErrorState extends PermissionsState {
  final String errorMessage;

  PermissionErrorState({required this.errorMessage});
}

class PermissionCheckedState extends PermissionsState {
  final String featureId;
  final String permissionType;
  final bool hasPermission;

  PermissionCheckedState({
    required this.featureId,
    required this.permissionType,
    required this.hasPermission,
  });
}
