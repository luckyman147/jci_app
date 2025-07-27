part of 'objectif_form_cubit.dart';

class ObjectifFormState extends Equatable {
  const ObjectifFormState({
    this.groupObjectif,
    this.groupBy="Status",
    this.points,
    this.target,

    this.objectifActionType ,
    this.feature ,
    this.cibles = const [],
    this.privacy,
    this.isClicked = false,
    this.difficulty ,
  });
  final GroupObjectif? groupObjectif;//1
  final ObjectifActionType? objectifActionType;//2
  final FeaturesType? feature;//3
  final String? points;
  final String? target;
  final List<CibleType> cibles;//4
final PrivacyType? privacy;//5
final String? groupBy;
final ObjectifDifficulty? difficulty; final bool isClicked;
//CopyWith
  ObjectifFormState copyWith({
    bool? isClicked,
    String? groupBy,
    String? target,
    String? points,

    GroupObjectif? groupObjectif,
    ObjectifActionType? objectifActionType,
    FeaturesType? feature,
    List<CibleType>? cibles,
    PrivacyType? privacy,
    ObjectifDifficulty? difficulty,
  }) {
    return ObjectifFormState(
      target: target??this.target,

      points: target??this.points,
      groupBy: groupBy ?? this.groupBy,
      isClicked: isClicked ?? this.isClicked,
      groupObjectif: groupObjectif ?? this.groupObjectif,
      objectifActionType: objectifActionType ?? this.objectifActionType,
      feature: feature ?? this.feature,
      cibles: cibles ?? this.cibles,
      privacy: privacy ?? this.privacy,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [groupBy,isClicked,  difficulty,privacy,cibles,feature,groupObjectif,objectifActionType,points,target];//6

}

final class ObjectifFormInitial extends ObjectifFormState {
  @override
  List<Object> get props => [];
}
