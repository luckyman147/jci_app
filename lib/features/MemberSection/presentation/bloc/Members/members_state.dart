part of 'members_bloc.dart';
enum UserStatus{Initial ,Loading ,MembersLoaded,userLoaded ,Error,MemberByname}
 class MembersState extends Equatable {
  final List<Member> members;
  final String Errormessage;

  final UserStatus userStatus;

    const MembersState({
    this.members=const[],
    this.Errormessage='',
    this.userStatus=UserStatus.Initial,



 });
    MembersState copyWith({
    List<Member>? members,
    String? Errormessage,
    UserStatus? userStatus,
  }) {
    return MembersState(
      members: members ?? this.members,
      Errormessage: Errormessage ?? this.Errormessage,
      userStatus: userStatus ?? this.userStatus,
    );
 }

  @override
  // TODO: implement props
  List<Object?> get props => [members,Errormessage,userStatus];
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
class UserLoaded extends MembersState {
  final Member user;

  UserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}
class MemberUpdated extends MembersState {


  MemberUpdated();

  @override
  List<Object?> get props => [

  ];
}
