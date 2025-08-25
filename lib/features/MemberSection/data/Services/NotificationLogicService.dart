import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/NotificationUserModel.dart';

class NotificationLogicService{

  Future<void> createWarningNotification(
      NotificationUserModel notification,
      FirebaseFirestore firestore,
     String? userId
      ) async {
   // Replace with the actual user ID
    final userRef = firestore.collection("users").doc(userId);

    // Add the notification to the user's notifications subcollection
    await userRef.collection("notifications").add({
      "title": notification.title,
      "body": notification.body,
      "type": notification.type.name,
      "createdAt": FieldValue.serverTimestamp(),
      "seen": false,
    });
  }
  Future<void> createReminderNotification(
      NotificationUserModel notification,
      FirebaseFirestore firestore,
      ) async {
    // Fetch all users
    final usersSnapshot = await firestore.collection("users").get();

    // Add the notification to each user's notifications subcollection
    for (final userDoc in usersSnapshot.docs) {
      await userDoc.reference.collection("notifications").add({
        "title": notification.title,
        "body": notification.body,
        "type": notification.type.name,
        "createdAt": FieldValue.serverTimestamp(),
        "seen": false,
      });
    }
  }
}