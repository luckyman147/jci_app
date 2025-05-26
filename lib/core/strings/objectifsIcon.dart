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
    FeaturesType.Events:
    ObjectifIconData(icon: Icons.event, color: Colors.green), // 📅 Events
    FeaturesType.Meetings:
    ObjectifIconData(icon: Icons.groups, color: Colors.orange), // 👥 Meetings
    FeaturesType.Trainings:
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
    ObjectifIconData(icon: Icons.person_pin, color: Colors.amber), // ⏳ Past Presidents
     FeaturesType.Members:
    ObjectifIconData(icon: Icons.person_rounded, color: Colors.greenAccent), // ⏳ member
      FeaturesType.Guests:
    ObjectifIconData(icon: Icons.perm_contact_cal_sharp, color: Colors.teal),
    FeaturesType.Objectif:
    ObjectifIconData(icon: Icons.flag_circle, color: Colors.grey), // ⏳ member
     FeaturesType.Replys:
    ObjectifIconData(icon: Icons.redo_rounded, color: Colors.limeAccent),
    FeaturesType.Emojis:
    ObjectifIconData(icon: Icons.emoji_emotions, color: Colors.yellowAccent),
    FeaturesType.Pv:
    ObjectifIconData(icon: Icons.file_copy, color: Colors.red),

    // ⏳ member
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
    ObjectifActionType.CheckIn: Icons.fact_check,
    ObjectifActionType.ReactTo: Icons.add_reaction,
    ObjectifActionType.ReplyTo: Icons.reply,

    // 🔍 Discover
  };

  static IconData getIcon(ObjectifActionType type) {
    return actionIcons[type] ?? Icons.help_outline;
  }
}
class GroupObjectifIcons {
  static Map<GroupObjectif, ObjectifIconData> groupIcons = {
    GroupObjectif.Modification: ObjectifIconData(icon:Icons.build,color:  Colors.orange), // 🛠️ Modification
    GroupObjectif.Interaction: ObjectifIconData(icon:Icons.sync, color: PrimaryColor), // 🔄 Interaction
    GroupObjectif.Decision: ObjectifIconData(icon :Icons.check_box,color:  Colors.green), // ✅ Decision
    GroupObjectif.Contribution: ObjectifIconData( icon:Icons.volunteer_activism,color:  Colors.purple), // 🤝 Contribution
    GroupObjectif.Exploration: ObjectifIconData(icon:Icons.explore,color:  Colors.teal), // 🔍 Exploration
    GroupObjectif.AttendanceCheck: ObjectifIconData(icon:Icons.card_membership,color:  Colors.red), // 🏷️ Attendance Check
  };
  static IconData getIcon(GroupObjectif type) {
    return groupIcons[type]==null ? Icons.help_outline:groupIcons[type]!.icon;
  }static Color getcolor(GroupObjectif type) {
    return groupIcons[type]==null ? ColorsApp.textColor:groupIcons[type]!.color;
  }
}
