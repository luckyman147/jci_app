import '../../../../core/PrimitiveUser/User.dart';
import '../../../Home/Activity_Global.dart';
import '../../../Home/domain/enums/Privacy.dart';
import '../../domain/entities/Team/Team.dart';
import '../bloc/GetTeam/get_teams_bloc.dart';

class TeamUtils {

  static void searchFunction(
      String value, BuildContext context, bool isPrivate) {
    if (value.isEmpty) {
      context.read<GetTeamsBloc>().add(GetTeams(null,false,isPrivate: isPrivate));
    } else {
      context.read<GetTeamsBloc>().add(GetTeamByName({"name": value}));
    }
  }


  static bool doesUserExist(List<User> users, User user) =>
      users.any((u) => u.id == user.id);
  static void changeInitTeams(
      BuildContext context, Privacy privacy, bool isPrivate) {
    context.read<TaskVisibleBloc>().add(changePrivacyEvent(privacy));

    // Dispatch event to initialize GetTeamsBloc and fetch teams with updated privacy
    context.read<GetTeamsBloc>().add(initStatus());
    context.read<GetTeamsBloc>().add(GetTeams(null,true,isPrivate: isPrivate));
  }

}
