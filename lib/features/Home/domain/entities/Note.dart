import '../../../../core/PrimitiveUser/User.dart';

class ActivityComment {
  final String Commentid;
  final String activityId;
  final User user;
  final String content;
  final DateTime createdAt;

  List<ReplyComment> replies;
  List<Reaction> Reactions;

  ActivityComment({
    required this.Commentid,
    required this.activityId,
required this.user,
    required this.content,
    this.replies = const [],

    required this.Reactions,
    required this.createdAt,
  });


}
class ReplyComment {
  final String Commentid;
  final String Replyid;
  final String activityId;
  final User user;
  final String content;
  final DateTime createdAt;

  final List<Reaction> Reactions;

  ReplyComment({
    required this.Commentid,
    required this.activityId,
required this.user,
    required this.content,
    required this.Replyid,
    this.Reactions=const [],
    required this.createdAt,
  });


}
class Reaction{
  final String ActivityId;
  final String reaction;
   final int numberOfUsers;
   final List<String> users;

  Reaction( {required this.ActivityId,required this.reaction, required this.numberOfUsers, required this.users});

  //copyWith method
  Reaction copyWith({
    String? reaction,
    int? numberOfUsers,
    List <String>? users
    ,String? ActivityId,

  }) {
    return Reaction
      (
      ActivityId: ActivityId ?? this.ActivityId,
      users: users ?? this.users,
      reaction: reaction ?? this.reaction,
      numberOfUsers: numberOfUsers ?? this.numberOfUsers,
    );
  }
}
