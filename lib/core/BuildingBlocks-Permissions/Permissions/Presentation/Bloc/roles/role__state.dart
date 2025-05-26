part of 'role__bloc.dart';
enum RoleApiStatus{Initial,

  Loading,Created,Error,Updated,Changed,Loaded,LoadedRole}

class RoleState extends Equatable {
  const RoleState({
    this.role,
    this.message,
    this.roles = const [],
    this.status = RoleApiStatus.Initial,
  });
  final String? message;

  final List<Role> roles;
  final RoleApiStatus status;
final Role? role;
  RoleState copyWith({
    List<Role>? roles,
    RoleApiStatus? status,
    Role?role,String? message

  }) {
    return RoleState(
      message: message??this.message,
      role: role??this.role,
      roles: roles ?? this.roles,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [roles,message, status,role];
}


final class RoleInitial extends RoleState {
  @override
  List<Object> get props => [];
}

extension RoleApiStatusExtension on RoleApiStatus {
  Widget when({

    required Widget Function() loading,
    required Widget Function() loaded,
    required Widget Function() error,
  }) {
    switch (this) {
      case RoleApiStatus.Initial:
      case RoleApiStatus.Loading:
        return loading();
        case RoleApiStatus.Created:
      case RoleApiStatus.Updated:
      case RoleApiStatus.Changed:
      case RoleApiStatus.Loaded:
      case RoleApiStatus.LoadedRole:
        return loaded();
      case RoleApiStatus.Error:
        return error();

        // TODO: Handle this case.
    }
  }
}
