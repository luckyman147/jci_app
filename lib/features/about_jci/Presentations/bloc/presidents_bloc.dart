import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/features/about_jci/Domain/entities/President.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../../Domain/useCases/PresidentUseCAses.dart';

part 'presidents_event.dart';
part 'presidents_state.dart';

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
    on<GetAllPresidentsEvent>(_onGetAllPresidents);
    on<UpdateImagePresident>(_onUpdateImagePresident);
    on<UpdatePresident>(_onUpdatePresident);
  }
  void _onGetAllPresidents(GetAllPresidentsEvent event,Emitter<PresidentsState> emit)async {
    try {
      emit(state.copyWith(state: presidentsStates.Loading));
      final result = await getPresidentsUseCases(NoParams());
      emit(_getAllOrFailure(state, result));
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
      emit(state.copyWith(state: presidentsStates.Error,message: e.toString()));
    }
  }
  void _onUpdatePresident(UpdatePresident event,Emitter<PresidentsState> emit)async {
    try {
      emit(state.copyWith(state: presidentsStates.Loading));
      final result = await updatePresidentUseCases(event.president);
      emit(_createOrFailure(state, result));

    }
    catch(e){
      emit(state.copyWith(state: presidentsStates.Error,message: e.toString()));
    }
  }
  void _onUpdateImagePresident(UpdateImagePresident event,Emitter<PresidentsState> emit)async {
    try {
      emit(state.copyWith(state: presidentsStates.Loading));
      final result = await updateImagePresidentUseCases(event.president);
      emit(_createOrFailure(state, result));

    }
    catch(e){
      emit(state.copyWith(state: presidentsStates.Error,message: e.toString()));


    }
  }
  void _onDeletePresident(DeletePresident event,Emitter<PresidentsState> emit)async {
    try {
      emit(state.copyWith(state: presidentsStates.Loading));
      final result = await deletePresidentUseCases(event.id);
      emit(_createOrFailure(state, result));

    }
    catch(e){
      emit(state.copyWith(state: presidentsStates.Error,message: e.toString()));
    }
  }
  PresidentsState _getAllOrFailure(PresidentsState state, Either<Failure, List<President>> result) {
    return result.fold((l) => state.copyWith(state: presidentsStates.Error, message: mapFailureToMessage(l)),
            (r) => state.copyWith(state: presidentsStates.Loaded, presidents: r));
  }
  PresidentsState _createOrFailure(PresidentsState state, Either<Failure, Unit> result) {
    return result.fold((l) => state.copyWith(state: presidentsStates.Error, message: mapFailureToMessage(l)),
            (r) => state.copyWith(state: presidentsStates.Changed));
  }
}
