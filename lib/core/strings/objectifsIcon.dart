import '../../features/Home/Activity_Global.dart';
import '../../features/MemberSection/domain/entity/ActionDetails.dart';
import '../../features/MemberSection/domain/entity/Objectif.dart';

class ObjectifIconData {
  final IconData icon;
  final Color color;

  ObjectifIconData({required this.icon, required this.color});
}




class ObjectifIcons {
  final Map<FeaturesType, ObjectifIconData> objectifIcons;

  ObjectifIcons()
      : objectifIcons = {
    FeaturesType.events:
    ObjectifIconData(icon: Icons.event, color: Colors.green), // 📅 Events
    FeaturesType.meetings:
    ObjectifIconData(icon: Icons.groups, color: Colors.orange), // 👥 Meetings
    FeaturesType.trainings:
    ObjectifIconData(icon: Icons.school, color: Colors.red), // 🎓 Trainings
    FeaturesType.teams: ObjectifIconData(
        icon: Icons.supervised_user_circle, color: Colors.purple), // 🏆 Teams
    FeaturesType.Votes:
    ObjectifIconData(icon: Icons.how_to_vote, color: Colors.blue), // 🗳 Votes
    FeaturesType.Comments:
    ObjectifIconData(icon: Icons.comment, color: Colors.teal), // 💬 Comments
    FeaturesType.Activities:
    ObjectifIconData(icon: Icons.local_activity, color: Colors.cyan), // 🎭 Activities
    FeaturesType.Board:
    ObjectifIconData(icon: Icons.dashboard, color: Colors.brown), // 📋 Board
    FeaturesType.Culture:
    ObjectifIconData(icon: Icons.public, color: Colors.pink), // 🌍 Culture
    FeaturesType.PastPresident:
    ObjectifIconData(icon: Icons.history, color: Colors.grey), // ⏳ Past Presidents
  };

  ObjectifIconData getIcon(FeaturesType type) {
    return objectifIcons[type] ??
        ObjectifIconData(icon: Icons.help_outline, color: Colors.black);
  }
}

class ObjectifDifficultyColor {
  Map<ObjectifDifficulty, Color> objectifDifficultyColor;

  ObjectifDifficultyColor()
      : objectifDifficultyColor= {
   ObjectifDifficulty.Basic:ColorsApp.PrimaryColor,
   ObjectifDifficulty.Meduim:ColorsApp.SecondaryColor,
   ObjectifDifficulty.Extreme:Colors.red,
   ObjectifDifficulty.Hard:Colors.deepOrangeAccent,

  };
}
class ObjectifActionIcons {
  static const Map<ObjectifActionType, IconData> actionIcons = {
    ObjectifActionType.Create: Icons.add, // ➕ Create
    ObjectifActionType.Update: Icons.edit, // ✏️ Update
    ObjectifActionType.Delete: Icons.delete, // 🗑 Delete
    ObjectifActionType.Attend: Icons.event_available, // 📆 Attend
    ObjectifActionType.Join: Icons.group_add, // 👥 Join
    ObjectifActionType.Comment: Icons.comment, // 💬 Comment
    ObjectifActionType.VoteIn: Icons.how_to_vote, // 🗳 Vote In
    ObjectifActionType.Send: Icons.send, // 📤 Send
    ObjectifActionType.Discover: Icons.explore, // 🔍 Discover
  };

  static IconData getIcon(ObjectifActionType type) {
    return actionIcons[type] ?? Icons.help_outline;
  }
}
class GroupObjectifIcons {
  static const Map<GroupObjectif, IconData> groupIcons = {
    GroupObjectif.Modification: Icons.build, // 🛠️ Modification
    GroupObjectif.Interaction: Icons.sync, // 🔄 Interaction
    GroupObjectif.Decision: Icons.check_box, // ✅ Decision
    GroupObjectif.Contribution: Icons.volunteer_activism, // 🤝 Contribution
    GroupObjectif.Exploration: Icons.explore, // 🔍 Exploration
    GroupObjectif.AttendanceCheck: Icons.card_membership, // 🔍 Exploration
  };

  static IconData getIcon(GroupObjectif type) {
    return groupIcons[type] ?? Icons.help_outline;
  }
}