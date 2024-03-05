import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/usescases/usecase.dart';
import '../../../domain/entities/Member.dart';
import '../../../domain/usecases/authusecase.dart';

part 'members_event.dart';
part 'members_state.dart';

class MembersBloc extends Bloc<MembersEvent, MembersState> {
  final GetAllMembersUseCase getAllMembersUseCase;
  final GetMemberByname getMemberByNameUseCase;

  MembersBloc(this.getAllMembersUseCase, this.getMemberByNameUseCase) : super(MembersInitial()) {
    on<MembersEvent>((event, emit) {
      // TODO: implement event handler
    });


    on<GetAllMembersEvent>(_getAllMembers);
    on<GetMemberByNameEvent>(_getMemberByName);
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
  } MembersState _eitherDoneLoadedMemberState(
      Either<Failure, List<Member>> either, String message) {
    return either.fold(
          (failure) =>

              MemberFailure(
        message: mapFailureToMessage(failure),

      ),
          (act) => MemberByNameLoadedState(members:act ),
    );
  }

}
