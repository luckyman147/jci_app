import '../../../../core/PrimitiveUser/User.dart';
import '../../../Home/Activity_Global.dart';
import '../widgets/member/UsersList.dart';

mixin MemberSearchMixin {
  List<User> filterMembers(List<User> members, String query) {
    if (query.isEmpty) return [];
    return members.where((user) =>
    user.firstName.toLowerCase().contains(query.toLowerCase()) ||
        user.email.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  Widget buildSearchResults(List<User> results) {
    return MembersDetailsOnly(members: results, isSearchMode: true);
  }
}