// 7. member_utils.dart
import '../../../../core/PrimitiveUser/User.dart';
import '../../../Home/Activity_Global.dart';
import '../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../MemberSection/presentation/pages/user/memberProfilPage.dart';
import '../../domain/entities/Team/Team.dart';
import '../../domain/usecases/TeamUseCases.dart';
import '../bloc/GetTeam/get_teams_bloc.dart';
import '../bloc/members/members_cubit.dart';

class MemberUtils {
  static void toggleMember(
      BuildContext context,
      bool exists,
      User user,
      Function(User) onAdd,
      Function(User) onRemove) {
    if (exists) {
      context.read<MembersTeamCubit>().RemoveMember(user);
      onRemove(user);
    } else {
      context.read<MembersTeamCubit>().AddMember(user);
      onAdd(user);
    }
  }  static void InviteKickMember(
      bool isAssign, Team team, User member, BuildContext context) {
    if (!isAssign) {
      final teamfi =
      TeamInput(team.meta.id, member.id, null, member);
      context.read<GetTeamsBloc>().add(InviteMembers(teamfi: teamfi));
      Navigator.pop(context);
    } else {
      final teamfi = TeamInput(
          team.meta.id, member.id, "kick", member);
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
}
