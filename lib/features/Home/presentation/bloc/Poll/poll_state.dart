part of 'poll_bloc.dart';

 class PollState extends Equatable {
  const PollState(
      {this.polls = const [],
      this.options = const [],
      this.voted = const {},
      this.votes = const [],
      this.error = "",
      this.isSelected = false,
      this.Templates = const [],
      this.pollEnum = PollEnum.Initial,
      this.message = ""}
      );

  final List<Poll> polls ;
  final bool isSelected;
  final List<Poll> Templates ;
  final List<PollOptions> options;
  final List<Vote> votes;
  final Map<String,bool> voted;
  final String error;
  final PollEnum pollEnum;
  final String message;
  //copyWith method
  PollState copyWith({

    bool? isSelected,

    Map<String,bool>? voted,
    List<Poll>? polls,
    List<Poll>? Templates,
    List<PollOptions>? options,
    List<Vote>? votes,
    String? error,
    PollEnum? pollEnum,
    String? message,
  }) {
    return PollState(
      Templates: Templates ?? this.Templates,
      voted: voted ?? this.voted,
      polls: polls ?? this.polls,
      isSelected: isSelected ?? this.isSelected,
      options: options ?? this.options,
      votes: votes ?? this.votes,
      error: error ?? this.error,
      pollEnum: pollEnum ?? this.pollEnum,
      message: message ?? this.message,
    );
  }
  @override
  List<Object> get props => [polls, options, votes, error, pollEnum, message, voted, Templates, isSelected];



}


final class PollInitial extends PollState {
  @override
  List<Object> get props => [];
}
