import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/Member.dart';
import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../auth/AuthWidgetGlobal.dart';
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
    final currentMembers =List<TeamUser>.from( state.members);
    Logger().d('Current Members: ${currentMembers.length}');

    final updatedMembers = currentMembers.map((m) {
      if (m.user.id == member.user.id) {
        Logger().d('Changing role of ${m.user.id} from ${m.role} to $newRole');
        return m.copyWith(role: newRole);
      }
      return m;
    }).toList();

    emit(state.copyWith(members: updatedMembers));
  }
  void changeTypeMember(MembersChangeType type){
  if (state.type==type) return;
    emit(state.copyWith(type: type));
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
