import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/config/services/PresidentsStore.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/core/strings/messages.dart';
import 'package:jci_app/features/about_jci/Domain/entities/President.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/error/Failure.dart';
import '../../Domain/useCases/PresidentUseCAses.dart';

part 'presidents_event.dart';
part 'presidents_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}
class PresidentsBloc extends Bloc<PresidentsEvent, PresidentsState> {
  final CreatePresidentUseCases createPresidentUseCases;
  final DeletePresidentUseCases deletePresidentUseCases;
  final GetPresidentsUseCases getPresidentsUseCases;
  final UpdateImagePresidentUseCases updateImagePresidentUseCases;
  final UpdatePresidentUseCases updatePresidentUseCases;
  PresidentsBloc(this.createPresidentUseCases, this.deletePresidentUseCases, this.getPresidentsUseCases, this.updateImagePresidentUseCases, this.updatePresidentUseCases) : super(PresidentsInitial()) {
    on<PresidentsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<CreatePresident>(_onCreatePresident);
    on<DeletePresident>(_onDeletePresident);
    on<GetAllPresidentsEvent>(_onGetAllPresidents,transformer: throttleDroppable(throttleDuration));
    on<UpdateImagePresident>(_onUpdateImagePresident);
    on<UpdatePresident>(_onUpdatePresident);
  }
  Future<void> _onGetAllPresidents(GetAllPresidentsEvent event,Emitter<PresidentsState> emit)async {
    if (state.hasReachedMax) return;
    try {
      if (state.state== presidentsStates.Initial) {
        final result = await getPresidentsUseCases();
        return emit(state.copyWith(state: presidentsStates.Loaded,presidents:
        result.getOrElse(() => []),hasReachedMax: false)
        );
      }
      final result = await getPresidentsUseCases(start: state.presidents.length.toString());
      final pres=result.getOrElse(() => []);
     if (pres.isEmpty) {
     await PresidentStore.setUpdated(false);
     }
      emit(pres.isEmpty?state.copyWith(hasReachedMax: true):
      state.copyWith(
        state: presidentsStates.Loaded,presidents: List.of(state.presidents)..addAll(pres),
        hasReachedMax: false
      )
      );

    }
    catch(e){
      emit(state.copyWith(state: presidentsStates.Error,message: e.toString()));
    }
  }
  void _onCreatePresident(CreatePresident event,Emitter<PresidentsState> emit)async {
    try {
      emit(state.copyWith(state: presidentsStates.Loading));
      final result = await createPresidentUseCases(event.president);
      emit(_createOrFailure(state, result));
    }
    catch(e){
      emit(state.copyWith(state: presidentsStates.ErrorCrete,message: e.toString()));
    }
  }
  //update or failure
  void _onUpdatePresident(UpdatePresident event,Emitter<PresidentsState> emit)async {
    try {
      emit(state.copyWith(state: presidentsStates.Loading));
      final result = await updatePresidentUseCases(event.president);
      emit(_UpdateOrFailure(state, result));

    }
    catch(e){
      emit(state.copyWith(state: presidentsStates.ErrorCrete,message: e.toString()));
    }
  }
  void _onUpdateImagePresident(UpdateImagePresident event,Emitter<PresidentsState> emit)async {
    try {
      emit(state.copyWith(state: presidentsStates.Loading));
      final result = await updateImagePresidentUseCases(event.president);
      emit(_UpdateOrFailure(state, result));

    }
    catch(e){
      log(e.toString());
      emit(state.copyWith(state: presidentsStates.ErrorCrete,message: e.toString()));


    }
  }
  void _onDeletePresident(DeletePresident event,Emitter<PresidentsState> emit)async {
    try {
      emit(state.copyWith(state: presidentsStates.Loading));
      final result = await deletePresidentUseCases(event.id);
      emit(_DeleteOrFailure(state, result,event.id));

    }
    catch(e){
      emit(state.copyWith(state: presidentsStates.Error,message: e.toString()));
    }
  }
  PresidentsState _getAllOrFailure(PresidentsState state, Either<Failure, List<President>> result) {
    return result.fold((l) => state.copyWith(state: presidentsStates.Error, message: mapFailureToMessage(l)),
            (r) => state.copyWith(state: presidentsStates.Loaded, presidents: r));
  }
  PresidentsState _createOrFailure(PresidentsState state, Either<Failure, President> result,) {
    return result.fold((l) => state.copyWith(state: presidentsStates.ErrorCrete, message: mapFailureToMessage(l)),
            (r) {
     final list=List.of(state.presidents)..insert(1,r);
      return state.copyWith(state: presidentsStates.Changed, message: Added_Successfully,presidents: list);});
  }











  PresidentsState _UpdateOrFailure(PresidentsState state, Either<Failure, President> result,) {
    return result.fold((l) => state.copyWith(state: presidentsStates.ErrorCrete, message: mapFailureToMessage(l)),
            (r) {
      //index of the item to be updated
      final index=state.presidents.indexWhere((element) => element.id==r.id);
      final list=List.of(state.presidents)..removeWhere((element) => element.id==r.id);
      list.insert(index, r);


      return state.copyWith(state: presidentsStates.Changed, message: Added_Successfully,presidents: list);});
  } PresidentsState _DeleteOrFailure(PresidentsState state, Either<Failure, Unit> result,String id ) {
    return result.fold((l) => state.copyWith(state: presidentsStates.Error, message: mapFailureToMessage(l)),
            (r) {
final list =List.of(state.presidents)..removeWhere((element) => element.id==id);
    return   state.copyWith(state: presidentsStates.Changed,presidents: list,message: Deleted_Successfully);


    });
  }
}
