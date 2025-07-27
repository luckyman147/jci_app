import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';


class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    // Configure Android notification details
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon'); // Use app icon

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    _localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            // Handle notification tap
            Logger().i('Notification payload: ${response.payload}');
          }
        });
  }
static BigPictureStyleInformation? showNotificationWithImage(String? title, String? body, String? imageUrl)  {
    if (imageUrl==null ||imageUrl.isEmpty) {
      return null;
    }
   return  BigPictureStyleInformation(
      FilePathAndroidBitmap(imageUrl),
      largeIcon: FilePathAndroidBitmap(imageUrl),
      contentTitle: title,
      summaryText: body,
    );
  }
  static void showNotification(RemoteMessage message) {
     AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation:
      showNotificationWithImage( message.notification?.title,
        message.notification?.body,message.data['image']),


    );

     NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data['route'], // Pass custom route or data
    );
  }

  static Future<void> showCountUpNotification(RemoteMessage message) async {
    final title = message.data['title'] ?? 'Unknown';
    final endDateString = message.data['end_time'] ?? '';

    // Parse the end date string back to DateTime
    final DateTime? endDate = DateTime.tryParse(endDateString);

    if (endDate == null) {
      Logger().w('Invalid expire date. No notification will be shown.');
      return; // Exit if the end date is invalid
    }

    final currentTime = DateTime.now();

    if (endDate.isBefore(currentTime)) {
      Logger().w('Expire date is in the past. No notification will be shown.');
      return; // Don't show notification if the expire date has already passed
    }

    final duration = endDate.difference(currentTime).inMinutes; // Duration in minutes
    final startTime = currentTime.millisecondsSinceEpoch;

    final AndroidNotificationDetails androidNotificationDetailsChronometer =
    AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      channelDescription: 'Channel Description',
      importance: Importance.max,
      priority: Priority.max,
      ongoing: true,
      when: startTime, // Start time in milliseconds
      usesChronometer: true,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      chronometerCountDown: false, // Count up instead of counting down
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
    );

    await _localNotificationsPlugin.show(
      0,
      "Agenda: $title",
      "Temps restants: $duration minutes",
      NotificationDetails(android: androidNotificationDetailsChronometer),
    );
  }

}
