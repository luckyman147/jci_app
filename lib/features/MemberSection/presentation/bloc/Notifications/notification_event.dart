part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
}
class UpdateNotificationSeenEvent extends NotificationEvent {
  final String notificationUser;

  UpdateNotificationSeenEvent({required this.notificationUser});

  @override
  // TODO: implement props
  List<Object?> get props => [notificationUser];

}

class DeleteNotificationEvent extends NotificationEvent{
  final String notificationUser;

  DeleteNotificationEvent({required this.notificationUser});
  @override
  // TODO: implement props
  List<Object?> get props => [notificationUser];
}
class CreateNotificationEvent  extends NotificationEvent {
  final NotificationUser notificationUser;

  CreateNotificationEvent({required this.notificationUser});

  @override
  // TODO: implement props
  List<Object?> get props => [notificationUser];
}
class LoadNotificationsEvent extends NotificationEvent {
  final DocumentSnapshot? lastDocument;
  final bool isRefreshed;

  LoadNotificationsEvent({required this.lastDocument, required this.isRefreshed});
  @override
  // TODO: implement props
  List<Object?> get props => [isRefreshed,lastDocument];
}
class LoadMoreNotificationsEvent extends NotificationEvent {
  final DocumentSnapshot? lastDocument;

  LoadMoreNotificationsEvent({ required this.lastDocument});

  @override
  List<Object> get props => [];
}