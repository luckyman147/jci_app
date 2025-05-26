import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../auth/AuthWidgetGlobal.dart';
import '../../../../domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../../../domain/entity/UserObjectifInfos.dart';
import '../../../../domain/usecases/ObjectifUsesCase.dart';

part 'user_objectif_progress_state.dart';

class UserObjectifProgressCubit extends Cubit<UserObjectifProgressState> {
  UserObjectifProgressCubit(this.userObjectivesProgressUsesCase, this.store) : super(UserObjectifProgressInitial());
  final updateUserObjectivesProgressUsesCase userObjectivesProgressUsesCase;
  final Store store;
  ///update user objectivre progress

  updateProgressUserObjective(UpdateObjectiveProgressDTO update)async{
    try {
      if (update.userId.isEmpty){
        final id=await store.getUserId();
      update=  update.copyWith(userId: id);
      }

      final request=    await userObjectivesProgressUsesCase.call(update);
      emit(EitherObjectifsOrSucces(request, (r) {

        return      state.copyWith(userProgressUpdates: r,progress: ProgresStatus.Loaded);
      }));
    } catch (e) {
      Logger().e(e);
      emit(state.copyWith(progress: ProgresStatus.Failure));
    }

}
//remove first index of list
  depiler(){
    if (state.userProgresUpdates.isNotEmpty) {
      state.userProgresUpdates.removeAt(0);
      emit(state.copyWith(userProgressUpdates: state.userProgresUpdates,progress: ProgresStatus.Loaded));
    }
    else {
      emit(state.copyWith(userProgressUpdates: [],progress: ProgresStatus.Empty));
    }



  }

  UserObjectifProgressState EitherObjectifsOrSucces<T>(Either<Failure,T> request,Function(T) function){
    return request.fold(
          (l) => state.copyWith(progress: ProgresStatus.Failure),
          (r) => function(r),
    );
  }}