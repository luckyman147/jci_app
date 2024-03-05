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
    this.jokertime = const JokerDateofDayInput.pure(),
    this.memberName = const MemberName.pure(),
    this.memberFormz = const MemberFormz.pure(),

    this.joker = const JokerTimeInput.pure(),

    this.isValid = false,
    this.category = Category.Technology
  } );
  final MemberName memberName;
  final MemberFormz memberFormz;
  final bool isValid;
  final Category category;
  final JokerTimeInput joker;
  final ProfesseurName professeurName;
  final JokerDateofDayInput jokertime;
  final FormzSubmissionStatus status;
  final LeaderName leaderName;
  final ActivityName activityName;
  final Location location;
  final BeginTimeInput beginTimeInput;


  final EndTimeInput endTimeInput;


  final RegistrationTimeInput registrationTimeInput;
  final Description description;
  final ImageInput imageInput;
  FormzState copyWith(
      {FormzSubmissionStatus? status,
        LeaderName? leaderName,
        MemberName? memberName,
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
        Category? category}) {
    return FormzState(


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
        joker: jokerTimeInput?? this.joker,
        jokertime: jokerDateofDayInput??this.jokertime,


        beginTimeInput: beginTimeInput ?? this.beginTimeInput,

        registrationTimeInput:
        registrationTimeInput ?? this.registrationTimeInput,
        category: category ?? this.category,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object?> get props => [
    status,
    leaderName,
    activityName,
    location,
 memberName,
    description,
    joker,
    imageInput,
    endTimeInput,
professeurName,
    beginTimeInput,registrationTimeInput,
    category
    ,jokertime,
    memberFormz
  ];

}
enum Category {
  Technology,
  Science,
  Business,
  Health,
  Economy,
  Entertainment,
  Sports,
  Food,
  Fashion,
  Education,
  Arts,
  Music,
  Literature,
  Gaming,
  Automotive,
  Fitness,
  Parenting,
  Pets,
  fun,
  Environment
}


class FormzInitial extends FormzState {
  @override
  List<Object> get props => [];
}

