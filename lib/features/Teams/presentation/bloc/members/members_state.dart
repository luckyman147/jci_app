part of 'members_cubit.dart';
enum assignType { Assign, Invite }
enum MembersChangeType{ WillChange,WillCreate,WillEdit}
 class MembersTeamState extends Equatable {
   final List<TeamUser> members;
    final MembersChangeType type;
   final bool isSelected;
   final List<bool> ManySelected;
   final List<TeamUser> clonedMembers;
   final String name;
  const MembersTeamState( {
    this.type = MembersChangeType.WillChange,
    this.members = const [], this.isSelected = false, this.ManySelected = const [], this.clonedMembers = const [], this.name = ""});
  MembersTeamState copyWith({
    String? name,
    List<TeamUser>? members,
    MembersChangeType? type,
    bool? isSelected,
    List<bool>? ManySelected,
    List<TeamUser>? clonedMembers,
  }) {
    return MembersTeamState(
      type: type ?? this.type,
      name: name ?? this.name,
      members: members ?? this.members,
      isSelected: isSelected ?? this.isSelected,
      ManySelected: ManySelected ?? this.ManySelected,
      clonedMembers: clonedMembers ?? this.clonedMembers,
    );
  }
   @override
   List<Object> get props => [type,members, name,isSelected, ManySelected, clonedMembers];
}

class MembersInitial extends MembersTeamState {
  @override
  List<Object> get props => [];
}
