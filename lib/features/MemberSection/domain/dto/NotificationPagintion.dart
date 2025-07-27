import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/Notification.dart';

class NotificationPaginationRequest{
  final int limit;
  final bool isRefresed;
  final DocumentSnapshot? lastDocument;

  NotificationPaginationRequest({this.limit=6, required this.lastDocument,this.isRefresed=false});

}
class NotificationPaginationResponse{
  final List<NotificationUser> notifications;
  final DocumentSnapshot? lastDocument;

  NotificationPaginationResponse({required this.notifications, required this.lastDocument});

}