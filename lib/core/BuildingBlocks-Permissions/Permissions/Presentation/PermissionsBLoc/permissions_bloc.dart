import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:googleapis/shared.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/repo/IPermissionStrategy.dart';

import '../../../../error/Failure.dart';
import '../../../../strings/failures.dart';
import '../../domain/Entities/PermissionsFunctions.dart';
import '../../domain/UseCases/PermissionsUseCases.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> implements Strategy<PermissionsEvent,Emitter<PermissionsState>> {
  final LoadMasterPermissionsUseCase loadMasterPermissionsUseCase;
  PermissionsBloc(this.loadMasterPermissionsUseCase) : super(PermissionsLoadingState()) {
    on<PermissionsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadPermissionOfMasterEvent>(LoadPermissionsOfMaster);
  }

  @override
  Future<void> LoadPermissionsOfMaster(PermissionsEvent event, Emitter<PermissionsState> emit) async {
    try {
      // Cast the event to the specific type
      if (event is LoadPermissionOfMasterEvent) {

        if (state.permissions.isNotEmpty && checkAllIdsExist(event.featuresId,state.permissions)){
          emit(state.copyWith(type: TypePermissionsStatus.Loaded));
          return;
        }


        emit(state.copyWith(type: TypePermissionsStatus.Loading));


        final data = await loadMasterPermissionsUseCase.call(event.featuresId);

        // Emit the new state
        emit(EithFailureorResponse<List<FeaturePermissions>>(
          data,
              (res) {

                return state.copyWith(permissions: res,type: TypePermissionsStatus.Loaded);
              },
        ));
      }
    } catch (e) {
      emit(state.copyWith(type: TypePermissionsStatus.Error));
      rethrow;
    }
  }


PermissionsState EithFailureorResponse<T>(  Either<Failure, T> response,Function(T) onreturn){
     return response.fold( ( failure){
     return  state.copyWith(type:TypePermissionsStatus.Error,errorMessage: mapFailureToMessage(failure));

     },(res){
       return onreturn(res);

     });
}
}
