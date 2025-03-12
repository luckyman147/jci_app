part of 'guests_bloc.dart';

sealed class GuestsEvent extends Equatable {
  const GuestsEvent();
}
class AddGuestToActivityEvent extends GuestsEvent {
  final guestParams params;
  const AddGuestToActivityEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class ChangeGuestToMemberEvent extends GuestsEvent {
  final String params;
  const ChangeGuestToMemberEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class ConfirmGuestEvent extends GuestsEvent {
  final guestParams params;
  const ConfirmGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class AddGuestEvent extends GuestsEvent {
  final guestParams params;
  const AddGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class DeleteGuestEvent extends GuestsEvent {
  final guestParams params;
  const DeleteGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class UpdateGuestEvent extends GuestsEvent {
  final guestParams params;
  const UpdateGuestEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class GetGuestsOfActivityEvent extends GuestsEvent {
  final String activityId;
  const GetGuestsOfActivityEvent({required this.activityId});
  @override
  List<Object> get props => [activityId];
}class GetAllGuestsEvent extends GuestsEvent {
  final bool isUpdated;
  const GetAllGuestsEvent({this.isUpdated = false});

  @override
  List<Object> get props => [isUpdated];
}
class SearchGuestByname extends GuestsEvent {
  final String name;
  const SearchGuestByname({required this.name});
  @override
  List<Object> get props => [name];}
class SearchGuestActByname extends GuestsEvent {
  final String name;
  const SearchGuestActByname({required this.name});
  @override
  List<Object> get props => [name];
}