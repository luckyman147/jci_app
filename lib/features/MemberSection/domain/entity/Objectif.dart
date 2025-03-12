import 'ActionDetails.dart';

enum ObjectifDifficulty{ Extreme,Hard,Meduim,Basic }
    enum FeaturesType { events,
      meetings,
      trainings,
      teams,
      Votes,
      Comments,
      Activities,
      Board,
      Culture,
      Members,Guests,
      PastPresident}
class Objectif {

  final String id;
  final GroupObjectif groupObjectif;//1- modification,inetraction,decision,contribution,exploration
  final ObjectifActionType objectifActionType;//2-create,update,delete,attend,join,comment,voteIn,send,discover
  final PrivacyType? privacy;// 5 public,private
  final List<CibleType> cible;//4 members,newMembers,VPs,President,Advisors,Secretary,CommittedMember
  final ObjectifDifficulty? difficulty;//basic,meduim,hard,extreme

  final FeaturesType feature;// 3 events,meetings,trainings,teams,Votes,Comments,Activities,Board,Culture,PastPresident
  final int? target;//2
  final int points;//5

  Objectif({required this.id, required this.groupObjectif, required this.objectifActionType, required this.privacy, required this.cible, required this.difficulty, required this.feature, required this.target, required this.points});
}

class UserObjectif{
  final String objectifId;
  final int currentProgress;
  final bool isCompleted;
  final dynamic assignedAt;
  UserObjectif(this.isCompleted, this.assignedAt, {required this.objectifId, this.currentProgress=0,});
}extension StringExtension on String {
  String get doublesWords {
    return replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return "${match.group(1)} ${match.group(2)}";
    });
  }

}
