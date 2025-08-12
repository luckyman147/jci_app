import '../../../../core/PrimitiveUser/User.dart';
import '../../../Home/Activity_Global.dart';
import '../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/pages/user/memberProfilPage.dart';
import '../../domain/entities/task/Task.dart';
import '../screens/DetailsTaskScreen.dart';

class NavigationUtils {
  static void navigateToMemberProfile(BuildContext context, User user) {
    context.read<MembersBloc>().add(
        GetMemberByIdEvent(MemberInfoParams(id: user.id!, status: true)));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MemberSectionPage(id: user.id!)),
    );
  }
 static  void navigateTopTaskdetails(BuildContext context,Team team,Tasks task) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => TaskDetailsScreen(
          team: team,
          task: task,
          teamId: team.meta.id,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation = Tween<Offset>(
            begin: Offset(1.0, 0.0), // From right
            end: Offset.zero,        // To screen center
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          return SlideTransition(
            position: slideAnimation,
            child: child,
          );
        },
      ),
    );
  }

}