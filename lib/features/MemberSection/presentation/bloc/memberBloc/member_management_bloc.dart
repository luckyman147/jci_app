import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/MemberRepo.dart';

import '../../../../../core/error/Failure.dart';
import '../../../domain/usecases/AdminMembersUsesCase.dart';
import '../../../domain/usecases/MemberUseCases.dart';

part 'member_management_event.dart';
part 'member_management_state.dart';

class MemberManagementBloc extends Bloc<MemberManagementEvent, MemberManagementState> {
  final UpdateCotisationUseCase updateCotisationUseCase;
  final UpdatePointsUseCase updatePointsUseCase;
  final validateMemberuseCase validateMemberUseCase;
  final ChangeLanguageUseCase changeLanguageUseCase;
  final DeleteMemberUseCase deleteMemberUseCase;

  MemberManagementBloc({
    required this.updateCotisationUseCase,
    required this.updatePointsUseCase,
    required this.validateMemberUseCase,
    required this.changeLanguageUseCase,
    required this.deleteMemberUseCase,
  }) : super(MemberManagementInitial()) {
    on<initMemberEvent>(_handleInitMember);
    on<UpdateCotisation>(_handleUpdateCotisation);
    on<UpdatePoints>(_handleUpdatePoints);
    on<validateMember>(_handleValidateMember);
    on<AddPoints>(_handleAddPoints);
    on<RemovePoints>(_handleRemovePoints);
    on<AddCotisation>(_handleAddCotisation);
    on<ChangeLanguageEvent>(_handleChangeLanguage);
    on<deleteMemberEvent>(_handleDeleteMember);
  }

  // Generic handler for all state updates
  Future<void> _handleEitherResult<T>({
    required Either<Failure, Unit> result,
    required Function() onSuccess,
    required Emitter<MemberManagementState> emit,
    String? successMessage,
    TypeResult successType = TypeResult.success,
  }) async {
    result.fold(
          (failure) => emit(state.copyWith(
        typeResult: TypeResult.failed,
        ErrorMessage: mapFailureToMessage(failure),
      )),
          (_) {
        onSuccess();
        emit(state.copyWith(
          typeResult: successType,
          ErrorMessage: successMessage,
          isUpdated: true,
        ));
      },
    );
  }

  void _handleInitMember(initMemberEvent event, Emitter<MemberManagementState> emit) {
    emit(MemberManagementState(
      isUpdated: event.isUpdated,
      cotisation: event.cotisation,
      points: event.points,
      role: event.role,
      clone: event.points,
      objectifs: event.objectifs,
    ));
  }

  void _handleAddPoints(AddPoints event, Emitter<MemberManagementState> emit) {
    emit(state.copyWith(clone: state.clone + 50));
  }

  void _handleRemovePoints(RemovePoints event, Emitter<MemberManagementState> emit) {
    if (state.clone - 50 >= 0) {
      emit(state.copyWith(clone: state.clone - 50));
    }
  }

  void _handleAddCotisation(AddCotisation event, Emitter<MemberManagementState> emit) {
    final newCotisation = List<bool>.from(state.cotisation)..add(false);
    emit(state.copyWith(cotisation: newCotisation));
  }

  Future<void> _handleChangeLanguage(
      ChangeLanguageEvent event,
      Emitter<MemberManagementState> emit,
      ) async {
    await _handleEitherResult(
      result: await changeLanguageUseCase(event.language),
      onSuccess: () {},
      emit: emit,
      successMessage: 'Language Changed Successfully',
    );
  }

  Future<void> _handleUpdateCotisation(
      UpdateCotisation event,
      Emitter<MemberManagementState> emit,
      ) async {
    await _handleEitherResult(
      result: await updateCotisationUseCase(event.updateCotisationParams),
      onSuccess: () {
        final newCotisation = List<bool>.from(state.cotisation);
        newCotisation[event.updateCotisationParams.type] =
            event.updateCotisationParams.cotisation;
        emit(state.copyWith(cotisation: newCotisation));
      },
      emit: emit,
      successMessage: 'Cotisation Updated Successfully',
    );
  }

  Future<void> _handleUpdatePoints(
      UpdatePoints event,
      Emitter<MemberManagementState> emit,
      ) async {
     emit(state.copyWith(points: event.updatePointsParams.points,
     typeResult: TypeResult.Loading
     ));
    await _handleEitherResult(
      result: await updatePointsUseCase(event.updatePointsParams),
      onSuccess: () => emit(state.copyWith(points: state.clone)),
      emit: emit,
      successMessage: 'Points Updated Successfully',
    );
  }

  Future<void> _handleValidateMember(
      validateMember event,
      Emitter<MemberManagementState> emit,
      ) async {
    await _handleEitherResult(
      result: await validateMemberUseCase(event.memberid),
      onSuccess: () {
        return emit(state.copyWith( typeResult: TypeResult.Updated));
      },
      emit: emit,
      successMessage: 'Member Validated Successfully',
    );
  }

  Future<void> _handleDeleteMember(
      deleteMemberEvent event,
      Emitter<MemberManagementState> emit,
      ) async {
    await _handleEitherResult(
      result: await deleteMemberUseCase(event.id),
      onSuccess: () {},
      emit: emit,
      successMessage: 'Member Deleted Successfully',
      successType: TypeResult.Removed,
    );
  }
}