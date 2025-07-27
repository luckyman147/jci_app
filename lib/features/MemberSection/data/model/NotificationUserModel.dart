

  import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/Notification.dart';

class NotificationUserModel extends NotificationUser {
  NotificationUserModel({required super.title, required super.body, required super.type, required super.createdAt,
    required super.seen,
     super.toMemberId,
    required super.notificationId});


  // Factory method to create an instance from JSON
  factory NotificationUserModel.fromJson(Map<String, dynamic> json) {
    return NotificationUserModel(
      notificationId: json["notificationId"],
      title: json['title'],
      body: json['body'],
      type: NotificationType.values.firstWhere(
            (e) => e.name == "${json['type']}",
      ),
      createdAt: _parseDateTime(json['createdAt']),
      seen: json['seen'] ?? false,
    );
  }
  static DateTime _parseDateTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else if (timestamp is DateTime) {
      return timestamp;
    }
    return DateTime.now(); // Fallback to current time if parsing fails
  }
  factory NotificationUserModel. fromFactory(NotificationUser notification){
    return NotificationUserModel(

      title:notification.title, body: notification.body,
      type: notification.type,
      createdAt: notification.createdAt, seen: false, notificationId: notification.notificationId,


    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "notificationId":notificationId,
      'title': title,
      'body': body,
      'type': type.name, // Store enum as string
      'createdAt': createdAt.toIso8601String(),
      'seen': seen,
    };
  }

  // CopyWith method to create a new instance with updated fields
  NotificationUserModel copyWith({
    String?notificationId,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? seen,
  }) {
    return NotificationUserModel(
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      seen: seen ?? this.seen, notificationId: notificationId??this.notificationId,
    );
  }
}