
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/features/Home/domain/entities/ActivityParticpants.dart';

import '../../../../../../../core/error/Failure.dart';

import '../../../../../data/model/ActivityParticpantsModel.dart';

import '../../../../../data/model/GuestModel.dart';
import '../../../../../domain/entities/Guest.dart';
import '../../../../../domain/usercases/ActivityUseCases.dart';


part 'particpants_event.dart';
part 'particpants_state.dart';

class ParticpantsBloc extends Bloc<ParticpantsEvent, ParticpantsState> {
  final ParticipateActivityUseCases participateActivityUseCases;
  final LeaveActivityUseCases leaveActivityUseCases;
final CheckAbsenceUseCases checkPermissionsUseCases;
final GetAllParticipantsUseCases getAllParticipantsUseCases;
final GetGuestsUseCases getAllGuestsUseCases;
final AddGuestUseCases addGuestUseCases;
final DeleteGuestUseCases removeGuestUseCases;
final UpdateGuestUseCases updateGuestUseCases;
final ConfirmGuestUseCases confirmGuestUseCases;
final SendReminderUseCases sendReminderUseCases;

  ParticpantsBloc({required this.leaveActivityUseCases, required this.participateActivityUseCases,
    required this.checkPermissionsUseCases, required this.getAllParticipantsUseCases,
    required this.getAllGuestsUseCases, required this.addGuestUseCases,
    required this.removeGuestUseCases, required this.updateGuestUseCases,
    required this.confirmGuestUseCases, required this.sendReminderUseCases,

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
on<GetGuestsEvent>(getAllguests);
on<AddGuestEvent>(AddGuest);
on<DeleteGuestEvent>(RemoveGuest);
on<ConfirmGuestEvent>(confirmGuest);


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
  emit(_eitherAddedDeleteGuestOrFailure(result,event.params,false));
}
void AddGuest(AddGuestEvent event,
    Emitter<ParticpantsState> emit
    ) async {
  final result = await addGuestUseCases(event.params);
  emit(_eitherAddedDeleteGuestOrFailure(result,event.params,true));
  }
void getAllguests(
    GetGuestsEvent event,
    Emitter<ParticpantsState> emit
    ) async {
  final result = await getAllGuestsUseCases(event.activityId);
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
        return state.copyWith(members: act,status: ParticpantsStatus.loaded);
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
       return state.copyWith(status: ParticpantsStatus.changed, members:act);
        } else {
          return state.copyWith(status: ParticpantsStatus.failed );
        }



          },
    );
  }

  ParticpantsState _eitherGuestLoadedOrFailure(Either<Failure, List<Guest>> result) {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed),
          (guests) {

        return state.copyWith(guests: guests, status: ParticpantsStatus.LoadedGuests);
      },
    );
  }

  ParticpantsState _eitherAddedDeleteGuestOrFailure(Either<Failure, Unit> result, guestParams params, bool bool)
  {
    return result.fold(
          (failure) => state.copyWith(status: ParticpantsStatus.failed),
          (_) {
        if (bool) {
          final List<Guest> guests = state.guests;
          guests.add(params.guest!);
          return state.copyWith(status: ParticpantsStatus.success, guests: guests);
        } else {
          final List<Guest> guests = state.guests;
          guests.removeWhere((guest) => guest.id == params.guestId);
          return state.copyWith(status: ParticpantsStatus.success, guests: guests);
        }
      },
    );
  }

  ParticpantsState _eitherUpdateGuestOrFailure(Either<Failure, Unit> result, guestParams params, bool bool) {

    return result.fold( (failure) => state.copyWith(status: ParticpantsStatus.failed), (r)
    {
//change isconfirm

        final List<Guest> guests = state.guests;
        final guestIndex = guests.indexWhere((guest) => guest.id == params.guestId);
        if (guestIndex != -1) {
          final guest =GuestModel. fromEntity(guests[guestIndex]).toJson();
          guest['isConfirmed'] = params.isConfirmed;
          guests[guestIndex] = GuestModel.fromJson(guest);

          return state.copyWith(status: ParticpantsStatus.changed, guests: guests);
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

  }