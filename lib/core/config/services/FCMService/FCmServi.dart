import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jci_app/core/config/services/store.dart';

class FSMToken {
  final Store store;

  FSMToken({required this.store});
  void getFcmToken(FirebaseMessaging messaging) async {
    messaging.getToken().then((token) {
      if (token != null) {
        storeFcmToken(token); // Store it in Firestore
      }
    });
  }

  Future<void> storeFcmToken(String token) async {
    try {
      // Check if the user is authenticated using FirebaseAuth
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // User is authenticated, store the FCM token in Firestore under the user's document
        var userRef =
            FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

        // Update the 'fcmTokens' array with the new token
        await userRef.update({
          'fcmTokens': [token],
        }).catchError((e) {
          // If no user document exists, create it with the FCM token
          userRef.set({
            'fcmTokens': [token],
          });
        });
      } else {
        // User is not authenticated, try to get the user from local storage

        String? storedUserId = await store.getUserId();

        if (storedUserId != null) {
          // If user ID is found in local storage, use it to store the token
          var userRef =
              FirebaseFirestore.instance.collection('users').doc(storedUserId);

          // Update the 'fcmTokens' array with the new token
          await userRef.update({
            'fcmTokens': FieldValue.arrayUnion([token]),
          }).catchError((e) {
            // If no user document exists, create it with the FCM token
            userRef.set({
              'fcmTokens': [token],
            });
          });
        } else {
          // If no user ID is found in local storage, throw an error
          throw Exception(
              'No authenticated user found and no user ID in local storage.');
        }
      }
    } catch (e) {
      rethrow; // Optionally rethrow the error to be handled higher up in the call stack
    }
  }
}
