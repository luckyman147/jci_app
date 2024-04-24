import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';

import '../../../../../../core/error/Failure.dart';
import '../../../../../../core/usescases/usecase.dart';
import '../../../../Domain/entities/BoardRole.dart';
import '../../../../Domain/useCases/BoardUseCases.dart';
import '../BoardBloc/boord_bloc.dart';

part 'years_event.dart';
part 'years_state.dart';

class YearsBloc extends Bloc<YearsEvent, YearsState> {
  final getYearsUseCase getYears;
  final getBoardRolesUseCase getBoardRoles;
  final AddPositionUseCase addPositionUseCase;
final RemovePositionUseCase removePositionUseCase;

  YearsBloc(this.getYears, this.getBoardRoles, this.addPositionUseCase, this.removePositionUseCase) : super(YearsInitial()) {
    on<GerBoardYearsEvent>(getYearsEvent);
    on<ChangeBoardYears>(_ChangeBoardYea);
    on<AddYear>(_addYearsEvent);
    on<ChangeCloneYear>(_changecolone);
    on<RemoveYear>(_onRemoveYearEvent);
    on<GetBoardRolesEvent>(_onGetBoardRolesEvent);
    on<AddPosition>(_AddPosition);
    on<RemovePosition>(_RemovePosition);

    on<ChangeRoleEvent>(ChangeRole);

    on<YearsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }


  void ChangeRole(ChangeRoleEvent event,Emitter<YearsState> emit){
    // Create a new map based on the current newRole
    Map<String, dynamic> updatedNewRole = Map.from(state.newrole);

    // Update the value associated with the specific key
    updatedNewRole['role'] = event.role;

    // Create a new state with updated newRole
    YearsState newState = state.copyWith(newrole: updatedNewRole,);

    // Emit the new state
    emit(newState);
  }





  void _onRemoveYearEvent(RemoveYear event,Emitter<YearsState> emit) async {
    try {
      final years=List.of(state.years);
      years.removeWhere((element) => element==event.year);
      emit(state.copyWith(state: yearsStates.Loaded,years: years,));
      emit(state.copyWith(year: state.years[0],));

    } on Exception catch (e) {
      // TODO
    }
  }
  void _AddPosition(AddPosition event,Emitter<YearsState> emit) async {
    try {
      emit(state.copyWith(state: yearsStates.Loading));
      final result = await addPositionUseCase(event.postField);
      _mapAddPositionorFailure(result, emit);
    } on Exception catch (e) {
      // TODO
    }
  }  void _RemovePosition(RemovePosition event,Emitter<YearsState> emit) async {
    try {
      emit(state.copyWith(state: yearsStates.Loading));
      final result = await removePositionUseCase(event.post);
      _mapRemovePositionorFailure(result, emit);
    } on Exception catch (e) {
      // TODO
    }
  }

  void getYearsEvent(GerBoardYearsEvent event,Emitter<YearsState> emit) async {

    try {
      emit(state.copyWith(state: yearsStates.Loading));
      final result = await getYears(NoParams());
      _mapGetorFailure(result, emit);
    } on Exception catch (e) {
      // TODO
    }

  }
  void _ChangeBoardYea(ChangeBoardYears event,Emitter<YearsState> emit) async {
    emit(state.copyWith(state: yearsStates.Changed,year: event.year));
  }

  void _addYearsEvent(AddYear event,Emitter<YearsState> emit) async {
    try {

     final finalList=JCIFunctions.insertSorted(state.years, event.year);
      emit(state.copyWith(state: yearsStates.Loaded,years: finalList,year: event.year));

    } on Exception catch (e) {
      // TODO
    }
  }
  void _changecolone(ChangeCloneYear event,Emitter<YearsState> emit) async {
    emit(state.copyWith(cloneyear: event.year));
  }
  void _onGetBoardRolesEvent(GetBoardRolesEvent event,Emitter<YearsState> emit) async {
    try {

      final result = await getBoardRoles(event.priority);
      _mapGetBoardRolesorFailure(result, emit);
    } on Exception catch (e) {
      emit( state.copyWith(state: yearsStates.ErrorRole,message: e.toString()));
      // TODO
    }
  }



  void _mapGetorFailure(Either<Failure,List<String> > result,Emitter<YearsState> emit) {
    return result.fold((l) => emit( state.copyWith(state: yearsStates.Error,message: mapFailureToMessage(l))),


            (r) {
    emit(  state.copyWith(state: yearsStates.Loaded,years: r,year:  state.years.isEmpty?r.first:state.year));

            });
  }

  void _mapGetBoardRolesorFailure(Either<Failure, List<BoardRole>> result, Emitter<YearsState> emit) {
    return result.fold((l) => emit(state.copyWith(state: yearsStates.ErrorRole,message: mapFailureToMessage(l))),
            (r) {
              Map<String, dynamic> updatedNewRole = Map.from(state.newrole);

              // Update the value associated with the specific key
              updatedNewRole['role'] =r[0];

      emit(state.copyWith(state: yearsStates.Roles,roles: r,newrole:updatedNewRole ));});
  }

  void _mapAddPositionorFailure(Either<Failure, Unit> result, Emitter<YearsState> emit) {
    return result.fold((l) => emit(state.copyWith(state: yearsStates.ErrorChanged,message: mapFailureToMessage(l))),
            (r) {
      emit(state.copyWith(state: yearsStates.ChangedPosition,message: "Position Added Successfully"));
    });
  } void _mapRemovePositionorFailure(Either<Failure, Unit> result, Emitter<YearsState> emit) {
    return result.fold((l) => emit(state.copyWith(state: yearsStates.ErrorChanged,message: mapFailureToMessage(l))),
            (r) {
      emit(state.copyWith(state: yearsStates.ChangedPosition,message: "Position Removed Successfully"));
    });
  }
}
