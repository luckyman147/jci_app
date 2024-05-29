part of 'permissions_bloc.dart';
 enum PermStatus {
  NewMember,
   Other}
class PermissionsState extends Equatable {
  const PermissionsState({
    this.IsNewMember = false,

    this.status=PermStatus.NewMember,
  }
);
  final bool IsNewMember;
  final PermStatus status;
  PermissionsState copyWith({
    bool? IsNewMember,
    PermStatus? status,
  }) {
    return PermissionsState(
      status: status ?? this.status,
      IsNewMember: IsNewMember ?? this.IsNewMember,
    );
  }
  @override
  List<Object> get props => [IsNewMember,status];
}

class PermissionsInitial extends PermissionsState {
  @override
  List<Object> get props => [];
}
