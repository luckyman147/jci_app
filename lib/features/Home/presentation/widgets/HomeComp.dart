import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import '../../../MemberSection/presentation/widgets/ProfileComponents.dart';
import '../../../Teams/domain/entities/Team.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../Teams/presentation/widgets/TeamWidget.dart';
import '../../../about_jci/Presentations/bloc/presidents_bloc.dart';
import '../../../about_jci/Presentations/screens/JCIPresnPage.dart';
import '../../../about_jci/Presentations/screens/PastPresidentsPage.dart';
import '../bloc/PageIndex/page_index_bloc.dart';
import 'Functions.dart';

class HomeComponents{
 static Drawer buildDrawer(BuildContext context,MediaQueryData mediaQuery) {
    return Drawer(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: textColorWhite,

      child: SingleChildScrollView(
        child: Column(
          children: [


            SafeArea(
              child: Padding(
                padding: paddingSemetricVertical(),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: backgroundColored,
                        ),
                        child: Image.asset(
                          "assets/images/jci.png",
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: (){
                          context.read<ChangeSboolsCubit>().changeState(StatesBool.JCI);
                        },
                        child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
                          builder: (context, state) {
                            return ProfileComponents.ExpandedContainer(context, ProfileComponents.isJCI(state.state), SizedBox(
                              width: mediaQuery.size.width/1.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BuildPres(
                                        (){


                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PresentationsPage()));

                                    },'Presentation',

                                  ),
                                  BuildPres(
                                          (){},'Board'
                                  ), BuildPres(
                                          (){
                                            context.read<PresidentsBloc>().add(GetAllPresidentsEvent());
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PresidentsPage()));


                                          },'Last Presidants')

                                ],


                              ),
                            ), "Who we are", StatesBool.JCI, mediaQuery,mediaQuery.size.width/1.5,mediaQuery.size.height/5.5);
                          },
                        ),
                      ),
                    ),

                    Container(
                      width: mediaQuery.size.width/1.5,
                      height: 60,
                      decoration: ProfileComponents.boxDecoration,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Contact Us",
                          style: PoppinsSemiBold(
                              18, Colors.black, TextDecoration.none),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
            // You can add more items or sections as needed
            // For example:
            // Divider(),
            // ListTile(
            //   title: Text('Settings'),
            //   onTap: () {
            //     // Navigate to Settings screen or perform action
            //   },
            // ),
          ],
        ),
      ),
    );
  }

static   Widget BuildPres(Function() onTap,String text,   ) {
    return InkWell(
      onTap:onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),

        decoration: BoxDecoration(
          color: textColorWhite,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
            text,
            style: PoppinsRegular(18, textColor)
        ),
      ),
    );
  }

  Row buildRow(String text,IconData icon) {
    return Row(
      children: [
        Icon(icon), Text(
          text,
          style: PoppinsSemiBold(
              18, Colors.black, TextDecoration.none),
        ),
      ],
    );
  }


static   Widget buildTeamWidget(MediaQueryData mediaQuery, BuildContext context,
      List<Team> teams) {
    return teams.isNotEmpty ? Column(
      children: [
        buildteam(mediaQuery, context),
        SizedBox(

          height: mediaQuery.size.height / 6,

          child: TeamHomeWidget(teams: teams),
        )
      ],
    ) : SizedBox();
  }

static   Widget buildteam(MediaQueryData mediaQuery, BuildContext context) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: Row(
        children: [
          Text("My Tasks".tr(context), style: PoppinsSemiBold(
              mediaQuery.devicePixelRatio * 6, Colors.black,
              TextDecoration.none),),
          const Spacer(), InkWell(
            onTap: () {
              context.read<PageIndexBloc>().add(SetIndexEvent(index: 2));
              context.read<TaskVisibleBloc>().add(
                  changePrivacyEvent(Privacy.Private));
            },
            child: Text("See more".tr(context), style: PoppinsSemiBold(
                mediaQuery.devicePixelRatio * 5, PrimaryColor,
                TextDecoration.underline),),
          ),
        ],

      ),
    );
  }

 static  Widget buildHeader(MediaQueryData mediaQuery) {
    return Padding(
      padding: paddingSemetricVertical(v: 30),

      child: SizedBox(
        height: mediaQuery.size.height / 12,
        width: mediaQuery.size.width / 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Image.asset("assets/images/jci.png",
            alignment: Alignment.bottomCenter,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain
            ,
            bundle: null,
            scale: 2.0,

          ),
        ),
      ),
    );
  }


static   Widget TeamsWidget(MediaQueryData mediaQuery,BuildContext context) =>
      FutureBuilder<List<Team>>(
        future: ActivityAction.fetchData(context),
        // Call the function that returns a Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for the Future to complete
            return LoadingWidget();
          } else if (snapshot.hasError) {
            // Display an error message if the Future throws an error
            return SizedBox();
          } else {
            // Display the data from the Future
            return buildTeamWidget(mediaQuery, context, snapshot.data!);
          }
        },
      );
}