part of 'formz_bloc.dart';

abstract class FormzEvent extends Equatable {
  const FormzEvent();
}
class LeaderNameChanged extends FormzEvent {
  final String leaderName;

  LeaderNameChanged({required this.leaderName});

  @override
  List<Object> get props => [leaderName];
}class ProfesseurNameChanged extends FormzEvent {
  final String profName;

  ProfesseurNameChanged({required this.profName});

  @override
  List<Object> get props => [profName];
}

class ActivityNameChanged extends FormzEvent {
  final String activityName;

  ActivityNameChanged({required this.activityName});

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

  BeginTimeChanged({required this.date});
  @override
  // TODO: implement props
  List<Object?> get props => [date];
}

class EndTimeChanged extends FormzEvent {
  final DateTime date;

  EndTimeChanged({required this.date});
  @override
  // TODO: implement props
  List<Object?> get props => [date];
}

class RegistraTimeChanged extends FormzEvent {
  final DateTime date;

  RegistraTimeChanged({required this.date});
  @override
  // TODO: implement props
  List<Object?> get props => [date];
}

class jokerChanged extends FormzEvent{
  final DateTime joke;

  jokerChanged({required this.joke});

  @override
  // TODO: implement props
  List<Object?> get props => [joke];

}class jokerTimeChanged extends FormzEvent{
  final TimeOfDay joketimer;

  jokerTimeChanged({required this.joketimer});

  @override
  // TODO: implement props
  List<Object?> get props => [joketimer];

}
class CategoryChanged extends FormzEvent {
  final Category category;

  CategoryChanged({required this.category});

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