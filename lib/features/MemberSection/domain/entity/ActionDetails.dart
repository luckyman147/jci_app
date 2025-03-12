import 'Objectif.dart';
enum PrivacyType { Public, Private }
enum CibleType { Members, NewMembers, VPs,President,Advisors,Secretary,CommittedMember }
enum ObjectifActionType{Create,Update,Delete,Attend,Join,Comment,VoteIn,Send,Discover,CheckIn}
enum GroupObjectif{Modification,Interaction,Decision,Contribution,Exploration,AttendanceCheck}

class ObjectifType{
  final List<ActionDetailsType> actionType;
  final GroupObjectif groupObjectif;

  ObjectifType({required this.actionType, required this.groupObjectif, });
}


class ActionDetails {
  final String? runtype;
  final List<FeaturesType> features;
  final List<PrivacyType>? privacy;
  final List<CibleType> cible;
  final List<ObjectifDifficulty>? difficulty;

  ActionDetails({
  required  this.runtype,
    required this.features,
    required this.privacy,
    required this.cible,
    required this.difficulty,
  });

}
class ActionDetailsType{
  final ObjectifActionType actionType;
  final ActionDetails actionDetails;

  ActionDetailsType({required this.actionType, required this.actionDetails});
}extension FeaturesTypeExtension on CibleType {
  String get formattedName {
    return name.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return "${match.group(1)} ${match.group(2)}";
    });
  }
}