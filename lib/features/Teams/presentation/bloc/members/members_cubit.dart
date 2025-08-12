import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/Member.dart';
import '../../../../../core/PrimitiveUser/User.dart';
import '../../../domain/entities/TeamUser.dart';

part 'members_state.dart';

class MembersTeamCubit extends Cubit<MembersTeamState> {
  MembersTeamCubit() : super(MembersInitial());
void RemoveMember(TeamUser member){
  final currentMembers = state.members;

  final updatedMembers = List<TeamUser>.from(currentMembers)
    ..remove(member);

  emit(state.copyWith(members: updatedMembers));
}

  void changeMemberRole(TeamUser member, UserTeamRole newRole) {
    final currentMembers = state.members;

    final updatedMembers = currentMembers.map((m) {
      if (m.user == member.user) {
        return m.copyWith(role: newRole);
      }
      return m;
    }).toList();

    emit(state.copyWith(members: updatedMembers));
  }
void AddMember(TeamUser member){
  final currentMembers = state.members;

  final updatedMembers = List<TeamUser>.from(currentMembers)
    ..add(member);

  emit(state.copyWith(members: updatedMembers));

}
void nameChanged(String name){
  emit(state.copyWith(name: name));
}
void initMembers(List<TeamUser> members){

  emit(state.copyWith(members: members));
}
}
