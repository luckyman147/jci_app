import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/Member.dart';

part 'members_state.dart';

class MembersTeamCubit extends Cubit<MembersTeamState> {
  MembersTeamCubit() : super(MembersInitial());
void RemoveMember(Member member){
  final currentMembers = state.members;

  final updatedMembers = List<Member>.from(currentMembers)
    ..remove(member);

  emit(state.copyWith(members: updatedMembers));
}
void AddMember(Member member){
  final currentMembers = state.members;

  final updatedMembers = List<Member>.from(currentMembers)
    ..add(member);

  emit(state.copyWith(members: updatedMembers));

}
void nameChanged(String name){
  emit(state.copyWith(name: name));
}
void initMembers(List<Member> members){
  emit(state.copyWith(members: members));
}
}
