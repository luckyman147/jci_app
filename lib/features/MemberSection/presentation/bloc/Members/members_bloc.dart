

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/usescases/usecase.dart';
import '../../../../auth/domain/entities/Member.dart';
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
  MembersBloc(this.getAllMembersUseCase, this.getMemberByNameUseCase, this.getUserProfileUseCase, this.updateMemberUseCase, this.getMemberByIdUseCase, this.getMembersByRanksUseCases, this.getMembeWithHighestRankUseCase, ) : super(MembersInitial()) {
    on<MembersEvent>((event, emit) {
      // TODO: implement event handler
    });

on<GetUserProfileEvent>(getUserPrfile);
    on<GetAllMembersEvent>(_getAllMembers);

    on<GetMemberByNameEvent>(_getMemberByName);
    on<UpdateMemberProfileEvent>(_updateuser);
    on<GetMemberByIdEvent>(getMemberByid);
    on<getRanksOfMembers>(getMembersByRanks);
    on<GetMemberByHighestRAnkEvent>(_getMemberByRanks);

  }
  void getMembersByRanks(getRanksOfMembers event, Emitter<MembersState> emit)async{

    try {
      emit(state.copyWith(userStatus: UserStatus.Loading));
      final result= await getMembersByRanksUseCases(event.isUpdated);
      emit(_eitherRanksOrFailure(
          result));
    } on Exception catch (e) {
       emit(state.copyWith(Errormessage: 'Failed to load ranks',userStatus: UserStatus.Error));
      // TODO
    }
  }
  void _getMemberByRanks(GetMemberByHighestRAnkEvent event, Emitter<MembersState> emit)async{

    try {
      emit(state.copyWith(userStatus: UserStatus.Loading));
      final result= await getMembeWithHighestRankUseCase(event.isUpdated);
      emit(_eitherRankOrFailure(
          result));
    } on Exception catch (e) {
       emit(state.copyWith(Errormessage: 'Failed to load ranks',userStatus: UserStatus.Error));
      // TODO
    }
  }

void _updateuser(UpdateMemberProfileEvent event ,Emitter<MembersState> emit)async{
  emit(state.copyWith(userStatus: UserStatus.Loading));

  try {
      final result = await updateMemberUseCase(event.member);
      emit(_eitherDoneUpdatedMemberState(
          result, 'User Profile Updated Successfully'));
    } catch (e) {
      emit(state.copyWith(Errormessage: 'Failed to update user profile',userStatus: UserStatus.Error));
    }
}
void getMemberByid(GetMemberByIdEvent event, Emitter<MembersState> emit)async{
    emit(state.copyWith(userStatus: UserStatus.Loading));
    final result= await getMemberByIdUseCase(event.para);
    emit(_eitherDoneUserState(
        result, 'User Profile Loaded Successfully'));
  }

void getUserPrfile(GetUserProfileEvent event, Emitter<MembersState> emit)async {
  emit(state.copyWith(userStatus: UserStatus.Loading));

    final result= await getUserProfileUseCase(event.isUpdated );
    emit(_eitherDoneUserState(
        result, 'User Profile Loaded Successfully'));
  }

  void _getAllMembers(
      GetAllMembersEvent event,
      Emitter<MembersState> emit,
      ) async {
    emit(state.copyWith(userStatus: UserStatus.Loading));

    final result = await getAllMembersUseCase.call(event.isUpdated);
    emit(_eitherDoneLoadedState(
        result, 'All Members Loaded Successfully'));
  }
  void _getMemberByName(
      GetMemberByNameEvent event,
      Emitter<MembersState> emit,
      ) async {
    emit(state.copyWith(userStatus: UserStatus.Loading));

    if(event.name.isEmpty){
      emit(state.copyWith(userStatus: UserStatus.Error));

      add(GetAllMembersEvent(true));

    }
    final result = await getMemberByNameUseCase.call(event.name);
    emit(_eitherDoneLoadedMemberState(
        result, 'All Members Loaded Successfully'));
  }

  MembersState _eitherDoneLoadedState(
      Either<Failure, List<Member>> either, String message) {
    return either.fold(
          (failure) =>

              state.copyWith(
        Errormessage: mapFailureToMessage(failure),

      ),
          (act) => state.copyWith(members:act,userStatus: UserStatus.MembersLoaded,memberByName: act ),
    );
  }
   MembersState _eitherDoneUserState(
      Either<Failure, Member> either, String message) {
    return either.fold(
          (failure) =>

              state.copyWith(
                Errormessage: mapFailureToMessage(failure),userStatus: UserStatus.Error,


              ),
          (act) => state.copyWith(user:act,userStatus: UserStatus.userLoaded),
    );
  }





  MembersState _eitherDoneLoadedMemberState(
      Either<Failure, List<Member>> either, String message) {
    return either.fold(
          (failure) =>

              state.copyWith(
                Errormessage: mapFailureToMessage(failure),

              ),
          (act) => state.copyWith(userStatus: UserStatus.MemberByname,memberByName: act ),
    );
  }  MembersState _eitherDoneUpdatedMemberState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
          (failure) =>

              state.copyWith(
                Errormessage: mapFailureToMessage(failure),

              ),
          (act) => state.copyWith(userStatus: UserStatus.Updated),
    );
  }

  MembersState _eitherRanksOrFailure(Either<Failure, List<Member>> result) {
    return result.fold(
          (failure) => state.copyWith(
        Errormessage: mapFailureToMessage(failure),
            userStatus: UserStatus.ErrorMembers,
      ),
          (act) => state.copyWith(userStatus: UserStatus.MembersRanksLoaded, membersWithRanks: act,memberWithRank: act.first),
    );
  }

  MembersState _eitherRankOrFailure(Either<Failure, Member> result) {
    return result.fold(
          (failure) => state.copyWith(
        Errormessage: mapFailureToMessage(failure),
            userStatus: UserStatus.ErrorMembers,
      ),
          (act) => state.copyWith(userStatus: UserStatus.MembersRanksLoaded,memberWithRank: act),
    );
  }

}
