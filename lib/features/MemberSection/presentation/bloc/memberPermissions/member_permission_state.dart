part of 'member_permission_bloc.dart';

 class MemberPermissionState extends Equatable {
  final bool isowner;
  final bool isadmin;
  final bool ismember;
  final bool isguest;
  final bool isSuperAdmin;
  final bool isLoading;


  const MemberPermissionState({
    this.isowner = false,
    this.isLoading=false,
    this.isadmin = false,
    this.ismember = false,
    this.isguest = false,
    this.isSuperAdmin = false,
  });
  MemberPermissionState copyWith({
    bool? isowner,
    bool? isadmin,
    bool?isLoading,
    bool? ismember,
    bool? isguest,
    bool? isSuperAdmin,
  }) {
    return MemberPermissionState(
      isLoading: isLoading??this.isLoading,
      isowner: isowner ?? this.isowner,
      isadmin: isadmin ?? this.isadmin,
      ismember: ismember ?? this.ismember,
      isguest: isguest ?? this.isguest,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isowner,isadmin,
    isLoading,
    ismember,isguest,isSuperAdmin];

}

class MemberPermissionInitial extends MemberPermissionState {
  @override
  List<Object> get props => [];
}
