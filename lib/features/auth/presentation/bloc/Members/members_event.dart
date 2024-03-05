part of 'members_bloc.dart';

abstract class MembersEvent extends Equatable {
  const MembersEvent();
}
class GetAllMembersEvent extends MembersEvent {
  const GetAllMembersEvent();

  @override
  List<Object?> get props => [];
}
class GetMemberByNameEvent extends MembersEvent {
  final String name;


  GetMemberByNameEvent({required this.name});

  @override
  List<Object?> get props => [name];
}
class MemberAddEvent extends MembersEvent {
  final int index;
  final Member member;

  MemberAddEvent(this.index, this.member);

  @override
  // TODO: implement props
  List<Object?> get props => [index];}