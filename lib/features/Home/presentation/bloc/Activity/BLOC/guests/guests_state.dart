part of 'guests_bloc.dart';

 class GuestsState extends Equatable {
   const GuestsState({
    this.status = GuestStatus.initial,
    this.message = '',
     this.guestsAllSearch=const [],
     this.Activeguests = const [], this.guestsSearch = const [],
     this.Allguests = const []
});
  final List<ActivityGuest> guestsSearch;
  final List<Guest> guestsAllSearch;
  final List<ActivityGuest> Activeguests;
  final List<Guest> Allguests;
  final GuestStatus status ;

  final String message;
  ///copy with

  GuestsState copyWith({List<ActivityGuest>? Activeguests,List<ActivityGuest>? guestsSearch,List<ActivityGuest>? membersSearch,List<Guest>? Allguests, String? message,

    List<Guest>? guestsAllSearch, GuestStatus? status

  }) {

    return GuestsState(
      message: message ?? this.message,
      Activeguests: Activeguests ?? this.Activeguests,
      guestsSearch: guestsSearch ?? this.guestsSearch,

      Allguests: Allguests ?? this.Allguests,
      guestsAllSearch: guestsAllSearch ?? this.guestsAllSearch,
      status: status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>  [ message,status,Activeguests,guestsSearch,Allguests,guestsAllSearch];
}

final class GuestsInitial extends GuestsState {
  @override
  List<Object> get props => [];
}
