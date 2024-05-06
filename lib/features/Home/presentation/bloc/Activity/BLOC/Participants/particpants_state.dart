part of 'particpants_bloc.dart';
enum ParticpantsStatus { initial, loading, success,changed, failed,loaded,LoadedGuests,empty,sent }
 class ParticpantsState extends Equatable {
  final List<Map<String, dynamic>> isParticipantAdded;
final List<dynamic> particpants ;
final List<ActivityParticipants> members;
final ParticpantsStatus status ;
final List<Guest> guests;

  const ParticpantsState({required this.isParticipantAdded, this.particpants = const [], this.members = const [], this.status = ParticpantsStatus.initial, this.guests = const []});

  ParticpantsState copyWith({List<Map<String, dynamic>>? isParticipantAdded, List<dynamic>? particpants, List<ActivityParticipants>? members, ParticpantsStatus? status,List<Guest>? guests}) {
    return ParticpantsState(
      isParticipantAdded: isParticipantAdded ?? this.isParticipantAdded,
      particpants: particpants ?? this.particpants,
      guests: guests ?? this.guests,
      members: members ?? this.members,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [isParticipantAdded, particpants, members, status,guests];
}

class ParticpantsInitial extends ParticpantsState {
  ParticpantsInitial({required super.isParticipantAdded}) ;

  @override
  List<Object> get props => [isParticipantAdded];
}

