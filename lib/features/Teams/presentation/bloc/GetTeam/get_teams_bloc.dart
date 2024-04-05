import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Teams/domain/usecases/TeamUseCases.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../auth/domain/entities/Member.dart';
import '../../../domain/entities/Team.dart';
import '../../../domain/usecases/TaskUseCase.dart';
import '../../../domain/usecases/TeamUseCases.dart';
import '../../../domain/usecases/TeamUseCases.dart';
import '../../widgets/funct.dart';

part 'get_teams_event.dart';
part 'get_teams_state.dart';

const throttleDuration = Duration(milliseconds: 500);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}
class GetTeamsBloc extends Bloc<GetTeamsEvent, GetTeamsState> {
  final GetAllTeamsUseCase getAllTeamsUseCase;
  final GetTeamByIdUseCase getTeamByIdUseCase;
  final AddTeamUseCase addTeamUseCase;
  final UpdateTeamUseCase updateTeamUseCase;
  final DeleteTeamUseCase deleteTeamUseCase;
  final getTeamByNameUseCase TeamByNameUseCase;
  final UpdateTeamMembersUseCase updateTeamMembersUseCase;
  GetTeamsBloc(this.getAllTeamsUseCase, this.getTeamByIdUseCase, this.addTeamUseCase, this.updateTeamUseCase, this.deleteTeamUseCase, this.TeamByNameUseCase, this.updateTeamMembersUseCase)
      : super(GetTeamsInitial()) {
    on<GetTeams>(onGetTeams,transformer: throttleDroppable(throttleDuration));
   on<GetTeamById>(onGetTeamById);
    on<initStatus>(_initStatus);

    on<AddTeam>(ACtionEvent);
    on<UpdateTeam>(onUpdateTeam);
    on<DeleteTeam>(deleteTeam);
    on<GetTeamByName>(getByname);
    on<UpdateTeamMember>(_updateMember);
  }

void _initStatus(initStatus event, Emitter<GetTeamsState> emit) {
    emit(state.copyWith(status: TeamStatus.IsRefresh));
  }


  void getByname(GetTeamByName event, Emitter<GetTeamsState> emit) async {
    try {
      final result = await TeamByNameUseCase(event.fields);
      emit(_mapFailureOrTeamByNameToState(result));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
  }


  void onUpdateTeam(UpdateTeam event, Emitter<GetTeamsState> emit) async {
    try {
  emit(state.copyWith(status: TeamStatus.initial));
      final result = await updateTeamUseCase(event.team);
      emit(_updateTeamName(result,event.team));
    } catch (error) {
      log("fffff"+error.toString());
      emit(state.copyWith(status: TeamStatus.error, errorMessage: error.toString()));
    }
  }

  void ACtionEvent(AddTeam event, Emitter<GetTeamsState> emit) async {



    try {
      final result = await addTeamUseCase(event.team);
emit(_mapFailureOrAddToState(result));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));

    }

  }




void deleteTeam(DeleteTeam event, Emitter<GetTeamsState> emit) async {
    try {
      final result = await deleteTeamUseCase(event.id);
      emit(_mapFailureOrDeleteToState(result,event.id));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
  }



  Future<void> onGetTeams(GetTeams event, Emitter<GetTeamsState> emit) async {
    log('"ddddyes or no"+${state.status.toString()}');
    if (state.hasReachedMax) return;
    try {
      if (state.status == TeamStatus.initial || state.status == TeamStatus.error|| state.status == TeamStatus.IsRefresh||state.teams.isEmpty) {

      final result = await getAllTeamsUseCase.call(isPrivate: event.isPrivate,updated: event.isUpdated);
      final teams= result.getOrElse(() => []);
      log("teams"+teams.toString());

      final members=teams.isEmpty?[]:teams.map((e) => e.Members).toList();


      final store=await MemberStore.getModel();
      log(members.toString());

      final UpdatedExisted=members.isEmpty?[]:members.map((e) => e.any((element) => element['_id']==store!.id)).toList() ;
      log("store"+store!.firstName);
      log("UpdatedExisted"+UpdatedExisted.toString());
    return emit(state.copyWith(
     status: TeamStatus.success,
     teams: result.getOrElse(() => []),
members: members ,
isExisted: UpdatedExisted ,
          hasReachedMax: false,
   ));}
      log('"ddddyes or no"+${state.status.toString()}');

      final result = await getAllTeamsUseCase.call(page: state.teams.length.toString(), isPrivate: event.isPrivate);
      final teams= result.getOrElse(() => []);
      log("hahah");
      final members=teams.isEmpty?[]:teams.map((e) => e.Members).toList();
      log("hahahsss");

      final UpdatedMembers=List.of(state.members)..addAll(members );
      log("ssshahah");

      final store=await MemberStore.getModel();

      final UpdatedExisted=UpdatedMembers.map((e) => e.any((element) => element['_id']==store!.id)).toList() ;


      emit(result.getOrElse(() => []).isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
        status: TeamStatus.success,
        members: UpdatedMembers,
        isExisted: UpdatedExisted,

        teams: List.of(state.teams)..addAll(result.getOrElse(() => [])),
        hasReachedMax: false,
      ));
    } catch (error) {
      log( error.toString());
      emit(state.copyWith(status: TeamStatus.error));

    }
  }
void _updateMember(UpdateTeamMember event ,Emitter<GetTeamsState> emit) async {
    try {
      final result = await updateTeamMembersUseCase(event.fields);
      final user=await MemberStore.getModel();
      emit(_mapFailureOrUpdateMemberToState(result,event.fields,user!.id));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
  }
  void onGetTeamById(GetTeamById event, Emitter<GetTeamsState> emit) async {
    emit(GetTeamsLoading());
    try {
      final result = await getTeamByIdUseCase(event.fields);
      emit(_mapFailureOrTeamByIdToState(result,emit));


    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error, errorMessage: error.toString()));
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

  GetTeamsState _mapFailureOrTeamByIdToState(Either<Failure, Team> either,Emitter<GetTeamsState> emit) {
    return either.fold(
          (failure) => state.copyWith(status: TeamStatus.error, errorMessage: mapFailureToMessage(failure)),
          (act) {


            return   state.copyWith(teamById: mapTeam(act),status: TeamStatus.success);
  }
    );
  }  GetTeamsState _mapFailureOrTeamByNameToState(Either<Failure, List<Team>> either) {
    return either.fold(
          (failure) => state.copyWith(status: TeamStatus.error, errorMessage: mapFailureToMessage(failure)),

      (act) =>
          state.copyWith(
            teams: act
            ,status: TeamStatus.success
    ));
  }
  GetTeamsState _mapFailureOrAddToState(Either<Failure, Team> either) {
    return either.fold(
            (failure) => state.copyWith(status: TeamStatus.error, errorMessage: mapFailureToMessage(failure)),
            (act) => state.copyWith(
            teams: UnmodifiableListView(
                [act, ...state.teams]
            ),status: TeamStatus.success


        )

    );
  }

  GetTeamsState _mapFailureOrDeleteToState(Either<Failure, Unit> result,String id) {
    return result.fold(
            (failure) => state.copyWith(status: TeamStatus.DeletedError, errorMessage: mapFailureToMessage(failure)),
            (act) => state.copyWith(
            teams: UnmodifiableListView(
                state.teams.where((element) => element.id != id)
            ),status: TeamStatus.Deleted
        )

    );
  }
  GetTeamsState _updateTeamName(Either<Failure, Unit> either, Team team) {
    return either.fold(
          (failure) {
            log(failure.toString());
            return state.copyWith(status: TeamStatus.error, errorMessage: mapFailureToMessage(failure));}
          ,(act) {

    return state.copyWith(status: TeamStatus.success);
  });
  }

  GetTeamsState _mapFailureOrUpdateMemberToState(Either<Failure, Unit> result, Map<String,String> field,String id)  {
    return result.fold(
            (failure) => state.copyWith(status: TeamStatus.error, errorMessage: mapFailureToMessage(failure)),
            (act) {
              if (field['Status']=="add") {
                List<Map<String, dynamic>> updatedMember = List.from(
                    state.teamById['Members']);
                updatedMember.add(field);
                state.teamById['Members'] = updatedMember;
              }
              else if (field['Status']=="kick") {
                List<Map<String, dynamic>> updatedMember = RemoveMember(field['memberid']!);
                state.teamById['Members'] = updatedMember;
              }
              else  {

                List<Map<String, dynamic>> updatedMember = RemoveMember(id);

                state.teamById['Members'] = updatedMember;
              }

              return state.copyWith(status: TeamStatus.success, teamById: state.teamById);
            }
    );
  }

  List<Map<String, dynamic>> RemoveMember(String id) {
    List<Map<String, dynamic>> updatedMember = List.from(
        state.teamById['Members']);
    updatedMember.removeWhere((element) => element['_id'] == id);
    return updatedMember;
  }
}


