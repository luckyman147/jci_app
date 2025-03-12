part of 'objectif_form_cubit.dart';

class ObjectifFormState extends Equatable {
  const ObjectifFormState({
    this.groupObjectif,
    this.objectifActionType ,
    this.feature ,
    this.cibles = const [],
    this.privacy,
    this.difficulty ,
  });
  final GroupObjectif? groupObjectif;//1
  final ObjectifActionType? objectifActionType;//2
  final FeaturesType? feature;//3
  final List<CibleType> cibles;//4
final PrivacyType? privacy;//5
final ObjectifDifficulty? difficulty;
//CopyWith
  ObjectifFormState copyWith({
    GroupObjectif? groupObjectif,
    ObjectifActionType? objectifActionType,
    FeaturesType? feature,
    List<CibleType>? cibles,
    PrivacyType? privacy,
    ObjectifDifficulty? difficulty,
  }) {
    return ObjectifFormState(
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
  List<Object?> get props => [difficulty,privacy,cibles,feature,groupObjectif,objectifActionType];//6

}

final class ObjectifFormInitial extends ObjectifFormState {
  @override
  List<Object> get props => [];
}
