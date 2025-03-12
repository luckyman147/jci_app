


import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/PrimitiveUser/User.dart';

import 'package:jci_app/core/usescases/usecase.dart';

import 'package:jci_app/features/Home/domain/Dtos/ActivityParam.dart';
import 'package:jci_app/features/Home/domain/Dtos/PArticipantParam.dart';
import 'package:jci_app/features/Home/domain/enums/AttendeceEmum.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/PartcipantsFunctions.dart';
import 'package:logger/logger.dart';


import '../../../../../../../core/error/Failure.dart';



import '../../../../../Activity_Global.dart';
import '../../../../../domain/Dtos/UpdateParticpantsStatus.dart';
import '../../../../../domain/entities/ParticipantDetailsParam.dart';
import '../../../../../domain/enums/ParticipantWithEvents.dart';

part 'particpants_event.dart';
part 'particpants_state.dart';

class ParticpantsBloc extends Bloc<ParticpantsEvent, ParticpantsState> {

  final CheckAbsenceUseCases UpdateAbsenceUseCases;
  final GetAllParticipantsUseCases getAllParticipantsUseCases;
final UpdateMembersAttendanceUseCases updateMembersAttendanceUseCases;
  final SendReminderUseCases sendReminderUseCases;
final GetParticipantsOfActivityUseCases getParticipantsOfActivityUseCases;


  ParticpantsBloc(
      {
        required this.updateMembersAttendanceUseCases,
        required this.getParticipantsOfActivityUseCases,
        required this.UpdateAbsenceUseCases, required this.getAllParticipantsUseCases,
        required this.sendReminderUseCases,



      })
      : super(const ParticpantsInitial()) {
    on<ParticpantsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ChangeSelectAll>((event, emit) {
      emit(state.copyWith(isSelectAll: event.value,PArtcipantsSelected: []));
    });
    on<SelectPartcipantsEvent>(_selectPartcipants);
    on<UpdateParticpantsStatusEvent>(_updatePartcipants);
    on<LoadIsParttipatedList>(_loadMembers);
    on<SendReminderEvent>(_sendReminder);

    on<SearchMemberByname>(seachMembersByname,

    );
    on<CheckAbsenceEvent>(changeStatus);


    ///guests

   // on<DownloadAndSaveExcelEvent>(SaveExcel);
  }

  /*void SaveExcel(DownloadAndSaveExcelEvent event,
      Emitter<ParticpantsState> emit) async {
    emit(state.copyWith(status: ParticpantsStatus.loadingExcel));
    final result = await downloadExcelUseCases(event.activityId);
    emit(_eitherSuccessOrFailure(result, ParticpantsStatus.empty, (value) {
      return state.copyWith(status: ParticpantsStatus.success,);
    }));
  }*/


  void seachMembersByname(SearchMemberByname event,
      Emitter<ParticpantsState> emit) async {
   // final filtered = ActivityAction.searchMembersByName(

  }

  void _sendReminder(SendReminderEvent event,
      Emitter<ParticpantsState> emit) async {
    final result = await sendReminderUseCases(event.reminderParams);
    emit(_eitherSuccessOrFailure(result, ParticpantsStatus.failed, (value) {
      return state.copyWith(status: ParticpantsStatus.success,message: "Reminder Sent");
    }));
  }

  void _loadMembers(LoadIsParttipatedList event, Emitter<ParticpantsState> emit) async {
    emit(state.copyWith(status: ParticpantsStatus.loading));

    try {
      final allMembers = await  fetchAllMembers();
      final presenceList = await fetchPresenceList(event.activityId);

      Logger().w("AllMembersList", allMembers);

      // Categorize users based on attendance
      final categorizedParticipants = ParticipantsBlocFunctions.categorizeParticipants(
        allMembers: allMembers,
        presenceList: presenceList,
        event: event,
      );

      emit(state.copyWith(
        status: ParticpantsStatus.loaded,
        AllPaticipants: categorizedParticipants.allMembersListParam,
        PartcipantsSearch: categorizedParticipants.allMembersListParam,
        PresentList: categorizedParticipants.presentListParam,
        joinedList: categorizedParticipants.joinedList,
        AbsentList: categorizedParticipants.absentList,
      ));
    } catch (e) {
      Logger().e("Error loading members: $e");
      emit(state.copyWith(status: ParticpantsStatus.failed));
    }
  }


     Future<List<User>> fetchAllMembers( ) async {
    Either<Failure, List<User>>  allMembersFuture = await getAllParticipantsUseCases(NoParams());
    return allMembersFuture.getOrElse(() => []);
  }

// Fetch the presence list for the activity
   Future<List<ParticipantDetailsParam>> fetchPresenceList(String activityId) async {
    Either<Failure, List<ParticipantDetailsParam>>  presenceListFuture = await getParticipantsOfActivityUseCases(activityId);
    return presenceListFuture.getOrElse(() => []);
  }
  void changeStatus(CheckAbsenceEvent event, Emitter<ParticpantsState> emit) async {
    emit(state.copyWith(status: ParticpantsStatus.loading));

    try {
      // Update participant's attendance status using UseCases
      final result = await UpdateAbsenceUseCases(event.params);

      if (result.isLeft()) {
        // Handle error if status update fails
        final failure = result.fold((failure) => failure, (_) => null);
        Logger().w("Status change failed: $failure");
        emit(state.copyWith(status: ParticpantsStatus.failed));
        return;
      }

      final updatedStatus = event.params.status;
      final memberId = event.params.partipantId;

      // Check if the status is already the same to avoid unnecessary list modifications
      if (ParticipantsBlocFunctions.isStatusAlreadyUpdated(updatedStatus, memberId,state)) {
        Logger().i("Status is already $updatedStatus for participant $memberId. No update required.");
        emit(state.copyWith(status: ParticpantsStatus.loaded));
        return;
      }

      // Create or fetch updated participant object
      final updatedParticipant = event.params;

      // Efficiently update lists based on the new status
      final updatedAllMembersList = ParticipantsBlocFunctions.updateList(state.AllPaticipants, updatedParticipant,false);
      final updatedAbsentList = ParticipantsBlocFunctions.updateList(state.AbsentList, updatedParticipant, updatedStatus == Attendance.Absent);
      final updatedPresentList = ParticipantsBlocFunctions.updateList(state.PresentList, updatedParticipant, updatedStatus == Attendance.Present);

      // Emit the updated state with new lists
      emit(state.copyWith(
        status: ParticpantsStatus.loaded,
        AllPaticipants: updatedAllMembersList,
        PartcipantsSearch: updatedAllMembersList,
        AbsentList: updatedAbsentList,
        PresentList: updatedPresentList,
      ));

      Logger().i("Participant ${event.params.partipantId} updated to $updatedStatus");
    } catch (e) {
      Logger().e("Error changing status for participant: $e");
      emit(state.copyWith(status: ParticpantsStatus.failed));
    }
  }


  ParticpantsState _eitherSuccessOrFailure<T>(Either<Failure, T> result,
      ParticpantsStatus status, Function(T) function) {
    return result.fold(
          (failure) => state.copyWith(status: status),
          (value) {
        return function(value);
      },
    );
  }


  FutureOr<void> _updatePartcipants(UpdateParticpantsStatusEvent event, Emitter<ParticpantsState> emit) {
  }

  void _selectPartcipants(SelectPartcipantsEvent event, Emitter<ParticpantsState> emit) {
    if  (event.params!=null){
      final selectedParticipant = event.params;
      final selectedParticipants =  List<ParticipantsParams>.from(state.PArtcipantsSelected);
      final isSelected = selectedParticipants.contains(selectedParticipant);

      if (isSelected) {
        selectedParticipants.remove(selectedParticipant);
      } else {
        selectedParticipants.add(selectedParticipant!);
      }
      emit(state.copyWith(PArtcipantsSelected: selectedParticipants));

    }
    else {
      final selectedParticipants =  List<ParticipantsParams>.from(state.PArtcipantsSelected);
      final isSelected = selectedParticipants.length ==event.participants!.length;
      if (isSelected) {
        selectedParticipants.clear();
      } else {
        selectedParticipants.addAll(event.participants!);
    }       emit(state.copyWith(PArtcipantsSelected: selectedParticipants));

    }
  }
}
