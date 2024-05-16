import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
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


Align(
    alignment: Alignment.bottomCenter,
    child: TextButton( onPressed: () {  }, child: Text("View Terms of use",style: PoppinsRegular(16, textColorBlack),),))

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
                            HeaderSection(mediaQuery, "About Us", Icons.info, (){}),

                            Column(
                              children: [
                                BuildPres(
                                      (){


                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PresentationsPage()));

                                  },'Presentation',context,null

                                ,Icons.apartment),
                                BuildPres(
                                        (){

                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BoardPage()));

                                        },'Board',context,null,Icons.group
                                ), BuildPres(
                                        (){
                                          context.read<PresidentsBloc>().add(GetAllPresidentsEvent());
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PresidentsPage()));


                                        },'Last Presidants',context,null,Icons.person_pin_rounded),
                                SizedBox(
                                    width: mediaQuery.size.width/1,
                                    height: 3,
                                    child: Divider( color: textColor,))
                              ],
                            ),


                            HeaderSection(mediaQuery, "Contact Us", Icons.message, (){}),
                            BuildPres(()async => await ActivityAction.launchURL(context,facebookURl), "Facebook", context, BlackFacebook,null),
                            BuildPres(()async => await ActivityAction.launchURL(context,InstagramURl), "Instagram", context, instagram,null),
                            BuildPres(() async=> await ActivityAction.launchURL(context,TiktokURl), "Tiktok", context, tiktok,null)
                        //    BuildPres(() => null, "Facebook", context, Icons.yoo)
                           , Padding(
                             padding: paddingSemetricHorizontal(h: 16),
                             child: SizedBox(
                                  width: mediaQuery.size.width/1,
                                  height: 3,
                                  child: Divider( color: textColor,)),
                           )

                          ],


                        ),
                      );
                    },
                  ),
                );
 }

 static SizedBox HeaderSection(MediaQueryData mediaQuery,String text,IconData icon,Function()onpress) {
   return SizedBox(
                            width: mediaQuery.size.width/1.2,
                            height: 60,

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(icon,color: textColorBlack,)
                                    ,SizedBox(width: 10,)
                                    ,Text(
                                      "$text",
                                      style: PoppinsSemiBold(
                                          18, Colors.black, TextDecoration.none),
                                    ),
                                  ],
                                ),
                             //   IconButton(onPressed: onpress, icon: Icon(Icons.arrow_downward_rounded,)

                              ],
                            ),
                          );
 }

 static Container builderDrawerheader(BuildContext context) {
   return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                  decoration:  BoxDecoration(
                      gradient: LinearGrdi(),
image: DecorationImage(
                      image: AssetImage("assets/images/cap.png"),
                      fit: BoxFit.cover,
  opacity: 0.5
                    ),


                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(

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
                        SizedBox(
                          height: 10,
                        ),

                      ],
                    ),
                  ),
                );
 }

 static LinearGradient LinearGrdi() {
   return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PrimaryColor,

                textColorWhite

                ],
              );
 }

static   Widget BuildPres(Function() onTap,String text, BuildContext context  ,String? icon,IconData? iconData) {
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
                    child: SvgPicture.string(icon,height: 20,width: 20,color: textColor,),
                  ):Padding(
                    padding:paddingSemetricHorizontal(),
                    child: Icon(iconData,color: textColor,size: 20,),
                  ),
                  Text(

                      text,
                      textAlign: TextAlign.start,
                      style: PoppinsSemiBold(MediaQuery.of(context).devicePixelRatio*5.6, textColor,TextDecoration.none)
                  ),
                ],
              ),
            ),

   ],
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
                mediaQuery.devicePixelRatio * 4.5, PrimaryColor,
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
BlocBuilder<GetTeamsBloc,GetTeamsState>(builder: (ctx,state){
  switch(state.status){
    case TeamStatus.Loading:
      return LoadingWidget();
    case TeamStatus.error:return SizedBox();
    case TeamStatus.success:
    case TeamStatus.IsRefresh:
    case TeamStatus.DeletedError:
    case TeamStatus.Deleted:
    return buildTeamWidget(mediaQuery, context, state.teams);
    default:return SizedBox();
  }

});
}