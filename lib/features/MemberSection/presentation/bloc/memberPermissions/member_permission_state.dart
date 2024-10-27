part of 'member_permission_bloc.dart';

 class MemberPermissionState extends Equatable {
  final bool isowner;
  final bool isadmin;
  final bool ismember;
  final bool isguest;
  final bool isSuperAdmin;


  const MemberPermissionState({
    this.isowner = false,
    this.isadmin = false,
    this.ismember = false,
    this.isguest = false,
    this.isSuperAdmin = false,
  });
  MemberPermissionState copyWith({
    bool? isowner,
    bool? isadmin,
    bool? ismember,
    bool? isguest,
    bool? isSuperAdmin,
  }) {
    return MemberPermissionState(
      isowner: isowner ?? this.isowner,
      isadmin: isadmin ?? this.isadmin,
      ismember: ismember ?? this.ismember,
      isguest: isguest ?? this.isguest,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isowner,isadmin,ismember,isguest,isSuperAdmin];

}

class MemberPermissionInitial extends MemberPermissionState {
  @override
  List<Object> get props => [];
}
