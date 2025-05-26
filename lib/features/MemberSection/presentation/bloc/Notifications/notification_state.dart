part of 'notification_bloc.dart';
enum NotificationsStatus{Loading,Initial,
  Error,Empty,
  Loaded,Created,Updated,Deleted}
 class NotificationState extends Equatable {
  final List<NotificationUser>  notifications;
final NotificationsStatus status;
  final bool hasReachedMax;
  final DocumentSnapshot? lastDocument;
  const NotificationState(  {
    this.status=NotificationsStatus.Initial,
    this.hasReachedMax=false,
    this.lastDocument,
    this.notifications=const []});
  NotificationState copyWith({

List<NotificationUser>? notifications,
    NotificationsStatus?status,

    bool? hasReachedMax,

    DocumentSnapshot? lastDocument

  }){
    return NotificationState(

    notifications: notifications??this.notifications,
      lastDocument: lastDocument??this.lastDocument,

      status: status??this.status,
      hasReachedMax: hasReachedMax??this.hasReachedMax,
    );
  }



  @override
  // TODO: implement props
  List<Object?> get props => [lastDocument,notifications,status,hasReachedMax];
}

final class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}
extension NotificationsStatusExtension on NotificationsStatus {
  Widget when({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function() loaded,
    required Widget Function() error,
    required Widget Function() empty,

  }) {
    switch (this) {
      case NotificationsStatus.Initial:
        return initial();
      case NotificationsStatus.Loading:
        return loading();


      case NotificationsStatus.Error:
        return error();
      case NotificationsStatus.Empty:
        return empty();
        case NotificationsStatus.Loaded:
      case NotificationsStatus.Created:

      case NotificationsStatus.Updated:

      case NotificationsStatus.Deleted:
        return loaded();

    }
  }
}