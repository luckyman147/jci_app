part of 'members_bloc.dart';

abstract class MembersState extends Equatable {
  const MembersState();
}

class MembersInitial extends MembersState {
  @override
  List<Object> get props => [];
}
class MemberFailure extends MembersState {
  final String message;

  MemberFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
class AllMembersLoadedState extends MembersState {
  final List<Member> members;

  AllMembersLoadedState({required this.members});

  @override
  List<Object?> get props => [members];
}
class MemberLoading extends MembersState {
  @override
  List<Object?> get props => [];
}
class MemberByNameLoadedState extends MembersState {
  final List<Member> members;

  MemberByNameLoadedState({required this.members});

  @override
  List<Object?> get props => [members];
}
class AddedMemberState {
  final List<Member> members;

  AddedMemberState(this.members);
}

