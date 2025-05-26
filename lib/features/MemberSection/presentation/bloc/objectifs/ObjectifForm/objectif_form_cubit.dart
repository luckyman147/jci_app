import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/MemberSection/domain/entity/ActionDetails.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';

import '../../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';

part 'objectif_form_state.dart';

class ObjectifFormCubit extends Cubit<ObjectifFormState> {
  ObjectifFormCubit() : super(ObjectifFormInitial());

  void setGroupObjectif(GroupObjectif groupObjectif){
    emit(state.copyWith(groupObjectif: groupObjectif));


  }
  void onPointsChanged(String? points) {
    // Emit a new state to trigger a rebuild
    emit(state.copyWith(points:points )); // You can add additional logic here if needed
  }
  void onTargetChanged(String? target) {
    // Emit a new state to trigger a rebuild
    emit(state.copyWith(target:target )); // You can add additional logic here if needed
  }
  void SetObjectifDetails(Objectif objectif){
    emit(state.copyWith(
      groupObjectif: objectif.groupObjectif,
      objectifActionType: objectif.objectifActionType,
      feature: objectif.feature,
      cibles: objectif.cible,
      privacy: objectif.privacy,
      difficulty: objectif.difficulty,



    ));
  }

  void setGroupBy(String groupBy){
    emit(state.copyWith(groupBy: groupBy));
  }
  void setBool(bool isClicked){
    emit(state.copyWith(isClicked: isClicked));
  }
  void setObjectifActionType(ObjectifActionType objectifActionType){
    emit(state.copyWith(objectifActionType: objectifActionType));
  }
  void setFeature(FeaturesType feature){
    emit(state.copyWith(feature: feature));
  }
  void setCibles(CibleType cibles){
    emit(state.copyWith(cibles: [...state.cibles,cibles]));
  }
  void setPrivacy(PrivacyType privacy){
    emit(state.copyWith(privacy: privacy));
  }
  void setDifficulty(ObjectifDifficulty difficulty){
    emit(state.copyWith(difficulty: difficulty));
  }

  void removeCible(CibleType cible) {
    emit(state.copyWith(cibles: state.cibles.where((element) => element != cible).toList()));
  }
  void reset(){
    emit(ObjectifFormInitial());
  }

}
