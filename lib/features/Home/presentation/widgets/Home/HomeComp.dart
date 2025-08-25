


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/presidents_bloc.dart';

import '../../../../auth/presentation/widgets/Text.dart';
import '../../../Activity_Global.dart';
import '../../../domain/enums/Privacy.dart';
import '../../bloc/PageIndex/page_index_bloc.dart';
import '../components/stuff/GradientText.dart';
import '../shimmer/ShimmerRow.dart';




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

                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderSection(mediaQuery, "About Us".tr(context), Icons.info, (){}),

                            Column(
                              children: [
                                BuildPres(
                                      (){


                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const PresentationsPage()));

                                  },'Presentation'.tr(context),context,null

                                ,Icons.apartment),
                                BuildPres(
                                        (){

                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const BoardPage()));

                                        },'Board'.tr(context),context,null,Icons.group
                                ), BuildPres(
                                        (){
                                          context.read<PresidentsBloc>().add(GetAllPresidentsEvent());
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const PresidentsPage()));


                                        },'Last Presidents'.tr(context),context,null,Icons.person_pin_rounded),
                                SizedBox(
                                    width: mediaQuery.size.width/1,
                                    height: 3,
                                    child: const Divider( color: textColor,))
                              ],
                            ),


                            HeaderSection(mediaQuery, "Contact Us".tr(context), Icons.message, (){}),
                            BuildPres(()async => await ActivityAction.launchURL(context,facebookURl), "Facebook", context, BlackFacebook,null),
                            BuildPres(()async => await ActivityAction.launchURL(context,InstagramURl), "Instagram", context, instagram,null),
                            BuildPres(() async=> await ActivityAction.launchURL(context,TiktokURl), "Tiktok", context, tiktok,null)
                        //    BuildPres(() => null, "Facebook", context, Icons.yoo)
                           , Padding(
                             padding: paddingSemetricHorizontal(h: 16),
                             child: SizedBox(
                                  width: mediaQuery.size.width/1,
                                  height: 3,
                                  child: const Divider( color: textColor,)),
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
                                    ,const SizedBox(width: 10,)
                                    ,Text(
                                      text,
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
image: const DecorationImage(
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

                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: backgroundColored,
                          ),

                          child: Image.asset(
                            "assets/images/jci.png",
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                      ],
                    ),
                  ),
                );
 }

 static LinearGradient LinearGrdi() {
   return const LinearGradient(
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
    return  Flex(
      direction: Axis.vertical,
      children: [
     buildteam(mediaQuery, context),
 TeamHomeWidget(teams: teams),

      ],
    ) ;
  }

static   Widget buildteam(MediaQueryData mediaQuery, BuildContext context) {
  return Padding(
    padding: paddingSemetricVertical(),
    child: Row(
      children: [
        Text("My Teams".tr(context), style: PoppinsSemiBold(
            16.sp, Colors.black,
            TextDecoration.none),),
        const Spacer(), InkWell(
          onTap: () {
            context.read<PageIndexBloc>().add(SetIndexEvent(index: 2));
            context.read<TaskVisibleBloc>().add(
                const changePrivacyEvent(Privacy.Private));
          },
          child: LinkedText(
              text: "See more".tr(context),
              size: mediaQuery.devicePixelRatio * 5.5),
        ),
      ],

    ),
  );
}

 static  Widget buildHeader(MediaQueryData mediaQuery) {
    return Padding(
      padding: paddingSemetricVertical(v: 30),

      child:
      BlocSelector<MembersBloc, MembersState, MembersState>(
        selector: (state) => state,
        builder: (ctx, state) {
          if (state.userStatus == UserStatus.Loading) {
            // Show shimmer loading row
            return ShimmerRow(); // Replace with your actual shimmer widget
          } else if (state.user != null) {
            // Show user info row
            return Row(

              spacing:5,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  text: "Hello,  ${state.user!.firstName} ",
                  style: PoppinsSemiBold(25.sp, ColorsApp.textColorWhite, TextDecoration.none), // your existing style
                  gradient: const LinearGradient(
                    colors: [
                     PrimaryColor,

                     ColorsApp.SecondaryColor
                    ],
                  ),
                )
                // Add other widgets here if needed
              ],
            );
          } else {
            // User is null
            return Text("Hi"); // or any fallback
          }
        },
      )
    );
  }

 static SizedBox buioldLogo(MediaQueryData mediaQuery) {
   return SizedBox(
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
    );
 }


static   Widget TeamsWidget(MediaQueryData mediaQuery,BuildContext context) =>
BlocBuilder<GetTeamsBloc,GetTeamsState>(builder: (ctx,state){
  if ( state.homeTeams .isNotEmpty) {
    return
     RefreshIndicator(
         onRefresh: (){
            context.read<GetTeamsBloc>().add(GetTeamsOfuser());
            return Future.value();
         },

         child:  buildTeamWidget(mediaQuery, context, state.homeTeams));
  }
  else if (state.homeTeams .isEmpty){
    return

      Padding(
      padding: paddingSemetricVertical(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

       SizedBox(),
        ],
      ),
    );
  }
  else
  return const SizedBox.shrink();
  }

);
}