part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();
}
class CheckPermissionsEvent extends PermissionsEvent {

  CheckPermissionsEvent(

      );
  @override
  List<Object> get props => [];
}
