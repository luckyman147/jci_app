part of 'particpants_bloc.dart';

class ParticpantsState extends Equatable {
  final List<ParticipantsParams> AllPaticipants;
  final List<ParticipantsParams> PresentList;
  final List<ParticipantsParams> AbsentList;
  final List<ParticipantsParams> joinedList;
  final List<ParticipantsParams> PartcipantsSearch;
  final List<ParticipantsParams> PArtcipantsSelected;
  final bool isSelectAll;
  final ParticpantsStatus status;

  final String message;
  final String userId;

  const ParticpantsState(
      {this.isSelectAll = false,
      this.message = '',
      this.userId = '',
      this.PArtcipantsSelected = const [],
      this.joinedList = const [],
      this.status = ParticpantsStatus.initial,
      this.PartcipantsSearch = const [],
      this.AllPaticipants = const [],
      this.PresentList = const [],
      this.AbsentList = const []});

  ParticpantsState copyWith({
    bool? isSelectAll,
    String? userId,
    List<ParticipantsParams>? PArtcipantsSelected,
    List<ParticipantsParams>? AllPaticipants,
    List<ParticipantsParams>? PresentList,
    List<ParticipantsParams>? AbsentList,
    List<ParticipantsParams>? PartcipantsSearch,
    List<ParticipantsParams>? joinedList,
    ParticpantsStatus? status,
    String? message,
  }) {
    return ParticpantsState(
      userId: userId ?? this.userId,
      isSelectAll: isSelectAll ?? this.isSelectAll,
      PArtcipantsSelected: PArtcipantsSelected ?? this.PArtcipantsSelected,
      AllPaticipants: AllPaticipants ?? this.AllPaticipants,
      PresentList: PresentList ?? this.PresentList,
      AbsentList: AbsentList ?? this.AbsentList,
      PartcipantsSearch: PartcipantsSearch ?? this.PartcipantsSearch,
      status: status ?? this.status,
      message: message ?? this.message,
      joinedList: joinedList ?? this.joinedList,
    );
  }

  @override
  List<Object> get props => [
        message,
        status,
        userId,
        AllPaticipants,
        PresentList,
        AbsentList,
        PartcipantsSearch,
        joinedList,
        PArtcipantsSelected,
        isSelectAll
      ];
}

class ParticpantsInitial extends ParticpantsState {
  const ParticpantsInitial();

  @override
  List<Object> get props => [];
}
