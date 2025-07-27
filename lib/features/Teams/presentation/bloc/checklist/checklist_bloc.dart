import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/dto/TaskIdParams.dart';
import '../../../domain/entities/Checklist.dart';
import '../../../domain/usecases/CheckList_usescases.dart';

part 'checklist_event.dart';
part 'checklist_state.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {   final UpdateChecklistNameUseCase updateChecklistNameUseCase;
final DeleteChecklistUseCase deleteChecklistUseCase;
  final AddChecklistUseCase addChecklistUseCase;
  final UpdateChecklistStatusUseCase updateIsCompletedUseCases;
  final UpdateChecklistStatusUseCase updateChecklistStatusUseCase;  ChecklistBloc(this.updateChecklistNameUseCase, this.deleteChecklistUseCase, this.addChecklistUseCase, this.updateIsCompletedUseCases, this.updateChecklistStatusUseCase) : super(ChecklistInitial()) {
    on<ChecklistEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  ChecklistState _mapFailureOrSuccess<T>(
      Either<Failure, T> failureOrChecklist, Emitter<ChecklistState> emit, Function(T) onSuccess) {
    return failureOrChecklist.fold(
      (failure) => state.copyWith(status: ChecklistStatus.failure, error: mapFailureToMessage(failure)),
      (checklist) {
        return onSuccess(checklist);
      },
    );
  }


}
