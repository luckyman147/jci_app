part of 'formz_bloc.dart';

abstract class FormzEvent extends Equatable {
  const FormzEvent();
}
class LeaderNameChanged extends FormzEvent {
  final String leaderName;

  const LeaderNameChanged({required this.leaderName});

  @override
  List<Object> get props => [leaderName];
}class ProfesseurNameChanged extends FormzEvent {
  final String profName;

  const ProfesseurNameChanged({required this.profName});

  @override
  List<Object> get props => [profName];
}

class ActivityNameChanged extends FormzEvent {
  final String activityName;

  const ActivityNameChanged({required this.activityName});

  @override
  List<Object> get props => [activityName];
}

class LocationChanged extends FormzEvent {
  final String location;

  const LocationChanged({required this.location});

  @override
  List<Object> get props => [location];
}

class BeginTimeChanged extends FormzEvent {
  final DateTime date;

  const BeginTimeChanged({required this.date});
  @override
  // TODO: implement props
  List<Object?> get props => [date];
}

class EndTimeChanged extends FormzEvent {
  final DateTime date;

  const EndTimeChanged({required this.date});
  @override
  // TODO: implement props
  List<Object?> get props => [date];
}

class RegistraTimeChanged extends FormzEvent {
  final DateTime date;

  const RegistraTimeChanged({required this.date});
  @override
  // TODO: implement props
  List<Object?> get props => [date];
}

class jokerChanged extends FormzEvent{
  final DateTime joke;

  const jokerChanged({required this.joke});

  @override
  // TODO: implement props
  List<Object?> get props => [joke];

}class jokerTimeChanged extends FormzEvent{
  final TimeOfDay joketimer;

  const jokerTimeChanged({required this.joketimer});

  @override
  // TODO: implement props
  List<Object?> get props => [joketimer];

}
class CategoryChanged extends FormzEvent {
  final Category category;

  const CategoryChanged({required this.category});

  @override
  // TODO: implement props
  List<Object?> get props => [category];
}

class DescriptionChanged extends FormzEvent {
  final String description;

  const DescriptionChanged({required this.description});

  @override
  List<Object> get props => [description];
}class MembernameChanged extends FormzEvent {
  final String name;

  const MembernameChanged({required this.name});

  @override
  List<Object> get props => [name];
}
class SearchCategoryChanged extends FormzEvent {
  final String searchCategory;

  const SearchCategoryChanged({required this.searchCategory});

  @override
  List<Object> get props => [searchCategory];
}
class ImageInputChanged extends FormzEvent {
  final XFile imageInput;

  const ImageInputChanged({required this.imageInput});

  @override
  List<Object> get props => [imageInput];
}
class MemberFormzChanged extends FormzEvent {
  final Member memberFormz;

  const MemberFormzChanged({required this.memberFormz});

  @override
  List<Object> get props => [memberFormz];
}
class EventChanged extends FormzEvent {
  final Event eventChanged;

  const EventChanged({required this.eventChanged});

  @override
  List<Object> get props => [eventChanged
  ];
}
class MembersTeamChanged extends FormzEvent {
  final Member memberTeam;

  const MembersTeamChanged({required this.memberTeam});

  @override
  List<Object> get props => [memberTeam];
}
class InitMembers extends FormzEvent {
  final List<Member> members;

  const InitMembers({required this.members});

  @override
  List<Object> get props => [members];
}
class RemoveMember extends FormzEvent {
  final Member member;

  const RemoveMember({required this.member});

  @override
  List<Object> get props => [member];
}