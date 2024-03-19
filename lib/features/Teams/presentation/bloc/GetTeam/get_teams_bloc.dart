import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Teams/domain/usecases/TeamUseCases.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/Team.dart';
import '../../../domain/usecases/TaskUseCase.dart';

part 'get_teams_event.dart';
part 'get_teams_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}
class GetTeamsBloc extends Bloc<GetTeamsEvent, GetTeamsState> {
  final GetAllTeamsUseCase getAllTeamsUseCase;
  final GetTeamByIdUseCase getTeamByIdUseCase;

  GetTeamsBloc(this.getAllTeamsUseCase, this.getTeamByIdUseCase)
      : super(GetTeamsInitial()) {
    on<GetTeams>(onGetTeams,transformer: throttleDroppable(throttleDuration));
   on<GetTeamById>(onGetTeamById);


  }
  Future<void> onGetTeams(GetTeams event, Emitter<GetTeamsState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == TeamStatus.initial) {
      final result = await getAllTeamsUseCase.call();
   return emit(state.copyWith(
     status: TeamStatus.success,
     teams: result.getOrElse(() => []),
     hasReachedMax: false,
   ));}
      final result = await getAllTeamsUseCase.call(page: state.teams.length.toString());
      emit(result.getOrElse(() => []).isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
        status: TeamStatus.success,
        teams: List.of(state.teams)..addAll(result.getOrElse(() => [])),
        hasReachedMax: false,
      ));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
  }

  void onGetTeamById(GetTeamById event, Emitter<GetTeamsState> emit) async {
    emit(GetTeamsLoading());
    try {
      final result = await getTeamByIdUseCase(event.id);
      emit(_mapFailureOrTeamByIdToState(result));
    } catch (error) {
      emit(GetTeamsError('An error occurred'));
    }
  }
  GetTeamsState _mapFailureOrTeamToState(Either<Failure, List<Team>> either) {
    return either.fold(
          (failure) => GetTeamsError(mapFailureToMessage(failure)),
          (act) =>
          GetTeamsLoaded(
            act,
          ),
    );
  }

  GetTeamsState _mapFailureOrTeamByIdToState(Either<Failure, Team> either) {
    return either.fold(
          (failure) => GetTeamsError(mapFailureToMessage(failure)),
          (act) =>
          GetTeamsLoadedByid(
            act,
          ),
    );
  }
}


