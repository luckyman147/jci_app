import '../../../../core/PrimitiveUser/User.dart';
import '../../../Home/Activity_Global.dart';
import '../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/pages/user/memberProfilPage.dart';

class NavigationUtils {
  static void navigateToMemberProfile(BuildContext context, User user) {
    context.read<MembersBloc>().add(
        GetMemberByIdEvent(MemberInfoParams(id: user.id!, status: true)));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MemberSectionPage(id: user.id!)),
    );
  }
}