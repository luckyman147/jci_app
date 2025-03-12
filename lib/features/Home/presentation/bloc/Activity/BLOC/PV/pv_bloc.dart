import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/features/Home/domain/Dtos/PVParamDto.dart';
import 'package:jci_app/features/Home/domain/usercases/PvUseCases.dart';

import '../../../../../domain/entities/PVEntity/PV.dart';

part 'pv_event.dart';
part 'pv_state.dart';

class PvBloc extends Bloc<PvEvent, PvState> {
  PvBloc(this.getPvsOfActivty, this.addPv, this.deletePv, this.downloadPv) : super(PvInitial()) {
    on<PvEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<AddPvEvent>(_addPv);
    on<DeletePvEvent>(_deletePv);
    on<GetPvList>(_getPvsOfActivity);
    on<downloadPvEvent>(_downloadPv);
    on<LoadLink>(_loadLink);

  }
final DownloadPv downloadPv;
  final GetPvsOfActivty getPvsOfActivty;
  final AddPv addPv;
  final DeletePv deletePv;

PvState _eitherFailureOrSuccess<T>( Either<Failure,T> result , Function(T) onSuccess){
 return result.fold((failure) {
    return state.copyWith(
    Message: mapFailureToMessage(failure),
  );
  }, (success) {
    return onSuccess(success);
  });


}


  FutureOr<void> _loadLink(LoadLink event, Emitter<PvState> emit)async {
    emit(state.copyWith(link: event.path));
  }

  FutureOr<void> _getPvsOfActivity(GetPvList event, Emitter<PvState> emit) async{
    emit(state.copyWith(status: PvStatus.loading));

    final result = await getPvsOfActivty(event.id);
    emit(_eitherFailureOrSuccess(result, (success) => state.copyWith(pvs: success, status: PvStatus.loaded)));

  }

  FutureOr<void> _deletePv(DeletePvEvent event, Emitter<PvState> emit) async{
    emit(state.copyWith(status: PvStatus.loading));
    final result = await deletePv(event.params);
    state.pvs.removeWhere((element) => element.id == event.params.PVId);
    emit(_eitherFailureOrSuccess(result, (success) => state.copyWith(status: PvStatus.loaded,Message: 'Deleted Successfully',pvs: state.pvs)));

  }

  FutureOr<void> _addPv(AddPvEvent event, Emitter<PvState> emit)async {
    emit(state.copyWith(status: PvStatus.loading));
    final result = await addPv(event.params);


add(GetPvList(event.params.ActivityId));
    emit(_eitherFailureOrSuccess(result, (success) {
      return state.copyWith(status: PvStatus.Added,Message: 'Added Successfully');

    }));
  }

  FutureOr<void> _downloadPv(downloadPvEvent event, Emitter<PvState> emit) async{


    final result = await downloadPv(event.pv);
    emit(_eitherFailureOrSuccess(result, (success) => state.copyWith(status: PvStatus.loaded,Message: 'Opened Successfully')));

  }
}
