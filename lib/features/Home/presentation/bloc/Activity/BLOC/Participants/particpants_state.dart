part of 'particpants_bloc.dart';
enum ParticpantsStatus { initial, loading, success,changed, failed,loaded,LoadedGuests,empty,sent }
 class ParticpantsState extends Equatable {
  final List<Map<String, dynamic>> isParticipantAdded;
final List<dynamic> particpants ;
final List<ActivityParticipants> members;
final List<ActivityParticipants> membersSearch;
final ParticpantsStatus status ;
final List<Guest> guests;
final List<Guest> guestsSearch;

  const ParticpantsState({required this.isParticipantAdded, this.particpants = const [], this.members = const [], this.status = ParticpantsStatus.initial, this.guests = const [], this.guestsSearch = const [], this.membersSearch = const []});

  ParticpantsState copyWith({List<Map<String, dynamic>>? isParticipantAdded, List<dynamic>? particpants, List<ActivityParticipants>? members, ParticpantsStatus? status,List<Guest>? guests,List<Guest>? guestsSearch,List<ActivityParticipants>? membersSearch}) {

    return ParticpantsState(
      isParticipantAdded: isParticipantAdded ?? this.isParticipantAdded,


      particpants: particpants ?? this.particpants,
      membersSearch: membersSearch ?? this.membersSearch,
      guests: guests ?? this.guests,
      guestsSearch: guestsSearch ?? this.guestsSearch,
      members: members ?? this.members,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [isParticipantAdded, particpants, members, status,guests,guestsSearch,membersSearch];
}

class ParticpantsInitial extends ParticpantsState {
  ParticpantsInitial({required super.isParticipantAdded}) ;

  @override
  List<Object> get props => [isParticipantAdded];
}

