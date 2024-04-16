part of 'particpants_bloc.dart';

 class ParticpantsState extends Equatable {
  final List<Map<String, dynamic>> isParticipantAdded;
final List<dynamic> particpants ;

  const ParticpantsState({required this.isParticipantAdded, this.particpants = const []});

  ParticpantsState copyWith({List<Map<String, dynamic>>? isParticipantAdded, List<dynamic>? particpants}) {
    return ParticpantsState(
      isParticipantAdded: isParticipantAdded ?? this.isParticipantAdded,
      particpants: particpants ?? this.particpants,
    );
  }

  @override
  List<Object> get props => [isParticipantAdded, particpants ];
}

class ParticpantsInitial extends ParticpantsState {
  ParticpantsInitial({required super.isParticipantAdded}) ;

  @override
  List<Object> get props => [isParticipantAdded];
}

class LoadingParticipantsState extends ParticpantsState {
  LoadingParticipantsState() : super(isParticipantAdded:[]);

  @override
  List<Object> get props => [isParticipantAdded];
}

class ParticipantSuccessState extends ParticpantsState {
  final String message;

  const ParticipantSuccessState({
    required this.message, required super.isParticipantAdded,
  }) ;

  @override
  List<Object> get props => [message, isParticipantAdded];
}

class ParticipantFailedState extends ParticpantsState {
  final String message;

  const ParticipantFailedState({
    required this.message, required super.isParticipantAdded,
  });
  @override
  List<Object> get props => [message];
}


class ParticipantChanged extends ParticpantsState{
   final List<Map<String, dynamic>> pp;

  ParticipantChanged({required super.isParticipantAdded, required this.pp});
}