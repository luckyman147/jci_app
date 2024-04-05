import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Home/presentation/widgets/MemberSelection.dart';

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

  MembersBloc(this.getAllMembersUseCase, this.getMemberByNameUseCase, this.getUserProfileUseCase, this.updateMemberUseCase) : super(MembersInitial()) {
    on<MembersEvent>((event, emit) {
      // TODO: implement event handler
    });

on<GetUserProfileEvent>(getUserPrfile);
    on<GetAllMembersEvent>(_getAllMembers);
    on<GetMemberByNameEvent>(_getMemberByName);
    on<UpdateMemberProfileEvent>(_updateuser);
  }
void _updateuser(UpdateMemberProfileEvent event ,Emitter<MembersState> emit)async{
    emit(MemberLoading());
    try {
      final result = await updateMemberUseCase(event.member);
      emit(_eitherDoneUpdatedMemberState(
          result, 'User Profile Updated Successfully'));
    } catch (e) {
      emit(MemberFailure(message: 'Failed to update user profile'));
    }
}

void getUserPrfile(GetUserProfileEvent event, Emitter<MembersState> emit)async {
    emit(MemberLoading());
    final result= await getUserProfileUseCase(event.isUpdated );
    emit(_eitherDoneUserState(
        result, 'User Profile Loaded Successfully'));
  }

  void _getAllMembers(
      GetAllMembersEvent event,
      Emitter<MembersState> emit,
      ) async {
    emit(MemberLoading());
    final result = await getAllMembersUseCase.call(NoParams());
    emit(_eitherDoneLoadedState(
        result, 'All Members Loaded Successfully'));
  }
  void _getMemberByName(
      GetMemberByNameEvent event,
      Emitter<MembersState> emit,
      ) async {
    emit(MemberLoading());
    if(event.name.isEmpty){
      emit(MemberFailure(message: 'Name cannot be empty'));
      add(GetAllMembersEvent());

    }
    final result = await getMemberByNameUseCase.call(event.name);
    emit(_eitherDoneLoadedMemberState(
        result, 'All Members Loaded Successfully'));
  }

  MembersState _eitherDoneLoadedState(
      Either<Failure, List<Member>> either, String message) {
    return either.fold(
          (failure) =>

              MemberFailure(
        message: mapFailureToMessage(failure),

      ),
          (act) => AllMembersLoadedState(members:act ),
    );
  }
   MembersState _eitherDoneUserState(
      Either<Failure, Member> either, String message) {
    return either.fold(
          (failure) =>

              MemberFailure(
        message:failure.toString(),

      ),
          (act) => UserLoaded(user:act ),
    );
  }





  MembersState _eitherDoneLoadedMemberState(
      Either<Failure, List<Member>> either, String message) {
    return either.fold(
          (failure) =>

              MemberFailure(
        message: mapFailureToMessage(failure),

      ),
          (act) => MemberByNameLoadedState(members:act ),
    );
  }  MembersState _eitherDoneUpdatedMemberState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
          (failure) =>

              MemberFailure(
        message: failure.toString()

      ),
          (act) => MemberUpdated( ),
    );
  }

}
