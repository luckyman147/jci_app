import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/MemberSection/data/Services/NotificationLogicService.dart';
import 'package:jci_app/features/MemberSection/data/model/NotificationUserModel.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../core/config/services/store.dart';
import '../../domain/dto/NotificationPagintion.dart';
import '../../domain/entity/Notification.dart';

abstract class NotificationRemoteDataSources{

  Future< Unit> createNotification(NotificationUserModel notification);
  Future<Unit> deleteNotification(String notificationId);
  Future< NotificationPaginationResponse> getNotificationsByPagination(NotificationPaginationRequest request);
  Future< Unit> updateSeenToTrue(String notificationId) ;
}



class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSources{
  final FirebaseFirestore firestore ;
  final Store store;
  final NotificationLogicService notificationLogicService;

  NotificationRemoteDataSourceImpl(this.store, {
    required this.notificationLogicService,
    required this.firestore});

  @override
  Future<Unit> createNotification(NotificationUserModel notification,)async {
    try {
      // Check the notification type and call the appropriate function
      if (notification.type == NotificationType.Warning) {
        await notificationLogicService. createWarningNotification(notification, firestore,notification.toMemberId);
      } else {
        await notificationLogicService. createReminderNotification(notification, firestore);
      }


      return unit; // Return Unit to indicate success
    } on FirebaseException catch (e) {
      throw Exception("Failed to create notification: ${e.message}");
    } on Exception catch (e) {
      throw ServerException();
    }
  }


  @override
  Future<Unit> deleteNotification(String notificationId) async {
    try {
      final userId = await store.getUserId();
      final userRef = firestore.collection("users").doc(userId);
      final notificationRef = userRef.collection("notifications").doc(notificationId);

      await firestore.runTransaction((transaction) async {
        // Get current counts
        final userDoc = await transaction.get(userRef);
        final currentUnread = (userDoc.data()?['unreadNotificationCount'] as int?) ?? 0;
        final currentTotal = (userDoc.data()?['notificationCount'] as int?) ?? 0;

        // Delete the notification
        transaction.delete(notificationRef);

        // Only decrement if > 0
        if (currentUnread > 0) {
          transaction.update(userRef, {
            'unreadNotificationCount': FieldValue.increment(-1),
          });
        }

        if (currentTotal > 0) {
          transaction.update(userRef, {
            'notificationCount': FieldValue.increment(-1),
          });
        }
      });

      return unit;
    } on FirebaseException catch (e) {
      throw Exception("Failed to delete notification: ${e.message}");
    } on Exception catch (e) {
      throw Exception("Failed to delete notification: $e");
    }
  }
  @override
  Future<NotificationPaginationResponse> getNotificationsByPagination(
      NotificationPaginationRequest request) async {
    final logger = Logger(); // Assuming you have a logger instance in your DI
    const methodName = 'getNotificationsByPagination';

    try {
      logger.i('[$methodName] Starting to fetch notifications with request: $request');

      // Get user ID
      logger.v('[$methodName] Retrieving user ID from store');
      final userId = await store.getUserId();
      logger.v('[$methodName] Retrieved user ID: $userId');

      // Create collection reference
      logger.v('[$methodName] Creating Firestore collection reference');
      final userLineNotificationRef = firestore
          .collection("users")
          .doc(userId)
          .collection("notifications");
      logger.v('[$methodName] Collection reference created for user $userId');

      // Build initial query
      logger.v('[$methodName] Building initial query with limit: ${request.limit}');
      Query query = userLineNotificationRef
          .orderBy("createdAt", descending: true)
          .limit(request.limit);
      logger.v('[$methodName] Initial query built');

      // Apply pagination if last document provided
      if (request.lastDocument != null) {
        logger.v('[$methodName] Applying pagination with last document: ${request.lastDocument!.id}');
        query = query.startAfterDocument(request.lastDocument!);
        logger.v('[$methodName] Pagination applied to query');
      }

      // Execute query
      logger.v('[$methodName] Executing Firestore query');
      final querySnapshot = await query.get();
      logger.v('[$methodName] Query executed, found ${querySnapshot.docs.length} documents');

      // Handle empty results
      if (querySnapshot.docs.isEmpty) {
        logger.i('[$methodName] No notifications found for user $userId');
        return NotificationPaginationResponse(notifications: [], lastDocument: null);
      }

      // Map documents to models
      logger.v('[$methodName] Mapping documents to NotificationUserModel');
      final notifications = querySnapshot.docs.map((doc) {
        logger.v('[$methodName] Processing document ${doc.id}');
        try {
          final notification = NotificationUserModel.fromJson(
            doc.data() as Map<String, dynamic>,
            // Include the document ID if needed
          );
          logger.v('[$methodName] Successfully mapped document ${doc.id}');
          return notification;
        } catch (e) {
          rethrow;
          rethrow;
        }
      }).toList();
      logger.v('[$methodName] Completed mapping ${notifications.length} notifications');

      // Get last document for pagination
      logger.v('[$methodName] Getting last document for pagination');
      final lastDocument = querySnapshot.docs.last;
      logger.v('[$methodName] Last document ID: ${lastDocument.id}');

      // Prepare response
      logger.v('[$methodName] Preparing response with ${notifications.length} notifications');
      final response = NotificationPaginationResponse(
        notifications: notifications,
        lastDocument: lastDocument,
      );
      logger.i('[$methodName] Successfully fetched ${notifications.length} notifications');

      return response;

    } on FirebaseException catch (e) {

      throw Exception('Firestore error: ${e.message}');
    } on Exception catch (e) {

      throw Exception('Failed to fetch notifications: ${e.toString()}');
    } finally {
      logger.v('[$methodName] Method execution completed');
    }
  }
  @override
  Future<Unit> updateSeenToTrue(String notificationId) async {
    try {
      final userId = await store.getUserId();
      final userRef = firestore.collection("users").doc(userId);
      final notificationRef = userRef.collection("notifications").doc(notificationId);

      // Run in a transaction to ensure atomicity
      await firestore.runTransaction((transaction) async {
        // Get current unread count
        final userDoc = await transaction.get(userRef);
        final currentCount = userDoc.get('unreadNotificationCount') ?? 0;
        transaction.update(notificationRef, {"seen": true});
        // Only proceed if count > 0
        if (currentCount > 0) {

          transaction.update(userRef, {
            "unreadNotificationCount": FieldValue.increment(-1)
          });
        }
      });

      return unit;
    } on FirebaseException catch (e) {
      throw Exception("Failed to update notification: ${e.message}");
    } on Exception catch (_) {
      throw ServerException();
    }
  }}