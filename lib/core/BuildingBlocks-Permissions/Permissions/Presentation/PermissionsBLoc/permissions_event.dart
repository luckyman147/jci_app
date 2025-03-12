part of 'permissions_bloc.dart';

 abstract class PermissionsEvent extends Equatable {

}
class LoadPermissionOfMasterEvent extends PermissionsEvent{
  final List<String> featuresId;

  LoadPermissionOfMasterEvent({required this.featuresId});

  @override
  // TODO: implement props
  List<Object?> get props => [featuresId];

}