part of 'particpants_bloc.dart';
enum ParticpantsStatus { initial, loading, success,changed, failed,loaded,LoadedGuests,empty,sent,ToMember,loadingExcel }
 class ParticpantsState extends Equatable {
  final List<Map<String, dynamic>> isParticipantAdded;
final List<dynamic> particpants ;
final List<ActivityParticipants> members;
final List<ActivityParticipants> membersSearch;
final ParticpantsStatus status ;
final List<ActivityGuest> Activeguests;
final List<Guest> Allguests;
final String message;
final List<ActivityGuest> guestsSearch;
final List<Guest> guestsAllSearch;


  const ParticpantsState({required this.isParticipantAdded, this.particpants = const [],
    this.message = '',
    this.guestsAllSearch=const [],


    this.members = const [], this.status = ParticpantsStatus.initial, this.Activeguests = const [], this.guestsSearch = const [], this.membersSearch = const [], this.Allguests = const []});

  ParticpantsState copyWith({List<Map<String, dynamic>>? isParticipantAdded, List<dynamic>? particpants, List<ActivityParticipants>? members, ParticpantsStatus? status,List<ActivityGuest>? Activeguests,List<ActivityGuest>? guestsSearch,List<ActivityParticipants>? membersSearch,List<Guest>? Allguests, String? message,

    List<Guest>? guestsAllSearch

  }) {

    return ParticpantsState(
      message: message ?? this.message,
      isParticipantAdded: isParticipantAdded ?? this.isParticipantAdded,
      guestsAllSearch: guestsAllSearch??this.guestsAllSearch,


      particpants: particpants ?? this.particpants,
      membersSearch: membersSearch ?? this.membersSearch,
      Activeguests: Activeguests ?? this.Activeguests,
      Allguests: Allguests ?? this.Allguests,
      guestsSearch: guestsSearch ?? this.guestsSearch,
      members: members ?? this.members,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [isParticipantAdded, particpants, members, status,Activeguests,guestsSearch,membersSearch,Allguests,message,guestsAllSearch];
}

class ParticpantsInitial extends ParticpantsState {
  ParticpantsInitial({required super.isParticipantAdded}) ;

  @override
  List<Object> get props => [isParticipantAdded];
}

