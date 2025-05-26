import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';

import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../Home/presentation/widgets/Members/component/ProfileImage.dart';
import '../../../global-pres.dart';
import '../../pages/user/memberProfilPage.dart';

class MembersDetailsOnly extends StatelessWidget {
  final List<User> members;
final bool isSearchMode;

  const MembersDetailsOnly({
    super.key,
    required this.members, required this.isSearchMode,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
            builder: (context, state) {
              return InkWell(

                onTap: () {
                  _handleMemberTap(context, state, members[index]);
                },

                child:
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ColorsApp.textColorBlack,width: 2
                    ),
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MemberImageWidget(
                    item: members[index],
                    height: 30,
                    width: 18,
                    bools: true,
                    size: 15,
                  ),
                )),
              );
            },
          );
        },
     separatorBuilder: (context,index)=>SizedBox(height: 10,),
      ),
    );
  }

  void _handleMemberTap(BuildContext context, ChangeSboolsState state, User member) {
    if (state.upcomingPages.isNotEmpty) {
      context.read<ChangeSboolsCubit>().ChangePages(
          state.upcomingPages[state.upcomingPages.length - 1],
          "/memberSection/${member.id}"
      );
    } else {
      context.read<ChangeSboolsCubit>().ChangePages(
          "/home",
          "/memberSection/${member.id}"
      );
    }
if (isSearchMode) {
  Navigator.pop(context);
}
    context.read<MembersBloc>().add(
        GetMemberByIdEvent(MemberInfoParams(
          id: member.id!,
          status: true,
        ))
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return MemberSectionPage(id: member.id!);
        },
      ),
    );
  }
}