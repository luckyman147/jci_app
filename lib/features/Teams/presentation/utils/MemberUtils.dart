// 7. member_utils.dart
import 'package:jci_app/features/Teams/domain/dto/TaskIdParams.dart';

import 'package:jci_app/features/Teams/domain/entities/task/Task.dart';

import '../../../../core/PrimitiveUser/User.dart';
import '../../../Home/Activity_Global.dart';
import '../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../MemberSection/presentation/pages/user/memberProfilPage.dart';
import '../../domain/entities/Team/Team.dart';
import '../../domain/entities/TeamUser.dart';
import '../../domain/usecases/TeamUseCases.dart';
import '../bloc/GetTeam/get_teams_bloc.dart';
import '../bloc/members/members_cubit.dart';

class MemberUtils {
  static void toggleMember(
      BuildContext context,
      bool exists,
      TeamUser user,Function(TeamUser) onRemove,
      Function(TeamUser) onAdd,
      ) {
    if (exists) {
      context.read<MembersTeamCubit>().RemoveMember(user);
      onRemove(user);
    } else {
      context.read<MembersTeamCubit>().AddMember(user);
      onAdd(user);
    }
  }  static void InviteKickMember(
      bool isAssign, Team team, TeamUser member, BuildContext context) {
    if (!isAssign) {
      final teamfi =
      TeamInput(team.meta.id, member.user.id, null, null,member);
      context.read<GetTeamsBloc>().add(InviteMembers(teamfi: teamfi));
      Navigator.pop(context);
    } else {
      final teamfi = TeamInput(
          team.meta.id, member.user.id, "kick",null, member);
      context.read<GetTeamsBloc>().add(UpdateTeamMember(fields: teamfi));
      Navigator.pop(context);
    }
  }
  static Future<void> ToMembersSection(Team team, BuildContext context,
      User member, ChangeSboolsState state, bool mounted) async {
    if (true) {
      if (!mounted) return;
      context.read<MembersBloc>().add(
          GetMemberByIdEvent(MemberInfoParams(id: member.id!, status: true)));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return MemberSectionPage(id: member.id!);
          },
        ),
      );
    }
  }


  static Map<String, dynamic> toMapMember(User object) {
    return {
      'id': object.id,
      'firstName': object.firstName,
      'Images': object.Images,
    };
  }
  static void searchMembers(
      BuildContext context, String name, MembersTeamState state) {
    context.read<MembersTeamCubit>().nameChanged(name);
    if (state.name.length > 1) {
      context.read<MembersBloc>().add(GetMemberByNameEvent(name: state.name));
    } else if (state.name.isEmpty) {
      context.read<MembersBloc>().add(const GetAllMembersEvent(false));
    }
  }

  static List<Tasks> updateMemberRoleInTasks(List<Tasks> tasks, UpdateTaskParams fields) {
    return tasks.map((task) {
      if (task.meta.assignToMembers.any((member) => member.user.id == fields.member?.user.id)) {
        final updatedMembers = task.meta.assignToMembers.map((member) {
          if (member.user.id == fields.member?.user.id) {
            return member.copyWith(role:UserTeamRole.values.firstWhere((test)=>test.name== fields.newRole) ?? member.role);
          }
          return member;
        }).toList();

        return task.copyWith(
          meta: task.meta.copyWith(assignToImages: updatedMembers),
        );
      }
      return task;
    }
    ).toList();

  }
}
