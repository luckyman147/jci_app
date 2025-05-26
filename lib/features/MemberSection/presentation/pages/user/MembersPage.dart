import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/app_theme.dart';
import '../../../global-pres.dart';
import '../../widgets/member/BottomShettMember.dart';
import '../../widgets/member/MemberImpl.dart';
import '../../widgets/member/MemberSearchDelegate.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  static void show(BuildContext context) {
    context.read<MembersBloc>().add(const GetAllMembersEvent(true));
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MembersPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body:  SafeArea(child: MemberImpl.membersAdminWidget()),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(
            onPressed: () {
              context.read<MembersBloc>().add(const GetUserProfileEvent(true));
              Navigator.pop(context);
            },
          ),
          const _TitleText(),
        ],
      ),
      actions: [
        _FilterButton(),
        _SearchButton(context),
      ],
    );
  }
}

// Extracted widget components
class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      "All Members",
      style: PoppinsSemiBold(17.sp, ColorsApp.textColorBlack, TextDecoration.none),
    );
  }
}

class _FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_alt),
      onPressed: () => BottomMemberSheet.showFiltring(context),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final BuildContext parentContext;

  const _SearchButton(this.parentContext);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () => showSearch(
        context: parentContext,
        delegate: MemberSearchDelegate(parentContext),
      ),
    );
  }
}