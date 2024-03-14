import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/Team.dart';
import '../../../domain/usecases/TeamUseCases.dart';

part 'team_actions_event.dart';
part 'team_actions_state.dart';


class TeamActionsBloc extends Bloc<TeamActionsEvent, TeamActionsState> {
  final AddTeamUseCase addTeamUseCase;
  final UpdateTeamUseCase updateTeamUseCase;
  final DeleteTeamUseCase deleteTeamUseCase;
  TeamActionsBloc(this.addTeamUseCase, this.updateTeamUseCase, this.deleteTeamUseCase) : super(TeamActionsInitial()) {
    on<AddTeam>(ACtionEvent);
  }
  void ACtionEvent( event, Emitter<TeamActionsState> emit) async {



        try {
          final result = await addTeamUseCase(event.team);
          emit(_mapFailureOrAddedToState(result));
        } catch (error) {
      emit( ErrorMessage(message: "An error occurred"));
        }

  }
  TeamActionsState _mapFailureOrAddedToState(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorMessage(message:mapFailureToMessage(failure), ),
          (act) =>
           TeamAdded(message: "Team Added")
    );
  }
}



