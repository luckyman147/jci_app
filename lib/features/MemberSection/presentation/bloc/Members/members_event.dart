part of 'members_bloc.dart';

abstract class MembersEvent extends Equatable {
  const MembersEvent();
}
class GetAllMembersEvent extends MembersEvent {
  const GetAllMembersEvent();

  @override
  List<Object?> get props => [];
}

class GetMembersOfUser extends MembersEvent {



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
class GetUserProfileEvent extends MembersEvent {
  const GetUserProfileEvent(this.isUpdated);
final bool isUpdated;
  @override
  List<Object?> get props => [isUpdated];
}
class UpdateMemberProfileEvent extends MembersEvent {
  final Member member;


  UpdateMemberProfileEvent(this.member,);

  @override
  List<Object?> get props => [member];
}
class GetMemberByIdEvent extends MembersEvent {
  final MemberInfoParams para;


  GetMemberByIdEvent(this.para);

  @override
  List<Object?> get props => [para];
}
class ChangeToAdminEvent extends MembersEvent {
  final String id;

  ChangeToAdminEvent(this.id);

  @override
  List<Object?> get props => [id];
}
