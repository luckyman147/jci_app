part of 'members_cubit.dart';
enum assignType { Assign, Invite }
 class MembersTeamState extends Equatable {
   final List<Member> members;
   final bool isSelected;
   final List<bool> ManySelected;
   final List<Member> clonedMembers;
   final String name;
  const MembersTeamState( { this.members = const [], this.isSelected = false, this.ManySelected = const [], this.clonedMembers = const [], this.name = ""});
  MembersTeamState copyWith({
    String? name,
    List<Member>? members,
    bool? isSelected,
    List<bool>? ManySelected,
    List<Member>? clonedMembers,
  }) {
    return MembersTeamState(
      name: name ?? this.name,
      members: members ?? this.members,
      isSelected: isSelected ?? this.isSelected,
      ManySelected: ManySelected ?? this.ManySelected,
      clonedMembers: clonedMembers ?? this.clonedMembers,
    );
  }
   @override
   List<Object> get props => [members, name,isSelected, ManySelected, clonedMembers];
}

class MembersInitial extends MembersTeamState {
  @override
  List<Object> get props => [];
}
