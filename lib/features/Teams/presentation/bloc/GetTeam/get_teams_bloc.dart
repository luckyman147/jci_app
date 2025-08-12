import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Teams/domain/entities/TeamUser.dart';

import 'package:jci_app/features/Teams/domain/usecases/TeamUseCases.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/Member.dart';
import '../../../domain/entities/Team/Team.dart';

import '../../../domain/entities/Team/TeamMembers.dart';
import '../../utils/TeamUtils.dart';

import 'package:logger/logger.dart';
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
  final GetTeamsOfUserUseCase getTeamsOfUserUseCase;
  final DeleteTeamUseCase deleteTeamUseCase;
  final InviteMemberUseCase inviteMemberUseCase;
  final getTeamByNameUseCase TeamByNameUseCase;
  final MemberStore memberStore;
  final UpdateTeamMembersUseCase updateTeamMembersUseCase;
  final JoinTeamUseCase joinTeamUseCase;
  GetTeamsBloc(
      this.getAllTeamsUseCase,
      this.getTeamByIdUseCase,
      this.addTeamUseCase,
      this.getTeamsOfUserUseCase,
      this.updateTeamUseCase,
      this.deleteTeamUseCase,
      this.TeamByNameUseCase,
      this.updateTeamMembersUseCase,
      this.inviteMemberUseCase,
      this.joinTeamUseCase,
      this.memberStore)
      : super(GetTeamsInitial()) {
    on<GetTeams>(onGetTeams, transformer: throttleDroppable(throttleDuration));
    on<GetMoreTeams>(onGetMoreTeams, transformer: throttleDroppable(throttleDuration));
    on<GetTeamById>(onGetTeamById);
    on<initStatus>(_initStatus);
on<GetTeamsOfuser> (_getteamsofuser);
    on<AddTeam>(ACtionEvent);
    on<UpdateTeam>(onUpdateTeam);
    on<DeleteTeam>(deleteTeam);
    on<GetTeamByName>(getByname);
    on<UpdateTeamMember>(_updateMember);
    on<InviteMembers>(_inviteMember);
    on<JoinTeam>(_joinTeam);
  }
void  _getteamsofuser ( GetTeamsOfuser event,Emitter<GetTeamsState> emit) async {
    try {
      emit(state.copyWith(status: TeamStatus.Loading));
      final result = await getTeamsOfUserUseCase(NoParams());
      emit(_mapFailureOrTeamOfUserToState(result));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
  }
  void _joinTeam(JoinTeam event, Emitter<GetTeamsState> emit) async {
    try {
      emit (state.copyWith(status: TeamStatus.LoadingJoin));
      final result = await joinTeamUseCase(event.inputs);
      emit(_mapFailureOrJoinTeamToState(result,fields: TeamStatus.Created));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
  }

  void _inviteMember(InviteMembers event, Emitter<GetTeamsState> emit) async {
    try {
      final result = await inviteMemberUseCase(event.teamfi);
      emit(_mapFailureOrInviteMemberToState(result, event.teamfi));
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
      emit(_updateTeamName(result, event.team));
    } catch (error) {
      log("fffff$error");
      emit(state.copyWith(
          status: TeamStatus.error, errorMessage: error.toString()));
    }
  }

  void ACtionEvent(AddTeam event, Emitter<GetTeamsState> emit) async {
    try {
      emit(state.copyWith(status: TeamStatus.Loading));
      final store = await memberStore.getModel();
      var team = event.team;
      if  (!event.team.members.members.any((element) => element.user.id == store!.id)) {
      final teamuser=TeamUser(store!,role: UserTeamRole.canModify);
        team = event.team.copyWith(
          members: TeamMembers(
            membersIds: [...event.team.members.membersIds, teamuser.user.id!],
            teamLeader: store,
            members: [...event.team.members.members, teamuser],
          ),
        );

      }
      final result = await addTeamUseCase(team);
      emit(_mapFailureOrAddToState(result));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
  }

  void deleteTeam(DeleteTeam event, Emitter<GetTeamsState> emit) async {
    try {
      final result = await deleteTeamUseCase(event.id);
      emit(_mapFailureOrDeleteToState(result, event.id));
    } catch (error) {
      emit(state.copyWith(status: TeamStatus.error));
    }
  }




  Future<void> onGetMoreTeams(GetMoreTeams event, Emitter<GetTeamsState> emit) async {
    if (state.hasReachedMax || state.status == TeamStatus.Loading) return;

    try {
      emit(state.copyWith(status: TeamStatus.Loading));

      final result = await getAllTeamsUseCase.call(
        isPrivate: event.isPrivate,
        limit: 10,
        doc: state.lastDocument, // Use last document for pagination
      );

      final res = result.getOrElse(() => (Teams: [], lastDoc: null));
      final newTeams = res.Teams;

      if (newTeams.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, status: TeamStatus.success));
        return;
      }

      final newMembers = newTeams.map((e) => e.members.members).toList();
      final store = await memberStore.getModel();

      final updatedMembers = List.of(state.members)..addAll(newMembers);
      final updatedTeams = List.of(state.teams)..addAll(newTeams);
      final updatedExisted = updatedMembers
          .map((e) => e.any((element) => element['_id'] == store!.id))
          .toList();

      emit(state.copyWith(
        status: TeamStatus.LoadedTeams,
        teams: updatedTeams,
        members: updatedMembers,
        isExisted: updatedExisted,
        lastDocument: res.lastDoc,
        hasReachedMax: false,
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: TeamStatus.error));
    }
  }







  Future<void> onGetTeams(GetTeams event, Emitter<GetTeamsState> emit) async {
    try {
      if ([TeamStatus.LoadedTeam].contains(state.status) && state.teams.isNotEmpty  )
        {
          emit (state.copyWith(status: TeamStatus.LoadedTeams));
        }
      else {
      emit(state.copyWith(status: TeamStatus.Loading, hasReachedMax: false));

      final result = await getAllTeamsUseCase.call(
        isPrivate: event.isPrivate,
        limit: 10,
        doc: null, // Reset pagination
      );

      final res = result.getOrElse(() => (Teams: [], lastDoc: null));

      final teams = res.Teams;

      final members = teams.map((e) => e.members.members).toList();

      final store = await memberStore.getModel();

      final isExisted = (members.isEmpty || store == null)
          ? []
          : members.map((e) => e.any((element) => element.user.id == store.id)).toList();
      emit(state.copyWith(
        status: TeamStatus.LoadedTeams,
        teams: teams,
        members: members,
        isExisted: isExisted,
        lastDocument: res.lastDoc,
        hasReachedMax: teams.isEmpty,
      ));}
    } catch (error) {
      Logger().e(error.toString());
      emit(state.copyWith(status: TeamStatus.error));
    }
  }


  void _updateMember(
      UpdateTeamMember event, Emitter<GetTeamsState> emit) async {
    try {
      final result = await updateTeamMembersUseCase(event.fields);

      emit(_mapFailureOrUpdateMemberToState(result, event.fields));
    } catch (error) {
      log(error.toString());

      emit(state.copyWith(status: TeamStatus.error));
    }
  }

  void onGetTeamById(GetTeamById event, Emitter<GetTeamsState> emit) async {
    emit(state.copyWith(status: TeamStatus.Loading));
    try {
      final result = await getTeamByIdUseCase(event.fields);
      emit(_mapFailureOrTeamByIdToState(result, emit));
    } catch (error) {
      emit(state.copyWith(
          status: TeamStatus.error, errorMessage: error.toString()));
    }
  }



  GetTeamsState _mapFailureOrTeamByIdToState(
      Either<Failure, Team> either, Emitter<GetTeamsState> emit) {
    return either.fold(
        (failure) => state.copyWith(
            status: TeamStatus.error,
            errorMessage: mapFailureToMessage(failure)), (act) {

      return state.copyWith(
          teamById: act, status: TeamStatus.LoadedTeam);
    });
  }

  GetTeamsState _mapFailureOrTeamByNameToState(
      Either<Failure, List<Team>> either) {
    return either.fold(
        (failure) => state.copyWith(
            status: TeamStatus.error,
            errorMessage: mapFailureToMessage(failure)),
        (act) => state.copyWith(teams: act, status: TeamStatus.LoadedTeams));
  }
  GetTeamsState _mapFailureOrTeamOfUserToState(
      Either<Failure, List<Team>> either) {
    return either.fold(
        (failure) => state.copyWith(
            status: TeamStatus.error,
            errorMessage: mapFailureToMessage(failure)),
        (act) => state.copyWith(homeTeams: act, status: TeamStatus.LoadedTeams ));
  }

  GetTeamsState _mapFailureOrAddToState(Either<Failure, Team> either) {
    return either.fold(
        (failure) => state.copyWith(
            status: TeamStatus.error,
            errorMessage: mapFailureToMessage(failure)),
        (act) => state.copyWith(
            status: TeamStatus.Created,
            // insert in the beginning of the list

            teams: UnmodifiableListView([act, ...state.teams])));
  }

  GetTeamsState _mapFailureOrDeleteToState(
      Either<Failure, Unit> result, String id) {
    return result.fold(
        (failure) => state.copyWith(
            status: TeamStatus.DeletedError,
            errorMessage: mapFailureToMessage(failure)),
        (act) => state.copyWith(
            teams: UnmodifiableListView(
                state.teams.where((element) => element.meta.id != id)),
            status: TeamStatus.Deleted));
  }

  GetTeamsState _updateTeamName(Either<Failure, Unit> either, Team team) {
    return either.fold((failure) {
      log(failure.toString());
      return state.copyWith(
          status: TeamStatus.error, errorMessage: mapFailureToMessage(failure));
    }, (act) {
      return state.copyWith(status: TeamStatus.success);
    });
  }

  GetTeamsState _mapFailureOrUpdateMemberToState(
    Either<Failure, Unit> result,
    TeamInput field,
  ) {
    return result.fold(
        (failure) => state.copyWith(
            status: TeamStatus.error,
            errorMessage: mapFailureToMessage(failure)), (act) {
      if (field.Status == "add") {
        List<TeamUser> updatedMember =
            List.from(state.teamById!.members.members);
        updatedMember.add(field.member!);
        state.teamById!.members.copyWith(members:updatedMember);
      } else {
        List<TeamUser> updatedMember =
            RemoveMember(field.memberid!);

        state.teamById!.members.copyWith(members: updatedMember);

      }

      return state.copyWith(
          status: state.status == TeamStatus.IsRefresh
              ? TeamStatus.success
              : TeamStatus.IsRefresh,
          teamById: state.teamById);
    });
  }

  List<TeamUser> RemoveMember(String id) {
    List<TeamUser> updatedMember =
        List.from(state.teamById!.members.members);
    updatedMember.removeWhere((element) => element.user.id == id);
    return updatedMember;
  }

  GetTeamsState _mapFailureOrInviteMemberToState(
      Either<Failure, Unit> result, TeamInput fields) {
    return result.fold(
        (failure) => state.copyWith(
            status: TeamStatus.error,
            errorMessage: mapFailureToMessage(failure)), (act) {
      List<TeamUser> updatedMember =
          List.from(state.teamById!.members.members);
      updatedMember.add(fields.member!);
      state.teamById!.members.copyWith(members: updatedMember);
      return state.copyWith(
          status: state.status == TeamStatus.IsRefresh
              ? TeamStatus.Updated
              : TeamStatus.Updated);
    });
  }

  GetTeamsState _mapFailureOrJoinTeamToState(Either<Failure, Unit> result,{TeamStatus? fields}) {
    return result.fold(
        (failure) => state.copyWith(
            status: TeamStatus.error,
            errorMessage: mapFailureToMessage(failure)),
        (act) => state.copyWith(
            status:fields ?? (state.status == TeamStatus.IsRefresh
                ? TeamStatus.Updated
                : TeamStatus.IsRefresh)));
  }
}
