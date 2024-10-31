
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:jci_app/core/usescases/usecase.dart';


import 'package:jci_app/features/Home/domain/usercases/ActivityUseCases.dart';
import 'package:jci_app/features/Home/domain/usercases/MeetingsUseCase.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';


import '../../../../../../../core/error/Failure.dart';
import '../../../../../../../core/strings/failures.dart';



import '../../../../../domain/usercases/EventUseCases.dart';
import '../../../../../domain/usercases/TrainingUseCase.dart';

part 'add_delete_update_event.dart';
part 'add_delete_update_state.dart';

class AddDeleteUpdateBloc
    extends Bloc<AddDeleteUpdateEvent, AddDeleteUpdateState> {
 final CreateActivityUseCases createActivityUseCase;
 final DeleteActivityUseCases deleteActivityUseCases ;
 final UpdateActivityUseCases updateActivityUseCases;
final CheckPermissionsUseCase checkPermissionsUseCase;
final CheckTrainingPermissionsUseCase checkTrainingPermissionsUseCase;
final CheckMeetPermissionsUseCase checkMeetingPermissionsUseCase;

  AddDeleteUpdateBloc({
    required this.updateActivityUseCases,
    required this.createActivityUseCase, required this.deleteActivityUseCases,

    required this.checkTrainingPermissionsUseCase,
    required this.checkMeetingPermissionsUseCase,
    required this.checkPermissionsUseCase,


  })
      : super(AddDeleteUpdateInitial(

  )) {
    on<AddDeleteUpdateEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<DeleteActivityEvent>(_deleteActivity);
    on<UpdateActivityEvent>(_UpdateActivity);
    on<AddACtivityEvent>(_addActivity);
    on<CheckPermissions>(checkPermissions);

  }

  void _addActivity(
      AddACtivityEvent event, Emitter<AddDeleteUpdateState> emit) async {
    emit(LoadingAddDeleteUpdateState());


        final result = await createActivityUseCase(event.params);
        emit(_eitherDoneMessageOrErrorState(result, ' Added Succefully'));


  }
  void _deleteActivity(
      DeleteActivityEvent event,
      Emitter<AddDeleteUpdateState> emit

      )async {


      final failureOrEvents= await deleteActivityUseCases(event.params);
      emit(_deletedActivityOrFailure(failureOrEvents));


  }


void checkPermissions(
      CheckPermissions event,
      Emitter<AddDeleteUpdateState> emit

      )async {
  final failureOrEvents= await checkPermissionsUseCase(NoParams());
  emit(_checkPermissionsOrFailure(failureOrEvents));

  }

  void _UpdateActivity(
      UpdateActivityEvent event,
      Emitter<AddDeleteUpdateState> emit

      )async {
    try {


      final failureOrEvents = await updateActivityUseCases(event.params);
      emit(_UpdatedActivityOrFailure(failureOrEvents));
    }
    catch(e){
      emit(ErrorAddDeleteUpdateState(
          message: '$e'));
    }
  }




  AddDeleteUpdateState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdateState(
        message: mapFailureToMessage(failure),
      ),
      (_) => MessageAddDeleteUpdateState(message: message),
    );
  }
  AddDeleteUpdateState _deletedActivityOrFailure(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorAddDeleteUpdateState(message: mapFailureToMessage(failure)),
          (act) => DeletedActivityMessage(message: 'Deleted With Success'),
    );
  } AddDeleteUpdateState _UpdatedActivityOrFailure(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorAddDeleteUpdateState(message: failure.toString()),
          (act) => ActivityUpdatedState(message: 'Updated With Success'),
    );
  }AddDeleteUpdateState _checkPermissionsOrFailure(Either<Failure, bool> either) {
    return either.fold(
          (failure) => ErrorAddDeleteUpdateState(message: mapFailureToMessage(failure)),
          (act) => PermissionState(hasPermission: act),
    );
  }



}
