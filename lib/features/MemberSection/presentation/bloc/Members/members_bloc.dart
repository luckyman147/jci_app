import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/config/services/store.dart';

import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/Member.dart';
import '../../../domain/usecases/MemberUseCases.dart';

part 'members_event.dart';
part 'members_state.dart';

class MembersBloc extends Bloc<MembersEvent, MembersState> {
  final GetAllMembersUseCase getAllMembersUseCase;
  final GetMemberByname getMemberByNameUseCase;
  final GetUserProfile getUserProfileUseCase;
  final UpdateMemberUseCase updateMemberUseCase;
  final GetMemberByIdUseCase getMemberByIdUseCase;
  final GetMembersByRanksUseCases getMembersByRanksUseCases;
  final GetMemberByRankUseCase getMembeWithHighestRankUseCase;
final Store store;
  MembersBloc({
    required this.store,
    required this.getAllMembersUseCase,
    required this.getMemberByNameUseCase,
    required this.getUserProfileUseCase,
    required this.updateMemberUseCase,
    required this.getMemberByIdUseCase,
    required this.getMembersByRanksUseCases,
    required this.getMembeWithHighestRankUseCase,
  }) : super(MembersInitial()) {
    on<GetUserProfileEvent>(_handleGetUserProfile);
    on<GetAllMembersEvent>(_handleGetAllMembers);
    on<GetMemberByNameEvent>(_handleGetMemberByName);
    on<UpdateMemberProfileEvent>(_handleUpdateMember);
    on<GetMemberByIdEvent>(_handleGetMemberById);
    on<getRanksOfMembers>(_handleGetMembersByRanks);
    on<GetMemberByHighestRAnkEvent>(_handleGetMemberByHighestRank);
  }

  // Generic handler for all state updates
  MembersState _handleEitherResult<T>({
    required Either<Failure, T> result,
    required Function(T) onSuccess,
    UserStatus successStatus = UserStatus.MembersLoaded,
    UserStatus errorStatus = UserStatus.Error,
    String? successMessage,
  }) {
    return result.fold(
          (failure) => state.copyWith(
        Errormessage: mapFailureToMessage(failure),
        userStatus: errorStatus,
      ),
          (data) => onSuccess(data)
    );
  }

  void _handleGetMembersByRanks(
      getRanksOfMembers event,
      Emitter<MembersState> emit,
      ) async {
    try {
      emit(state.copyWith(userStatus: UserStatus.Loading));
      final result = await getMembersByRanksUseCases(event.isUpdated);
      emit(_handleEitherResult<List<Member>>(
        result: result,
        onSuccess: (members) => state.copyWith(
          membersWithRanks: members,
          memberWithRank: members.isNotEmpty ? members.first : null,
        ),
        successStatus: UserStatus.MembersRanksLoaded,
      ));
    } on Exception {
      emit(state.copyWith(
        Errormessage: 'Failed to load ranks',
        userStatus: UserStatus.Error,
      ));
    }
  }

  void _handleGetMemberByHighestRank(
      GetMemberByHighestRAnkEvent event,
      Emitter<MembersState> emit,
      ) async {
    if (state.memberWithRank != null) {
      emit(state.copyWith(
        userStatus: UserStatus.MembersRanksLoaded,
        memberWithRank: state.memberWithRank,
      ));
      return;
    }

    try {
      emit(state.copyWith(userStatus: UserStatus.Loading));
      final result = await getMembeWithHighestRankUseCase(event.isUpdated);
      emit(_handleEitherResult<Member>(
        result: result,
        onSuccess: (member) => state.copyWith(memberWithRank: member,
        userStatus: UserStatus.MembersRanksLoaded
        ),
        successStatus: UserStatus.MembersRanksLoaded,
      ));
    } on Exception {
      emit(state.copyWith(
        Errormessage: 'Failed to load ranks',
        userStatus: UserStatus.Error,
      ));
    }
  }

  void _handleUpdateMember(
      UpdateMemberProfileEvent event,
      Emitter<MembersState> emit,
      ) async {
    emit(state.copyWith(userStatus: UserStatus.Loading));
    try {
      final result = await updateMemberUseCase(event.member);
      emit(_handleEitherResult<Unit>(
        result: result,
        onSuccess: (_) => state.copyWith(
          userStatus: UserStatus.Updated
        ),
        successStatus: UserStatus.Updated,
        successMessage: 'User Profile Updated Successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        Errormessage: 'Failed to update user profile',
        userStatus: UserStatus.Error,
      ));
    }
  }

  void _handleGetMemberById(
      GetMemberByIdEvent event,
      Emitter<MembersState> emit,
      ) async {
    emit(state.copyWith(userStatus: UserStatus.Loading));
    final result = await getMemberByIdUseCase(event.para);
    emit(_handleEitherResult<Member>(
      result: result,
      onSuccess: (member) => state.copyWith(user: member,

        userStatus: UserStatus.userLoaded

      ),
      successStatus: UserStatus.userLoaded,
      successMessage: 'User Profile Loaded Successfully',
    ));
  }

  void _handleGetUserProfile(
      GetUserProfileEvent event,
      Emitter<MembersState> emit,
      ) async {
final id=await store.getUserId();

    if (!event.isUpdated && state.user != null&& id==state.user!.id) {

      emit(state.copyWith(
        userStatus: UserStatus.userLoaded,
        user: state.user,
      ));
      return;
    }
    emit(state.copyWith(userStatus: UserStatus.Loading));
    final result = await getUserProfileUseCase(event.isUpdated);
    emit(_handleEitherResult<Member>(
      result: result,
      onSuccess: (member) => state.copyWith(user: member,userStatus: UserStatus.userLoaded),
      successStatus: UserStatus.userLoaded,
      successMessage: 'User Profile Loaded Successfully',
    ));
  }

  void _handleGetAllMembers(
      GetAllMembersEvent event,
      Emitter<MembersState> emit,
      ) async {
    if (state.members.isNotEmpty) {
      emit(state.copyWith(
        userStatus: UserStatus.MembersLoaded,
        members: state.members,
      ));
      return;
    }

    emit(state.copyWith(userStatus: UserStatus.Loading));
    final result = await getAllMembersUseCase.call(event.isUpdated);
    final myId=await store.getUserId();
    emit(_handleEitherResult<List<User>>(
      result: result,
      onSuccess: (members) {


        return state.copyWith(
          userStatus:UserStatus.MembersLoaded ,
          members: members.where((user) => user.id != myId).toList(),
          memberByName: members.where((user) => user.id != myId).toList(),
      );
      },

      successMessage: 'All Members Loaded Successfully',
    ));
  }

  void _handleGetMemberByName(
      GetMemberByNameEvent event,
      Emitter<MembersState> emit,
      ) async {
    emit(state.copyWith(userStatus: UserStatus.Loading));

    if (event.name.isEmpty) {
      emit(state.copyWith(userStatus: UserStatus.Error));
      add(const GetAllMembersEvent(true));
      return;
    }

    final result = await getMemberByNameUseCase.call(event.name);
    emit(_handleEitherResult<List<User>>(
      result: result,
      onSuccess: (members) => state.copyWith(memberByName: members,
      userStatus: UserStatus.MemberByname
      ),
      successStatus: UserStatus.MemberByname,
      successMessage: 'Members Loaded Successfully',
    ));
  }
}