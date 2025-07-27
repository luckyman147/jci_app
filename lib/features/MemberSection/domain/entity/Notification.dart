import '../../../Home/Activity_Global.dart';

enum NotificationType{Objectifs,Activities,Comments,Replies,PV,Warning,Reminder}
class NotificationUser {
  final String notificationId;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool seen;
  final String? toMemberId;

  NotificationUser({
    this.toMemberId,
    required this.notificationId,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.seen = false,
  });

  // Map for icons
  static final Map<NotificationType, IconData> typeIcons = {
    NotificationType.Objectifs: Icons.flag, // Example icon for Objectif
    NotificationType.Activities: Icons.event, // Example icon for Activities
    NotificationType.Comments: Icons.comment, // Example icon for Comments
    NotificationType.Replies: Icons.reply, // Example icon for Replies
    NotificationType.PV: Icons.description, // Example icon for PV
    NotificationType.Warning: Icons.warning, // Example icon for Warning
    NotificationType.Reminder: Icons.info, // Example icon for Reminder
  };

  // Map for colors
  static final Map<NotificationType, Color> typeColors = {
    NotificationType.Objectifs: ColorsApp.PrimaryColor, // Example color for Objectif
    NotificationType.Activities: Colors.deepOrange, // Example color for Activities
    NotificationType.Comments: Colors.orange, // Example color for Comments
    NotificationType.Replies: Colors.purple, // Example color for Replies
    NotificationType.PV: Colors.teal, // Example color for PV
    NotificationType.Warning: Colors.red, // Example color for Warning
    NotificationType.Reminder: ColorsApp.SecondaryColor, // Example color for Reminder
  };

  // Getter for icon
  IconData get icon => typeIcons[type] ?? Icons.notifications; // Default icon

  // Getter for color
  Color get color => typeColors[type] ?? Colors.grey; // Default color
}