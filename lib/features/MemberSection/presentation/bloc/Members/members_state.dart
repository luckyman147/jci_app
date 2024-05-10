part of 'members_bloc.dart';
enum UserStatus{Initial ,Loading ,MembersLoaded,userLoaded ,Error,MemberByname,Updated,MembersRanksLoaded,ErrorMembers}
 class MembersState extends Equatable {
  final List<Member> members;
  final String Errormessage;
final List<Member> memberByName;
  final UserStatus userStatus;
  final Member? user;
  final List<Member> membersWithRanks;

    const MembersState({

      this.user,
    this.members=const[],
      this.membersWithRanks=const[],
    this.Errormessage='',
      this.memberByName=const[],
    this.userStatus=UserStatus.Initial,



 });
    MembersState copyWith({
      List<Member>? membersWithRanks,
      Member? user,

    List<Member>? members,  List<Member>? memberByName,

    String? Errormessage,
    UserStatus? userStatus,
  }) {
    return MembersState(
      user: user ?? this.user,
      memberByName: memberByName ?? this.memberByName,
      members: members ?? this.members,
      Errormessage: Errormessage ?? this.Errormessage,
      userStatus: userStatus ?? this.userStatus,
      membersWithRanks: membersWithRanks ?? this.membersWithRanks,
    );
 }

  @override
  // TODO: implement props
  List<Object?> get props => [members,Errormessage,userStatus,memberByName,user,membersWithRanks];
}

class MembersInitial extends MembersState {
  @override
  List<Object> get props => [];
}

