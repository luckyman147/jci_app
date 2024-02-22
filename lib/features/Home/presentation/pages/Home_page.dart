import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/Home/presentation/widgets/HomeWidget.dart';
import 'package:jci_app/features/auth/data/models/AuthModel/AuthModel.dart';

import '../../../../core/config/services/store.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../bloc/PageIndex/page_index_bloc.dart';
import '../widgets/Compoenents.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final widgets=[
    HomeWidget(),Text("data"),Text("data"),Text("data"),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocBuilder<PageIndexBloc, PageIndexState>(
      builder: (context, state) {

        return Scaffold(
          bottomNavigationBar: Container(

            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),

              child: BottomNavigationBar(
                // backgroundColor: Colors.transparent,
                  selectedItemColor: PrimaryColor,
                  selectedLabelStyle: PoppinsRegular(15, PrimaryColor),
                  unselectedItemColor: ThirdColor,
                  currentIndex: state.index,
                  onTap: (index) {
                    context.read<PageIndexBloc>().add(SetIndexEvent(index:index));
                  },
                  items:  [
                    BottomNavigationBarItem(icon: Icon(Icons.home,size: 37,), label: "Home"),
                    BottomNavigationBarItem(
                        icon: SvgPicture.string(EventIcon ,color:state.index==1?PrimaryColor:ThirdColor,), label: "Activities".tr(context)),
                    BottomNavigationBarItem(
                        icon: SvgPicture.string(TeamsIcon,color: state.index==2?PrimaryColor:ThirdColor ,), label: "Teams".tr(context)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person,size: 37,), label: "Profile".tr(context)),
                  ]),
            ),
          ),
          body:widgets[state.index],



    );

}
    );
  }
}
