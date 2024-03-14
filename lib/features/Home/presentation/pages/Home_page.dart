import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/pages/ActivityPage.dart';
import 'package:jci_app/features/Home/presentation/widgets/HomeWidget.dart';
import 'package:jci_app/features/Teams/presentation/screens/AllTeamsScreen.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../bloc/PageIndex/page_index_bloc.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, ste) {
    return BlocBuilder<PageIndexBloc, PageIndexState>(
      builder: (context, state) {
        final widgets=[
          HomeWidget(Activity: ste.selectedActivity,),ActivityPage(Activity:ste.selectedActivity ,),AllTeamsScreen(),Center(
            child: InkWell(
                onTap: () {
                  context.read<AuthBloc>().add(SignoutEvent());
                },

                child: Text("Signout")),
          )
        ];
        return Scaffold(
          bottomNavigationBar: Container(

            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),

              child: BottomNavigationBar( type: BottomNavigationBarType.fixed,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                // backgroundColor: Colors.transparent,
                  selectedItemColor: PrimaryColor,

                  selectedLabelStyle: PoppinsRegular(15, PrimaryColor),
                  unselectedItemColor: ThirdColor,
                  currentIndex: state.index,
                  onTap: (index) {
                    context.read<PageIndexBloc>().add(SetIndexEvent(index:index));
                  },
                  items:  [
                    BottomNavigationBarItem(

                        icon: Icon(Icons.home,size: 31,), label: "Home"),
                    BottomNavigationBarItem(
                        icon: SvgPicture.string(EventIcon ,color:state.index==1?PrimaryColor:ThirdColor,), label: "Activities".tr(context)),
                    BottomNavigationBarItem(
                        icon: SvgPicture.string(TeamsIcon,color: state.index==2?PrimaryColor:ThirdColor ,), label: "Teams".tr(context)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person,size: 31,), label: "Profile".tr(context)),
                  ]),
            ),
          ),
          body:widgets[state.index],



    );

}
    );
  },
);
  }
}
