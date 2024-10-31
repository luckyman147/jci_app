
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/usescases/usecase.dart';

import '../../../../../core/error/Failure.dart';
import '../../../domain/usecases/authusecase.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc(this.isNewMemberUseCase) : super(PermissionsInitial()) {
    on<PermissionsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<CheckPermissionsEvent>(onPermissionsEvent);
  }
  final IsNewMemberUseCase isNewMemberUseCase;

  void onPermissionsEvent(CheckPermissionsEvent event, Emitter<PermissionsState> emit) async{
    final isNewMember = await isNewMemberUseCase(NoParams());
    emit(_eitherNewMemberOrErrorState(isNewMember));


  }
  PermissionsState _eitherNewMemberOrErrorState(
      Either<Failure, bool> failureOrNewMember) {
    return failureOrNewMember.fold(
      (failure) => state.copyWith(
        IsNewMember: true,
        status: PermStatus.NewMember,
      ),
      (isNewMember) {
        if (isNewMember) {
          return state.copyWith(
            IsNewMember: true,
            status: PermStatus.NewMember,
          );
        } else {
          return state.copyWith(
            IsNewMember: false,
            status: PermStatus.Other,
          );
        }

      },
    );
  }
}
