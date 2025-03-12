part of 'formz_bloc.dart';

 class FormzState extends Equatable {
  const FormzState({
    this.status = FormzSubmissionStatus.initial,
    this.leaderName = const LeaderName.pure(),
    this.professeurName = const ProfesseurName.pure(),


    this.activityName = const ActivityName.pure(),
    this.location = const Location.pure(),
    this.description = const Description.pure(),
    this.imageInput = const ImageInput.pure(),
    this.beginTimeInput = const BeginTimeInput.pure(),
    this.registrationTimeInput = const RegistrationTimeInput.pure(),
    this.endTimeInput = const EndTimeInput.pure(),
    this.eventFormz = const EventFormz.pure(),

    this.memberName = const MemberName.pure(),
    this.memberFormz = const MemberFormz.pure(),
    this.jokertime = const JokerDateofDayInput.pure(),
    this.joker = const JokerTimeInput.pure(),
    this.membersTeamFormz = const MembersTeamFormz.pure(),
    this.PrivateParticipants = const [],
    this.Error="",

    this.isValid = false,

  } );
  final MembersTeamFormz membersTeamFormz;
  final List<User> PrivateParticipants;
  final EventFormz eventFormz;
  final MemberName memberName;
  final MemberFormz memberFormz;
  final bool isValid;


  final JokerTimeInput joker;
  final ProfesseurName professeurName;
  final JokerDateofDayInput jokertime;
  final FormzSubmissionStatus status;
  final LeaderName leaderName;
  final ActivityName activityName;
  final Location location;
  final BeginTimeInput beginTimeInput;
final String Error;

  final EndTimeInput endTimeInput;


  final RegistrationTimeInput registrationTimeInput;
  final Description description;
  final ImageInput imageInput;
  FormzState copyWith(
      {FormzSubmissionStatus? status,
        List<User>? PrivateParticipants,

        EventFormz? eventFormz,
        String? Error,
        LeaderName? leaderName,
        MemberName? memberName,
        MembersTeamFormz? membersTeamFormz,
        MemberFormz? memberFormz,
        ProfesseurName?professeurName,
        ActivityName? activityName,
        Location? location,
        Description? description,
        ImageInput? imageInput,

        BeginTimeInput? beginTimeInput,
        JokerDateofDayInput?jokerDateofDayInput,
        RegistrationTimeInput?registrationTimeInput,
        JokerTimeInput?jokerTimeInput,
        EndTimeInput? endTimeInput,
        bool? isValid,
    }) {
    return FormzState(
        Error: Error ?? this.Error,
        PrivateParticipants: PrivateParticipants ?? this.PrivateParticipants,

        membersTeamFormz: membersTeamFormz ?? this.membersTeamFormz,
        eventFormz: eventFormz ?? this.eventFormz,


        memberName: memberName ?? this.memberName,
        memberFormz: memberFormz ?? this.memberFormz,
        status: status ?? this.status,
        leaderName: leaderName ?? this.leaderName,
        professeurName: professeurName??this.professeurName,
        activityName: activityName ?? this.activityName,
        location: location ?? this.location,
        description: description ?? this.description,
        imageInput: imageInput ?? this.imageInput,
        endTimeInput: endTimeInput ?? this.endTimeInput,
        joker: jokerTimeInput?? joker,
        jokertime: jokerDateofDayInput??jokertime,


        beginTimeInput: beginTimeInput ?? this.beginTimeInput,

        registrationTimeInput:
        registrationTimeInput ?? this.registrationTimeInput,

        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object?> get props => [
    isValid,
Error,
    status,
    leaderName,
    PrivateParticipants,
    activityName,
    location,
 memberName,
    description,
    joker,
    membersTeamFormz,
    imageInput,
    endTimeInput,
professeurName,
    beginTimeInput,registrationTimeInput
    ,jokertime,
    memberFormz,
    eventFormz,
  ];

}

class FormzInitial extends FormzState {
  @override
  List<Object> get props => [];
}


