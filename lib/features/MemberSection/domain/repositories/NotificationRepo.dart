import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/MemberSection/domain/dto/NotificationPagintion.dart';

import '../entity/Notification.dart';

abstract class NotificationsRepo{
  // Get all notifications for a user
  Future<Either<Failure,NotificationPaginationResponse>> getNotificationsByPagination(
      NotificationPaginationRequest request
      );

  // Create a new notification
 Future< Either<Failure,  Unit>> createNotification( NotificationUser notification);

  // Delete a notification by its ID
  Future<Either<Failure,Unit>> deleteNotification( String notificationId);

  // Mark a notification as seen by its ID
  Future<Either<Failure,Unit>> updateSeenToTrue( String notificationId);
}