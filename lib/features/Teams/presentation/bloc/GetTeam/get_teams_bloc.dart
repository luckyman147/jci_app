import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Teams/domain/usecases/TeamUseCases.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/Team.dart';
import '../../../domain/usecases/TaskUseCase.dart';

part 'get_teams_event.dart';
part 'get_teams_state.dart';


class GetTeamsBloc extends Bloc<GetTeamsEvent, GetTeamsState> {
  final GetAllTeamsUseCase getAllTeamsUseCase;
  final GetTeamByIdUseCase getTeamByIdUseCase;

  GetTeamsBloc(this.getAllTeamsUseCase, this.getTeamByIdUseCase)
      : super(GetTeamsInitial()) {
    on<GetTeams>(onGetTeams);
    on<GetTeamById>(onGetTeamById);

  }
  void onGetTeams(GetTeams event, Emitter<GetTeamsState> emit) async {
    


emit(GetTeamsLoading());
        try {

          final result = await getAllTeamsUseCase(NoParams());
          emit(_mapFailureOrTeamToState(result));
        } catch (error) {
          emit(GetTeamsError('An error occurred'));
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



