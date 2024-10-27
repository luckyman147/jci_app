import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:jci_app/core/config/services/MemberStore.dart';


import 'package:jci_app/features/Teams/domain/usecases/TeamUseCases.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../auth/domain/entities/Member.dart';
import '../../../domain/entities/Team.dart';

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
  final InviteMemberUseCase inviteMemberUseCase;
  final getTeamByNameUseCase TeamByNameUseCase;
  final UpdateTeamMembersUseCase updateTeamMembersUseCase;
  final JoinTeamUseCase joinTeamUseCase;
  GetTeamsBloc(this.getAllTeamsUseCase, this.getTeamByIdUseCase, this.addTeamUseCase, this.updateTeamUseCase, this.deleteTeamUseCase, this.TeamByNameUseCase, this.updateTeamMembersUseCase, this.inviteMemberUseCase, this.joinTeamUseCase)
      : super(GetTeamsInitial()) {
    on<GetTeams>(onGetTeams,transformer: throttleDroppable(throttleDuration));
   on<GetTeamById>(onGetTeamById);
    on<initStatus>(_initStatus);

    on<AddTeam>(ACtionEvent);
    on<UpdateTeam>(onUpdateTeam);
    on<DeleteTeam>(deleteTeam);
    on<GetTeamByName>(getByname);
    on<UpdateTeamMember>(_updateMember);
    on<InviteMembers>(_inviteMember);
    on<JoinTeam>(_joinTeam);
  }

  void _joinTeam(JoinTeam event, Emitter<GetTeamsState> emit) async {
    try {
      final result = await joinTeamUseCase(event.Teamid);
      emit(_mapFailureOrJoinTeamToState(result));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
  }

  void _inviteMember(InviteMembers event, Emitter<GetTeamsState> emit) async {
    try {

      final result = await inviteMemberUseCase(event. teamfi);
      emit(_mapFailureOrInviteMemberToState(result,event.teamfi));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
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

  //  if (state.hasReachedMax ) return;
    try {
      if (state.status == TeamStatus.initial || state.status == TeamStatus.error|| state.status == TeamStatus.IsRefresh||state.teams.isEmpty) {

        if (state.teams.isEmpty) {
          emit(state.copyWith(status: TeamStatus.Loading));
        }

      final result = await getAllTeamsUseCase.call(isPrivate: event.isPrivate,updated: event.isUpdated);
      final teams= result.getOrElse(() => []);

      final members=teams.isEmpty?[]:teams.map((e) => e.Members).toList();


      final store=await MemberStore.getModel();


      final UpdatedExisted=members.isEmpty?[]:members.map((e) => e.any((element) => element['_id']==store!.id)).toList() ;

    return emit(state.copyWith(
     status: TeamStatus.success,
     teams: result.getOrElse(() => []),
members: members ,
isExisted: UpdatedExisted ,
          hasReachedMax: false,
   ));}
      state.copyWith(status: TeamStatus.Loading);
      final result = await getAllTeamsUseCase.call(page: state.teams.length.toString(), isPrivate: event.isPrivate);
      final teams= result.getOrElse(() => []);
      final members=teams.isEmpty?[]:teams.map((e) => e.Members).toList();
      final UpdatedMembers=List.of(state.members)..addAll(members );
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
log(error.toString());
      emit(state.copyWith(status: TeamStatus.error));

    }
  }
void _updateMember(UpdateTeamMember event ,Emitter<GetTeamsState> emit) async {
    try {
      final result = await updateTeamMembersUseCase(event.fields);

      emit(_mapFailureOrUpdateMemberToState(result,event.fields));
    } catch (error) {
      log(error.toString());

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


            return   state.copyWith(teamById: TeamFunction.mapTeam(act),status: TeamStatus.success);
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
           status: TeamStatus.Created,
              // insert in the beginning of the list

                teams: UnmodifiableListView([act,...state.teams])

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

  GetTeamsState _mapFailureOrUpdateMemberToState(Either<Failure, Unit> result, TeamInput field,)  {
    return result.fold(
            (failure) => state.copyWith(status: TeamStatus.error, errorMessage: mapFailureToMessage(failure)),
            (act) {
              if (field.Status=="add") {
                List<Map<String, dynamic>> updatedMember = List.from(
                    state.teamById['Members']);
                updatedMember.add(field.member!);
                state.teamById['Members'] = updatedMember;
              }
              else {

                List<Map<String, dynamic>> updatedMember = RemoveMember(field.memberid!);

                state.teamById['Members'] = updatedMember;
              }


              return state.copyWith(status: state.status == TeamStatus.IsRefresh ?
                  TeamStatus.success : TeamStatus.IsRefresh
                  , teamById: state.teamById);
            }
    );
  }

  List<Map<String, dynamic>> RemoveMember(String id) {
    List<Map<String, dynamic>> updatedMember = List.from(
        state.teamById['Members']);
    updatedMember.removeWhere((element) => Member.toMember(element).id== id);
    return updatedMember;
  }

  GetTeamsState _mapFailureOrInviteMemberToState(Either<Failure, Unit> result,TeamInput fields) {
    return result.fold(
            (failure) => state.copyWith(status: TeamStatus.error, errorMessage: mapFailureToMessage(failure)),
            (act) {
      List<Map<String, dynamic>> updatedMember = List.from(
          state.teamById['Members']);
      updatedMember.add(fields.member!);
      state.teamById['Members'] = updatedMember;
              return  state.copyWith(status:state.status==TeamStatus.IsRefresh? TeamStatus.Updated:TeamStatus.Updated);}
    );
  }

  GetTeamsState _mapFailureOrJoinTeamToState(Either<Failure, Unit> result) {
    return result.fold(
            (failure) => state.copyWith(status: TeamStatus.error, errorMessage: mapFailureToMessage(failure)),
            (act) => state.copyWith(status: state.status==TeamStatus.IsRefresh? TeamStatus.Updated:TeamStatus.IsRefresh)
    );
  }
}


