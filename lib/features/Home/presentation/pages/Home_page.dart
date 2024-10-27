import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/pages/ActivityPage.dart';
import 'package:jci_app/features/Home/presentation/widgets/HomeWidget.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/memberProfilPage.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/screens/AllTeamsScreen.dart';
import 'package:jci_app/features/auth/presentation/bloc/Permissions/permissions_bloc.dart';


import '../../../../core/config/services/MemberStore.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import '../../../MemberSection/presentation/bloc/memberPermissions/member_permission_bloc.dart';
import '../bloc/PageIndex/page_index_bloc.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage > {
@override
  void initState() {
  isowner(context);
  context.read<MemberPermissionBloc>().add(checkIsSuper());
  context.read<MemberPermissionBloc>().add(checkIsAdmin());

  context.read<PermissionsBloc>().add(CheckPermissionsEvent());    
  // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<PermissionsBloc, PermissionsState>(
  builder: (context, Perm) {
    return BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, ste) {
    return BlocBuilder<PageIndexBloc, PageIndexState>(
      builder: (context, state) {
        final widgets=[
          HomeWidget(Activity: ste.selectedActivity,),ActivityPage(Activity:ste.selectedActivity ,),AllTeamsScreen(),MemberSectionPage(id: 'id',),
        ];
        return Scaffold(
          bottomNavigationBar: Container(

            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),

              child: buildBottomNavigationBar(state, context,Perm),
            ),
          ),
          body:widgets[state.index],



    );

}
    );
  },
);
  },
);
  }

  BottomNavigationBar buildBottomNavigationBar(PageIndexState state, BuildContext context,PermissionsState perm) {
    return BottomNavigationBar( type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
              landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
              // backgroundColor: Colors.transparent,
                selectedItemColor: PrimaryColor,

                selectedLabelStyle: PoppinsRegular(15, PrimaryColor),
                unselectedItemColor: ThirdColor,
                currentIndex: state.index,
                onTap: (index)async  {
                  context.read<PageIndexBloc>().add(SetIndexEvent(index:index));
                  if (index==0){
                    context.read<GetTeamsBloc>().add(GetTeams(isPrivate: true));
                  }
                  if (index==3){




                    context.read<MembersBloc>().add(GetUserProfileEvent(false));


                  }
                },
                items:  [
                  BottomNavigationBarItem(

                      icon: Icon(Icons.home,size: 31,), label: "Home"),
                  BottomNavigationBarItem(
                      icon: SvgPicture.string(EventIcon ,color:state.index==1?PrimaryColor:ThirdColor,), label: "Activities".tr(context)),
if (perm.status==PermStatus.Other)
                  BottomNavigationBarItem(
                      icon: SvgPicture.string(TeamsIcon,color: state.index==2?PrimaryColor:ThirdColor ,), label: "Teams".tr(context)),
                  if (perm.status==PermStatus.Other)

                  BottomNavigationBarItem(
                      icon: Icon(Icons.person,size: 31,), label: "Profile".tr(context)),
                ]);
  }

  Future<void> isowner(BuildContext context) async {
      final member =await MemberStore.getModel();
    context.read<MemberPermissionBloc>().add(checkIsowner(member!.id));
  }
}
