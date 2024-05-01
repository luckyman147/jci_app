import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/about_jci/Presentations/screens/BoardPage.dart';

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

      shape:const  RoundedRectangleBorder(
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
              child: Column(
                children: [
                  builderDrawerheader(context),
                  const SizedBox(height: 10),
                  drawerbody(mediaQuery),


TextButton( onPressed: () {  }, child: Text("View Terms of use",style: PoppinsRegular(16, textColorBlack),),)

                ],
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

 static Padding drawerbody(MediaQueryData mediaQuery) {
   return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
                    builder: (context, state) {
                      return
                          SizedBox(
                        width: mediaQuery.size.width,
                        height: MediaQuery.of(context).size.height/2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            BuildPres(
                                  (){


                                Navigator.push(context, MaterialPageRoute(builder: (context)=>PresentationsPage()));

                              },'Presentation',context,null

                            ),
                            BuildPres(
                                    (){

                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BoardPage()));

                                    },'Board',context,null
                            ), BuildPres(
                                    (){
                                      context.read<PresidentsBloc>().add(GetAllPresidentsEvent());
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PresidentsPage()));


                                    },'Last Presidants',context,null),


                            SizedBox(
                              width: mediaQuery.size.width/1.2,
                              height: 60,

                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Contact Us",
                                  style: PoppinsSemiBold(
                                      20, Colors.black, TextDecoration.none),
                                ),
                              ),
                            ),
                            BuildPres(()async => await ActivityAction.launchURL(context,facebookURl), "Facebook", context, BlackFacebook),
                            BuildPres(()async => await ActivityAction.launchURL(context,InstagramURl), "Instagram", context, instagram),
                            BuildPres(() async=> await ActivityAction.launchURL(context,TiktokURl), "Tiktok", context, tiktok)
                        //    BuildPres(() => null, "Facebook", context, Icons.yoo)


                          ],


                        ),
                      );
                    },
                  ),
                );
 }

 static Container builderDrawerheader(BuildContext context) {
   return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration:  BoxDecoration(
              gradient: LinearGrdi(),

                  ),
                  child: Center(
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
                );
 }

 static LinearGradient LinearGrdi() {
   return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [

                  textColorWhite,
                  PrimaryColor

                ],
              );
 }

static   Widget BuildPres(Function() onTap,String text, BuildContext context  ,String? icon) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(h: 15),
      child: InkWell(
        onTap:onTap,
        //colors
        splashColor: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(

                children: [
                  icon!=null?Padding(
                    padding: paddingSemetricHorizontal(),
                    child: SvgPicture.string(icon,height: 30,width: 30,),
                  ):SizedBox(),
                  Text(

                      text,
                      textAlign: TextAlign.start,
                      style: PoppinsRegular(18, textColorBlack)
                  ),
                ],
              ),
            ),
            
            Container(

height: 2,
decoration:  BoxDecoration(
gradient: LinearGrdi()
            )
            )],
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