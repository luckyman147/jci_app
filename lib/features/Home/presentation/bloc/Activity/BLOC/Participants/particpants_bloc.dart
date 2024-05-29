
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/features/Home/data/model/ActivityGuestsModel.dart';
import 'package:jci_app/features/Home/domain/entities/ActivityGuest.dart';
import 'package:jci_app/features/Home/domain/entities/ActivityParticpants.dart';

import '../../../../../../../core/error/Failure.dart';

import '../../../../../data/model/ActivityParticpantsModel.dart';

import '../../../../../data/model/GuestModel.dart';
import '../../../../../domain/entities/Guest.dart';
import '../../../../../domain/usercases/ActivityUseCases.dart';
import '../../../../../domain/usercases/MeetingsUseCase.dart';
import '../../../../widgets/Functions.dart';


part 'particpants_event.dart';
part 'particpants_state.dart';

class ParticpantsBloc extends Bloc<ParticpantsEvent, ParticpantsState> {
  final ParticipateActivityUseCases participateActivityUseCases;
  final LeaveActivityUseCases leaveActivityUseCases;
final CheckAbsenceUseCases checkPermissionsUseCases;
final GetAllParticipantsUseCases getAllParticipantsUseCases;
final GetGuestsUseCases getAllGuestsOfActivityUseCases;
final GetAllGuestsUseCases getAllGuestsUseCases;
final AddGuestUseCases addGuestUseCases;
final DeleteGuestUseCases removeGuestUseCases;
final UpdateGuestUseCases updateGuestUseCases;
final ConfirmGuestUseCases confirmGuestUseCases;
final SendReminderUseCases sendReminderUseCases;
final AddGuestToActivityUseCases addGuestToActivityUseCases;
final ChangeGuestToMemberUseCases changeGuestToMemberUseCases;
  final DownloadExcelUseCases downloadExcelUseCases;

  ParticpantsBloc({required this.leaveActivityUseCases, required this.participateActivityUseCases,
    required this.checkPermissionsUseCases, required this.getAllParticipantsUseCases,
    required this.changeGuestToMemberUseCases,
    required this.getAllGuestsOfActivityUseCases, required this.addGuestUseCases,
    required this.removeGuestUseCases, required this.updateGuestUseCases,
    required this.confirmGuestUseCases, required this.sendReminderUseCases,
    required this.getAllGuestsUseCases,
    required this.downloadExcelUseCases,
    required this.addGuestToActivityUseCases,



  })
      : super(ParticpantsInitial( isParticipantAdded: [])) {
    on<ParticpantsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AddParticipantEvent>(_AddParticipent);
    on<LoadIsParttipatedList>(_loadMembers);
    on<SendReminderEvent>(_sendReminder);


    on<RemoveParticipantEvent>(_RemoveParticipent);
    on<initstateList>(init);
    on<CheckAbsenceEvent>(changeStatus);
on<GetGuestsOfActivityEvent>(getAllguests);
on<AddGuestEvent>(AddGuest);
on<DeleteGuestEvent>(RemoveGuest);
on<ConfirmGuestEvent>(confirmGuest);
on<SearchGuestByname>(seachGuesusByname);
on<SearchMemberByname>(seachMembersByname);
on<GetAllGuestsEvent>(GetAllGuests);
on<AddGuestToActivityEvent>(_addGuestToActivity);
on<SearchGuestActByname>(seachAllGuesusByname);
on<ChangeGuestToMemberEvent>(_changeGuestToMember);
on<DownloadAndSaveExcelEvent>(SaveExcel);


  }
  void SaveExcel(DownloadAndSaveExcelEvent event, Emitter<ParticpantsState> emit) async {
    emit(state.copyWith(status: ParticpantsStatus.loadingExcel));
    final result = await downloadExcelUseCases(event.activityId);
    emit(_eitherDownloadedOrFailure(result));
  }
  void _changeGuestToMember(ChangeGuestToMemberEvent event, Emitter<ParticpantsState> emit) async {
    final result = await changeGuestToMemberUseCases(event.params);
    emit(_eitherChangedToMemberOrFailed(result,event.params));
  }
  void _addGuestToActivity(AddGuestToActivityEvent event, Emitter<ParticpantsState> emit) async {
    final result = await addGuestToActivityUseCases(event.params);
    emit(_eitheraddedorFailure(result));
  }
  void GetAllGuests(GetAllGuestsEvent event, Emitter<ParticpantsState> emit) async {
    final result = await getAllGuestsUseCases(event.isUpdated);
    emit(_eitherGetAllGuestOrFailure(result));
  }
  void seachGuesusByname(SearchGuestByname event, Emitter<ParticpantsState> emit) async {
final filtered=ActivityAction.searchGuestsByName(state.Activeguests, event.name);
log(filtered.length.toString());
emit(state.copyWith(guestsSearch: filtered,status: ParticpantsStatus.LoadedGuests));


  }
  void seachAllGuesusByname(SearchGuestActByname event, Emitter<ParticpantsState> emit) async {
final filtered=ActivityAction.searchAllGuestsByName(state.guestsAllSearch, event.name);

emit(state.copyWith(Allguests: filtered,status: ParticpantsStatus.success));


  }
  void seachMembersByname(SearchMemberByname event, Emitter<ParticpantsState> emit) async {
final filtered=ActivityAction.searchMembersByName(state.membersSearch, event.name);
log(filtered.length.toString());
emit(state.copyWith(membersSearch: filtered,status: ParticpantsStatus.loaded));


  }
void _sendReminder(SendReminderEvent event, Emitter<ParticpantsState> emit) async {
  final result = await sendReminderUseCases(event.activityId);
  emit(_eitherSentOrFailure(result));
}
  void _loadMembers(
      LoadIsParttipatedList event,
      Emitter<ParticpantsState> emit
      ) async {
    final result = await getAllParticipantsUseCases(event.activityId);
    emit(_eitherLoadedOrFailure (result));

  }
  void changeStatus(CheckAbsenceEvent event, Emitter<ParticpantsState> emit) async {
    final result = await checkPermissionsUseCases(event.params);
    emit(_eitherChangedOrFailure(result,event.params));
  }
void _AddParticipent(
      AddParticipantEvent event,
      Emitter<ParticpantsState> emit
      ) async {


    final result = await participateActivityUseCases(event.act);
    final member=await MemberStore.getModel();
    emit(_eitherDoneMessageOrErrorState(result,  event.index,member!.id,event.act.id!));

}
void confirmGuest(ConfirmGuestEvent event,
    Emitter<ParticpantsState> emit
    ) async {
  final result = await confirmGuestUseCases(event.params);
  emit(_eitherUpdateGuestOrFailure(result,event.params,true));
}

void _RemoveParticipent(
    RemoveParticipantEvent event,
      Emitter<ParticpantsState> emit
      ) async {

  final result = await leaveActivityUseCases(event.act);
  final member=await MemberStore.getModel();

  emit( _eitherRemoveParticipantMessageOrErrorState (result,  event.index,member!.id,event.act.id!));

}
void init(initstateList event, Emitter<ParticpantsState> emit) {



   emit(  state.copyWith(isParticipantAdded: event.act,status: ParticpantsStatus.changed));
   ;


}
void RemoveGuest(DeleteGuestEvent event,
    Emitter<ParticpantsState> emit
    ) async {
  final result = await removeGuestUseCases(event.params);
  emit(_eitherDeleteGuestOrFailure(result,event.params));
}
void AddGuest(AddGuestEvent event,
    Emitter<ParticpantsState> emit
    ) async {
  final result = await addGuestUseCases(event.params);
  emit(_eitherAddedDeleteGuestOrFailure(result,event.params,true));
  }
void getAllguests(
    GetGuestsOfActivityEvent event,
    Emitter<ParticpantsState> emit
    ) async {
  final result = await getAllGuestsOfActivityUseCases(event.activityId);
  emit(_eitherGuestLoadedOrFailure(result));
    }

  ParticpantsState _eitherDoneMessageOrErrorState(
    Either<Failure, Unit> either,int index,String memberid,String activityId) {
  return either.fold(
        (failure) => state.copyWith(

     status: ParticpantsStatus.failed, isParticipantAdded: state.isParticipantAdded
    ),
        (_) {
          List<Map<String,dynamic>>? act = List.of(state.isParticipantAdded);
      final list=List.of(   act[index]['participants']);
      list.add({'status': 'pending',"memberid":memberid,'id':activityId});
          act[index]['participants']=list;

        return  state.copyWith(status: state.status== ParticpantsStatus.success? ParticpantsStatus.changed: ParticpantsStatus.success,
             isParticipantAdded: act);

        }
  );

}  ParticpantsState _eitherRemoveParticipantMessageOrErrorState(
    Either<Failure, Unit> either,int index,String memberid,String activityId) {
  return either.fold(
        (failure) => state.copyWith(

     status: ParticpantsStatus.failed, isParticipantAdded: state.isParticipantAdded
    ),
        (_) {
          List<Map<String, dynamic>>? act = List.of(state.isParticipantAdded);
          final list = List.of(act[index]['participants']);

// Add new member
          list.add({'status': 'pending', "memberid": memberid, 'id': activityId});

// Remove member based on some condition (e.g., memberid)
          list.removeWhere((member) => member['memberid'] == memberid);

          act[index]['participants'] = list;

          return state.copyWith(
            status: state.status == ParticpantsStatus.success ? ParticpantsStatus.changed : ParticpantsStatus.success,
            isParticipantAdded: act,
          );

        }
  );

}

  ParticpantsState _eitherLoadedOrFailure(
      Either<Failure, List<ActivityParticipants>> either,


      ) {
    return either.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed, ),
          (act) {
        return state.copyWith(members: act,status: ParticpantsStatus.loaded,membersSearch: act);
      }
    );
  }

  ParticpantsState _eitherChangedOrFailure(Either<Failure, Unit> result, ParticipantsParams params) {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed),
          (_) {
        List<ActivityParticipants> act = state.members;
        final memberIndex = act.indexWhere((participant) => participant.member[0]['_id'] == params.partipantId);

        if (memberIndex != -1) {
       final map= act[memberIndex].toMap();
       map['status']= params.status;
       final newParticipant=ActivityParticipantsModel.fromJson(map);
          act[memberIndex] = newParticipant;
       return state.copyWith(status: ParticpantsStatus.changed, members:act,membersSearch:act );
        } else {
          return state.copyWith(status: ParticpantsStatus.failed );
        }



          },
    );
  }

  ParticpantsState _eitherGuestLoadedOrFailure(Either<Failure, List<ActivityGuest>> result) {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed),
          (guests) {

        return state.copyWith(Activeguests: guests, status: ParticpantsStatus.LoadedGuests,guestsSearch: guests);
      },
    );
  }

  ParticpantsState _eitherAddedDeleteGuestOrFailure(Either<Failure, ActivityGuest> result, guestParams params, bool bool)
  {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed),
          (ge) {

          final List<ActivityGuest> guests = List.of(state.guestsSearch
          );

          guests.add(ge);
          return state.copyWith(status: ParticpantsStatus.success, Activeguests: guests,guestsSearch: guests);


      },
    );
  }

  ParticpantsState _eitherUpdateGuestOrFailure(Either<Failure, Unit> result, guestParams params, bool bool) {

    return result.fold( (failure) => state.copyWith(status: ParticpantsStatus.failed), (r)
    {
//change isconfirm

        final List<ActivityGuest> guests = state.Activeguests;
        final guestIndex = guests.indexWhere((guest) => guest.guest.id == params.guestId);
        if (guestIndex != -1) {
          final guest =ActivityguestModel. fromEntity(guests[guestIndex]).toMap();
          guest['status'] = params.status;
          guests[guestIndex] = ActivityguestModel.fromJson(guest);

          return state.copyWith(status: ParticpantsStatus.changed, Activeguests: guests, guestsSearch: guests);
        } else {
          return state.copyWith(status: ParticpantsStatus.failed);
        }
    });



  }

  ParticpantsState _eitherSentOrFailure(Either<Failure, Unit> result) {

    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed),
          (_) {
        return state.copyWith(status: ParticpantsStatus.success);
      },
    );
  }

  ParticpantsState _eitherGetAllGuestOrFailure(Either<Failure, List<Guest>> result) {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed),
          (guests) {
        return state.copyWith(Allguests: guests, status: ParticpantsStatus.LoadedGuests,guestsAllSearch: guests);
      },
    );
  }

  ParticpantsState _eitheraddedorFailure(Either<Failure, Unit> result) {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed,message: mapFailureToMessage(failure)),
          (_) {


        return state.copyWith(status: ParticpantsStatus.changed,message: 'Guest Added');
      },
    );
  }

  ParticpantsState _eitherDeleteGuestOrFailure(Either<Failure, Unit> result, guestParams params, ) {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed),
          (_) {
      final List<ActivityGuest> guests = List.of(state.Activeguests);
      guests.removeWhere((guest) => guest.guest.id == params.guestId);
      return state.copyWith(status: ParticpantsStatus.success, Activeguests: guests, guestsSearch: guests);
    }

    );
  }

  ParticpantsState _eitherChangedToMemberOrFailed(Either<Failure, Unit> result, String params) {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed),
          (_) {
        final List<ActivityGuest> Actguests = List.of(state.Activeguests);
        final List<Guest> guests = List.of(state.guestsAllSearch);
        // delete guest from active guests
        Actguests.removeWhere((guest) => guest.guest.id == params);
        // remove guest from all guests
        guests.removeWhere((guest) => guest.id == params);

        return state.copyWith(status: ParticpantsStatus.ToMember, Activeguests: Actguests, Allguests: guests, guestsSearch: Actguests, guestsAllSearch: guests);


      },
    );
  }

  ParticpantsState _eitherDownloadedOrFailure(Either<Failure, Uint8List> result) {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.empty),
          (pdf) {
        return state.copyWith(status: ParticpantsStatus.success,);
      },
    );
  }


  }