part of 'permissions_bloc.dart';

enum TypePermissionsStatus { Initial, Loading, Loaded, Error, LoadedFeature,  }


class PermissionsState extends Equatable {
  final List<FeaturePermissions> permissions;
  final String errorMessage;
  final bool isLoading;
  final TypePermissionsStatus type;


  const PermissionsState({
    this.type = TypePermissionsStatus.Initial,
    this.permissions = const [],
    this.errorMessage = '',
    this.isLoading = false,

  });


  // CopyWith Method
  PermissionsState copyWith({
    List<FeaturePermissions>? permissions,
    String? errorMessage,
    bool? isLoading,
    List<Feature>? features,
    TypePermissionsStatus? type,
  }) {
    return PermissionsState(

      permissions: permissions ?? this.permissions,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [permissions, errorMessage, isLoading, type];
}


class PermissionsLoadingState extends PermissionsState {}

class PermissionsLoadedState extends PermissionsState {
  final List<FeaturePermissions> permissions;

  PermissionsLoadedState({required this.permissions});
}




