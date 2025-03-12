import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/MemberSection/domain/entity/ActionDetails.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';

part 'objectif_form_state.dart';

class ObjectifFormCubit extends Cubit<ObjectifFormState> {
  ObjectifFormCubit() : super(ObjectifFormInitial());

  void setGroupObjectif(GroupObjectif groupObjectif){
    emit(state.copyWith(groupObjectif: groupObjectif));


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
