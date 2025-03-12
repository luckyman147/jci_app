part of 'poll_bloc.dart';

sealed class PollEvent extends Equatable {
  const PollEvent();
}
class ChangeIsSelected extends PollEvent {
  final bool isSelected;

  const ChangeIsSelected({required this.isSelected});
  @override
  List<Object> get props => [isSelected];
}
class FetchPolls extends PollEvent {
  final String ActivityId;

  const FetchPolls({required this.ActivityId});
  @override
  List<Object> get props => [ActivityId];
}
class GetPollsAsTemplates extends PollEvent {
  const GetPollsAsTemplates();
  @override
  List<Object> get props => [];
}
class AddPollEvent extends PollEvent{
  final Poll poll;

  const AddPollEvent({required this.poll});
  @override
  List<Object> get props => [poll];
}
class ReseTSTate extends PollEvent{
  @override
  List<Object> get props => [];
}
class InitOptions extends PollEvent{
  final List<PollOptions> options;

  const InitOptions({required this.options});
  @override
  List<Object> get props => [options];
}
class voteEvent extends PollEvent{
  final String  pollOptionId;


  const voteEvent({required this.pollOptionId});
  @override
  List<Object> get props => [pollOptionId];
}class unvoteEvent extends PollEvent{
  final String  pollOptionId;


  const unvoteEvent({required this.pollOptionId});
  @override
  List<Object> get props => [pollOptionId];
}
class CancelPollEvent extends PollEvent{


  const CancelPollEvent();
  @override
  List<Object> get props => [];
}
class AddOptionEvent extends PollEvent{
  final PollOptions pollOptions;

  const AddOptionEvent({required this.pollOptions});
  @override
  List<Object> get props => [pollOptions];
}
class DeleteOptionEvent extends PollEvent{
  final PollOptions pollOptions;

  const DeleteOptionEvent({required this.pollOptions});
  @override
  List<Object> get props => [pollOptions];
}
class SubmitVotes extends PollEvent{
  final PollDto poldto;

  const SubmitVotes({required this.poldto});
  @override
  List<Object> get props => [poldto];
}
class DeletePollEvent extends PollEvent{
  final PollDto poldto;

  const DeletePollEvent({required this.poldto});
  @override
  List<Object> get props => [poldto];
}
