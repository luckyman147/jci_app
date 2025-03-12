import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../core/error/Failure.dart';
import '../../../../../../../core/strings/failures.dart';
import '../../../../../data/model/ActivityGuestsModel.dart';
import '../../../../../domain/Dtos/GuestParam.dart';
import '../../../../../domain/entities/guest/ActivityGuest.dart';
import '../../../../../domain/entities/guest/Guest.dart';
import '../../../../../domain/enums/ParticipantWithEvents.dart';
import '../../../../../domain/usercases/GuetUseCases.dart';
import '../../../../widgets/Functions/Functions.dart';

part 'guests_event.dart';
part 'guests_state.dart';

class GuestsBloc extends Bloc<GuestsEvent, GuestsState> {
  GuestsBloc(this.getAllGuestsOfActivityUseCases, this.getAllGuestsUseCases, this.addGuestUseCases, this.removeGuestUseCases, this.updateGuestUseCases, this.confirmGuestUseCases, this.addGuestToActivityUseCases, this.changeGuestToMemberUseCases) : super(GuestsInitial()) {
    on<GetGuestsOfActivityEvent>(getAllguests);
    on<AddGuestEvent>(AddGuest);
    on<DeleteGuestEvent>(RemoveGuest);
    on<ConfirmGuestEvent>(confirmGuest);
    on<SearchGuestByname>(seachGuesusByname);

    on<GetAllGuestsEvent>(GetAllGuests);
    on<AddGuestToActivityEvent>(_addGuestToActivity);
    on<SearchGuestActByname>(seachAllGuesusByname);
    on<ChangeGuestToMemberEvent>(_changeGuestToMember);
   
    on<GuestsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }final GetGuestsUseCases getAllGuestsOfActivityUseCases;
  final GetAllGuestsUseCases getAllGuestsUseCases;
  final AddGuestUseCases addGuestUseCases;
  final DeleteGuestUseCases removeGuestUseCases;
  final UpdateGuestUseCases updateGuestUseCases;
  final ConfirmGuestUseCases confirmGuestUseCases;
  final AddGuestToActivityUseCases addGuestToActivityUseCases;
  final ChangeGuestToMemberUseCases changeGuestToMemberUseCases;
  void _changeGuestToMember(ChangeGuestToMemberEvent event, Emitter<GuestsState> emit) async {
    final result = await changeGuestToMemberUseCases(event.params);
    emit(_SuccessOrFailure(result,(guest){
      final List<ActivityGuest> Actguests = List.of(state.Activeguests);
      final List<Guest> guests = List.of(state.guestsAllSearch);
      // delete guest from active guests
      Actguests.removeWhere((guest) => guest.guest.id == event.params);
      // remove guest from all guests
      guests.removeWhere((guest) => guest.id == event.params);


    return  state.copyWith(status: GuestStatus.ToMember, Activeguests: Actguests, Allguests: guests, guestsSearch: Actguests, guestsAllSearch: guests);


    }));
  }
  void _addGuestToActivity(AddGuestToActivityEvent event, Emitter<GuestsState> emit) async {
    final result = await addGuestToActivityUseCases(event.params);
    emit(_SuccessOrFailure(result,(_)=>state.copyWith(status: GuestStatus.changed,message: 'Guest Added')));
  }
  void GetAllGuests(GetAllGuestsEvent event, Emitter<GuestsState> emit) async {
    final result = await getAllGuestsUseCases(event.isUpdated);
    emit(_SuccessOrFailure(result,(guests)=>state.copyWith(Allguests: guests, status: GuestStatus.loaded,guestsAllSearch: guests)));
  } 
  void seachGuesusByname(SearchGuestByname event, Emitter<GuestsState> emit) async {
    final filtered=ActivityAction.searchGuestsByName(state.Activeguests, event.name);
    log(filtered.length.toString());
    emit(state.copyWith(guestsSearch: filtered,status: GuestStatus.loaded));

  }
  void seachAllGuesusByname(SearchGuestActByname event, Emitter<GuestsState> emit) async {
    final filtered=ActivityAction.searchAllGuestsByName(state.guestsAllSearch, event.name);

    emit(state.copyWith(Allguests: filtered,status: GuestStatus.success));


  }void confirmGuest(ConfirmGuestEvent event,
      Emitter<GuestsState> emit
      ) async {
    final result = await confirmGuestUseCases(event.params);
    emit(_SuccessOrFailure(result,(guest){
      final List<ActivityGuest> guests = state.Activeguests;
      final guestIndex = guests.indexWhere((guest) => guest.guest.id == event.params.guestId);
      if (guestIndex != -1) {
        final guest =ActivityguestModel. fromEntity(guests[guestIndex]).toMap();
        guest['status'] = event.params.status;
        guests[guestIndex] = ActivityguestModel.fromJson(guest);

        return state.copyWith(status: GuestStatus.changed, Activeguests: guests, guestsSearch: guests);
      } else {
        return state.copyWith(status: GuestStatus.failed);
      }
    }));
  }
  void RemoveGuest(DeleteGuestEvent event,
      Emitter<GuestsState> emit
      ) async {
    final result = await removeGuestUseCases(event.params);
    emit(_SuccessOrFailure(result,(guest){

      return state.copyWith(status: GuestStatus.changed,);
    }));
  }
  void AddGuest(AddGuestEvent event,
      Emitter<GuestsState> emit
      ) async {
    final result = await addGuestUseCases(event.params);
    emit(_SuccessOrFailure(result,(guest){



      return state.copyWith(status: GuestStatus.success, );

    }));
  }
  void getAllguests(
      GetGuestsOfActivityEvent event,
      Emitter<GuestsState> emit
      ) async {
    final result = await getAllGuestsOfActivityUseCases(event.activityId);
    emit(_SuccessOrFailure(result,(guests){
      return state.copyWith(Activeguests: guests, status: GuestStatus.loaded,guestsSearch: guests);
    }));
  }

  GuestsState _SuccessOrFailure<T>(Either<Failure, T> result,GuestsState Function(T) function) {
    return result.fold(
          (failure) => state.copyWith(status: GuestStatus.failed,message: mapFailureToMessage(failure)),
          (guests) {
        return function(guests);
      },
    );
  }










}
