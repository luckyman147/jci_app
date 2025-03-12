part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();
}
class CheckPermissionsEvent extends PermissionsEvent {

  const CheckPermissionsEvent(

      );
  @override
  List<Object> get props => [];
}
