import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../core/app_theme.dart';
import '../../../Home/presentation/widgets/MemberSelection.dart';
import '../../../auth/domain/entities/Member.dart';
import '../bloc/Members/members_bloc.dart';
import 'MemberImpl.dart';

class BestMembersComponent{
  static  Widget MembersRanksBody(BuildContext context, List<Member> members) {
    return Column(
      children: [
        BestMembersWidget(members, context),

        RowInfo(context),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.separated(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PhysicalModel(
                    color: Colors.white,
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
visualDensity: VisualDensity.comfortable,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: index<3?SecondaryColor:Colors.grey.shade400,
                            width: 2)

                      ),

                      leading: Text(
                        (index + 1).toString(),
                        style: PoppinsRegular( index>2?20:24,index<3?SecondaryColor:
                          Colors.grey.shade400, ),
                      ),
                      title:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          imageWidget(member, 30, 18,true ,100),
                          Text(member.points.toString(), style: PoppinsSemiBold(20, textColorBlack, TextDecoration.none)),

                        ],
                      ),

                    ),
                  ),
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10,
            );
          },
          ),
        ),
      ],
    );
  }

  static Widget BestMembersWidget(List<Member> members, BuildContext context) {
    return members.length>=3?
    Container(
      height: MediaQuery.of(context).size.height * 0.43,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(


        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(

        children: [
          Header(context,textColorBlack),
          Text("Best Members".tr(context),style: PoppinBold(30, SecondaryColor,TextDecoration.none),),
          Padding(
            padding: paddingSemetricVertical(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: ColumBestMembers(members[1],Colors.grey,"2",78,context),
                ),
                ColumBestMembers(members[0],Color(0xFFFFD700),"1",78,context),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: ColumBestMembers(members[2],Colors.brown,"3",78,context),
                ),


              ],
            ),
          )


        ],
      ),

    ):              Header(context,textColorBlack);
  }

  static Container ColumBestMembers(Member members,Color color,String index,double siez,BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: textColorWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      border: Border.all(color: color,width: 1)
      ),

      child: Padding(
        padding: paddingSemetricVerticalHorizontal(v: 10, h: 13),
        child: Column(
          children: [
            ImageRank(members, color, index,siez),
            Text(members.firstName.toString(), style: PoppinsSemiBold(15, ThirdColor, TextDecoration.none)),
            // Text(members.firstName.toString(), style: PoppinsSemiBold(15, textColor, TextDecoration.none)),
            Text(members.lastName.toString(), style: PoppinsSemiBold(15, ThirdColor, TextDecoration.none)),
            Text("${members.points} Pts", style: PoppinsSemiBold(16, PrimaryColor, TextDecoration.none)),
          ],
        ),
      ),
    );
  }

  static SizedBox ImageRank(Member members,Color color,String index,double size) {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          PhotoReeact(members, size),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color, // Adjust color as needed
              ),
              // Adjust color as needed
              child: Center(child: Text(index, style: PoppinsRegular(15, textColorWhite))), // Adjust content as needed
            ),
          ),
        ],
      ),
    );
  }

  static Row Header(BuildContext context,Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BackButton(color: color,onPressed: (){Navigator.pop(context);},),
        Padding(
          padding: paddingSemetricHorizontal(h: 17),
          child: Text("LeaderBoard".tr(context),style: PoppinsSemiBold(20, color, TextDecoration.none),),
        )
      ],);
  }

  static Row RowInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: paddingSemetricHorizontal(),
          child: Text("Rank",style: PoppinsSemiBold(15, textColor, TextDecoration.none),),
        ),
        Padding(
          padding: paddingSemetricHorizontal(),
          child: Text("Member".tr(context),style: PoppinsSemiBold(15, textColor, TextDecoration.none),),
        ), Padding(
          padding: paddingSemetricHorizontal(),
          child: Text("Points".tr(context),style: PoppinsSemiBold(15, textColor, TextDecoration.none),),
        ),
      ],
    );
  }
  static void ShowRankMembers(MediaQueryData mediaQuery, BuildContext context) {

    context.read<MembersBloc>().add(getRanksOfMembers(true));

    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: backgroundColored,

   
        context: context, builder: (context) => SingleChildScrollView(
          child: Container(
          
          
          height: mediaQuery.size.height ,
          child: Column(
            children: [
          
              MemberImpl.MembersWithRanks(mediaQuery),
          
            ],
          )),
        ));
  }
  static Widget showHighestRankMembers( BuildContext context,Member member) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(v: 10, h: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: paddingSemetricVertical(),
            child: SizedBox(

                width: MediaQuery.of(context).size.width,
                child: Text("Discover the Member of Month".tr( context),
                  overflow: TextOverflow.ellipsis,
                  style: PoppinsSemiBold(MediaQuery.devicePixelRatioOf(context)*5, textColorBlack, TextDecoration.none),)),
          ),
          InkWell(
            onTap:(){
              ShowRankMembers(MediaQuery.of(context), context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width ,
              decoration: BoxDecoration(

boxShadow: [
  BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
],

                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundColored, textColorWhite],
                  stops: [0.0, 0.7],
                ),
                borderRadius: BorderRadius.circular(15),


              ),
              child: Padding(
                padding:paddingSemetricVerticalHorizontal(v: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PhotoReeact(member, 90),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,

                            child: Text("${member.firstName} ${member.lastName}",
                                textAlign: TextAlign.center,
                                style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none))),

                        Text("${member.points}  Pts",
                            textAlign: TextAlign.center,
                            style: PoppinsSemiBold(16, PrimaryColor, TextDecoration.none)),

                      ],
                    ),
                  ],
                ),
              ),

            ),
          ),
        ],
      ),
    );
  }
}