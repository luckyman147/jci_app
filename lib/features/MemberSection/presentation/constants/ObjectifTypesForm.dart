import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';
import '../../domain/entity/ActionDetails.dart';

class ObjectiveTypesForm{


  static final CheckAttendanceGroup=ObjectifType(
    actionType: [

      ActionDetailsType(actionType: ObjectifActionType.CheckIn,
          actionDetails: ActionDetails(runtype: "int",
              features: [FeaturesType.Members,FeaturesType.Guests],
              privacy:null,
              cible: [CibleType.President, CibleType.VPs],
              difficulty: ObjectifDifficulty.values.toList())),

    ],
    groupObjectif: GroupObjectif.AttendanceCheck);


static final ModificationGroup=ObjectifType(
    actionType: [

      ActionDetailsType(actionType: ObjectifActionType.Create,
          actionDetails: ActionDetails(runtype: "int",
              features: [FeaturesType.Events,FeaturesType.Meetings,FeaturesType.Trainings,FeaturesType.teams,
                FeaturesType.Activities,FeaturesType.Votes,FeaturesType.Objectif,FeaturesType.Pv],
              privacy: PrivacyType.values.toList(),
              cible: [CibleType.President, CibleType.VPs],
              difficulty: ObjectifDifficulty.values.toList())),
      ActionDetailsType(actionType: ObjectifActionType.Update,
          actionDetails: ActionDetails(runtype: "int",
              features: [FeaturesType.Events,FeaturesType.Meetings,FeaturesType.Trainings,FeaturesType.teams,FeaturesType.Activities,FeaturesType.Votes,FeaturesType.Objectif],
              privacy: PrivacyType.values.toList(),
              cible: [CibleType.President, CibleType.VPs],
              difficulty: ObjectifDifficulty.values.toList())),
      ActionDetailsType(actionType: ObjectifActionType.Delete,
          actionDetails: ActionDetails(runtype: "int",
              features: [FeaturesType.Events,FeaturesType.Meetings,FeaturesType.Trainings,FeaturesType.teams,
                FeaturesType.Activities,FeaturesType.Votes,FeaturesType.Objectif,FeaturesType.Pv],
              privacy: PrivacyType.values.toList(),
              cible: [CibleType.President, CibleType.VPs],
              difficulty: ObjectifDifficulty.values.toList())),
    ],
    groupObjectif: GroupObjectif.Modification);

static final InteractionGroup=ObjectifType(
    actionType: [

      ActionDetailsType(actionType: ObjectifActionType.Attend,
          actionDetails: ActionDetails(runtype: "int",
              features: [FeaturesType.Events,FeaturesType.Meetings,FeaturesType.Trainings,FeaturesType.teams,FeaturesType.Activities,],
              privacy: PrivacyType.values.toList(),
              cible: CibleType.values.toList(),
              difficulty: ObjectifDifficulty.values.toList())),
      ActionDetailsType(actionType: ObjectifActionType.Join,
          actionDetails: ActionDetails(runtype: "int",
              features: [FeaturesType.Events,FeaturesType.Meetings,FeaturesType.Trainings,FeaturesType.teams,FeaturesType.Activities,],
              privacy: PrivacyType.values.toList(),
              cible: CibleType.values.toList(),
              difficulty: ObjectifDifficulty.values.toList())),

    ],
    groupObjectif: GroupObjectif.Interaction);
static final DecisionGroup=ObjectifType(
    actionType: [

      ActionDetailsType(actionType: ObjectifActionType.VoteIn,
          actionDetails: ActionDetails(runtype: "int",
              features: [FeaturesType.Meetings],
              privacy: PrivacyType.values.toList(),
              cible: CibleType.values.toList(),
              difficulty: ObjectifDifficulty.values.toList())),
    ],
    groupObjectif: GroupObjectif.Decision);

static final ContributionGroup=ObjectifType(
    actionType: [

      ActionDetailsType(
          actionType: ObjectifActionType.Send,
          actionDetails: ActionDetails(
              runtype: "int",
              features: [FeaturesType.Comments],
              privacy: null,
              cible: CibleType.values.toList(),
              difficulty: ObjectifDifficulty.values.toList())),
      ActionDetailsType(
          actionType: ObjectifActionType.ReplyTo,
          actionDetails: ActionDetails(
              runtype: "int",
              features: [FeaturesType.Comments],
              privacy: null,
              cible: CibleType.values.toList(),
              difficulty: ObjectifDifficulty.values.toList())),

            ActionDetailsType(
          actionType: ObjectifActionType.ReactTo,
          actionDetails: ActionDetails(
              runtype: "int",
              features: [FeaturesType.Comments],
              privacy: null,
              cible: CibleType.values.toList(),
              difficulty: ObjectifDifficulty.values.toList())),
                ActionDetailsType(
          actionType: ObjectifActionType.Update,
          actionDetails: ActionDetails(
              runtype: "int",
              features: [FeaturesType.Comments,FeaturesType.Replys,FeaturesType.Emojis],
              privacy: null,
              cible: CibleType.values.toList(),
              difficulty: ObjectifDifficulty.values.toList())),


    ],
    groupObjectif: GroupObjectif.Contribution);
static final ExplorationGroup=ObjectifType(
    actionType: [

      ActionDetailsType(
          actionType: ObjectifActionType.Discover,
          actionDetails: ActionDetails(
              runtype: null,
              features: [FeaturesType.Board,FeaturesType.Culture,FeaturesType.PastPresident],
              privacy: null,
              cible: CibleType.values.toList(),
              difficulty: null,))
    ],
    groupObjectif: GroupObjectif.Exploration);


static final groupsObjectifs=[
  CheckAttendanceGroup,
  ModificationGroup,InteractionGroup,
  DecisionGroup,
ContributionGroup,
  ExplorationGroup,

];
static List<ObjectifActionType> getActionTypesByGroup(GroupObjectif group) {
  final objectif = groupsObjectifs.firstWhere(
        (obj) => obj.groupObjectif == group,

  );

  return objectif?.actionType.map((action) => action.actionType).toList() ?? [];
}

static List<CibleType> getCiblesByGroup(GroupObjectif group) {
  final objectif = groupsObjectifs.firstWhere(
        (obj) => obj.groupObjectif == group,

  );

  return objectif?.actionType
      .expand((action) => action.actionDetails.cible)
      .toSet() // Remove duplicates
      .toList() ??
      [];
}

  static bool isPrivacyNullForGroup(GroupObjectif group) {
    final objectif = ObjectiveTypesForm.groupsObjectifs.firstWhere(
          (obj) => obj.groupObjectif == group,

    );

    return objectif?.actionType.any((action) => action.actionDetails.privacy == null) ?? false;
  }


  static List<FeaturesType> getFeaturesByGroup(GroupObjectif group, ObjectifActionType type) {
    // Find the matching group objectif
    final objectif = groupsObjectifs.firstWhere(
          (obj) => obj.groupObjectif == group,
     // Handle case where no match is found
    );

    // Filter features by the specified action type
    return objectif.actionType
        .where((action) => action.actionType == type) // Filter by action type
        .expand((action) => action.actionDetails.features) // Expand to get features
        .toSet() // Remove duplicates
        .toList(); // Convert to list
  }}