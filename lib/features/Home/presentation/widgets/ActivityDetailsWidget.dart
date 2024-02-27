import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';
import 'package:jci_app/features/Home/data/model/events/EventModel.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/MeetingModel.dart';
import 'package:jci_app/features/Home/presentation/bloc/DescriptionBoolean/description_bool_bloc.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../auth/presentation/widgets/Text.dart';
import '../../domain/entities/Activity.dart';

class ActivityDetail extends StatelessWidget {
  final Activity activity;
  const ActivityDetail({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(

            children:[

            ImageCard(mediaQuery),
               Back(mediaQuery,context),
        dots(context,mediaQuery),



            ]

        ),
        Padding(
          padding: EdgeInsets.all(mediaQuery.size.height / 33),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
            rowName(mediaQuery),


  PartipantsRow(mediaQuery),

              SizedBox(height: mediaQuery.size.height / 40,),
              infoCircle(mediaQuery),
              SizedBox(height: mediaQuery.size.height / 40,),

              Description(mediaQuery),
              SizedBox(height: mediaQuery.size.height / 40,),
//Align(
  //alignment: Alignment.topLeft,

    //child: Text("Maps",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*5, textColorBlack, TextDecoration.none), ))
            ],

          ),
        )
      ],
    );
  }

  Widget Description(mediaQuery)=>Container(
    width: mediaQuery.size.width / .9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
border: Border.all(color: textColorBlack,width: 2)

    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Description",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*7, PrimaryColor, TextDecoration.none),),

            DescriptionToggle(description: activity.description,),
          ],
        ),
      ),
    ),
  );
  Widget ImageCard(mediaQuery)=>  activity.CoverImages.isNotEmpty ?
  ClipRRect(
      borderRadius: ActivityRaduis,
      child: Image.memory(base64Decode(activity.CoverImages[0]!),fit: BoxFit.contain,)):
  ClipRRect(
    borderRadius: ActivityRaduis,
    child: Container(
      height: mediaQuery.size.height / 3.5,
      width: double.infinity,
      color: Colors.grey,
    ),
  );


  Widget dots(BuildContext context,MediaQueryData mediaQuery)=>Positioned(
      top:mediaQuery.size.height / 20,


      right: 10,
      child:  GestureDetector(
        onTap: (){
          showModalBottomSheet(context: context, builder: (context){
            return     SizedBox(height: mediaQuery.size.height / 4,width: double.infinity,child:


            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:

                [
                  actionRow(mediaQuery,activity,Icons.edit,"Update"),
                  actionRow(mediaQuery,activity,Icons.delete,"Delete"),
                ]

            )



              ,);

          });
        },
        child: Container(
          height: mediaQuery.size.height / 15,
          decoration: BoxDecoration(
              color: BackWidgetColor,
              shape: BoxShape.circle
          ),
          child: SvgPicture.string(DotsSvg,color: Colors.black,width: 20,height: 40,),

        ),
      )


  );
  Widget rowName(mediaQuery)=>Align(
    alignment: Alignment.topLeft,


    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(activity.name,style: PoppinsSemiBold(mediaQuery.devicePixelRatio*9, textColorBlack, TextDecoration.none),),
    if (activity.runtimeType == EventModel)
    Text("By ${(activity as EventModel).LeaderName}",style: PoppinsLight(mediaQuery.devicePixelRatio*5, textColorBlack),),
      if (activity.runtimeType == MeetingModel)
        Text("By ${(activity as MeetingModel).Director}",style:PoppinsLight(mediaQuery.devicePixelRatio*5, textColorBlack),)
      ,if (activity.runtimeType == TrainingModel)
        Text("By ${(activity as TrainingModel).ProfesseurName}",style: PoppinsLight(mediaQuery.devicePixelRatio*5, textColorBlack),)




      ],
    ),
  );
  Widget Back(mediaQuery,context)=>Positioned(
      top:mediaQuery.size.height / 20,
      left: 10,
      child:  GestureDetector(
        onTap:(){
          GoRouter.of(context).go('/home');
        },
        child: Container(
          height: mediaQuery.size.height / 15,

          decoration: BoxDecoration(
              color: BackWidgetColor,
              shape: BoxShape.circle
          ),
          child: SvgPicture.string(pic,width: 20,height: 42,),
        ),
      )


  );
  String calculateDurationDays(DateTime beginDateTime, DateTime endDateTime) {
    final duration = endDateTime.difference(beginDateTime);

    if (duration.inDays > 0) {
      final dateFormat = DateFormat('EEEE');
      final timeFormat = DateFormat('HH:mm');

      return '${dateFormat.format(beginDateTime)} - ${dateFormat.format(endDateTime)}';
    } else {
      return ' ${DateFormat('EEEE').format(beginDateTime)} ';
    }
  }  String calculateDurationhour(DateTime beginDateTime, DateTime endDateTime) {
    final duration = endDateTime.difference(beginDateTime);
    final dateFormat = DateFormat('EEE HH:mm a');
    final timeFormat = DateFormat('HH:mm a');
    if (duration.inDays > 0) {

      return ' ${
          dateFormat.format(beginDateTime)} - ${dateFormat.format(endDateTime)}';

    } else {
      return '${timeFormat.format(beginDateTime)} - ${timeFormat.format(endDateTime)}';
    }
  }
  String DisplayDuration(DateTime beginDateTime, DateTime endDateTime) {
    final duration = endDateTime.difference(beginDateTime);

    if (duration.inDays > 0) {
      return '${duration.inDays} days';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours';
    } else {
      return '${duration.inMinutes} minutes';
    }
  }
  Widget actionRow(mediaQuery,Activity activity,IconData icon,String action)=>Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [

      Padding(padding: EdgeInsets.symmetric(horizontal:mediaQuery.size.width/30,vertical: mediaQuery.size.height / 40),
        child:  Icon(icon,size: 30,),


      ),

      Padding(
        padding: const EdgeInsets.all(8.0),

        child: Text("${action} ${activity.runtimeType.toString().split("Model")[0]}",style: PoppinsRegular(mediaQuery.devicePixelRatio*8, textColorBlack),),
      ),

    ],);

 Container ispaid(mediaQuery)=> Container(
     width: mediaQuery.size.width / 4,
     decoration: BoxDecoration(
         color: PrimaryColor,
         borderRadius: BorderRadius.circular(15)
     ),
     child: Padding(

         padding: const EdgeInsets.symmetric(horizontal: 8.0),
         child:Center(child: Text(activity.IsPaid? "Paid" : "Free",style: PoppinsRegular(mediaQuery.devicePixelRatio*6, textColorWhite)))));

Widget PartipantsRow(mediaQuery)=>Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text("${activity.Participants.length} People have joined ",style: PoppinsNorml(mediaQuery.devicePixelRatio*5, textColorBlack),),

    ],
    ),
);
Widget infoCircle(mediaQuery)=>Container(

  width: mediaQuery.size.width / .9,
  decoration:  BoxDecoration(

      border: Border.all(color: textColorBlack,width: 2),
borderRadius: BorderRadius.circular(15)


  ),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,


              children:[  Text(DateFormat('MMM').format(activity.ActivityBeginDate),style: PoppinsRegular(mediaQuery.devicePixelRatio*6, textColorBlack),),
                Center(child: Text(DateFormat('dd').format(activity.ActivityBeginDate),style: PoppinsSemiBold(mediaQuery.devicePixelRatio*7, SecondaryColor,TextDecoration.none),)),

              ],

            ),
          ) ,
          SizedBox(
              height: 80,
              child: VerticalDivider(color: textColorBlack,thickness: 2,indent: 0,endIndent:7 ,)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(calculateDurationDays(activity.ActivityBeginDate, activity.ActivityEndDate),style: PoppinsSemiBold(mediaQuery.devicePixelRatio*5, PrimaryColor, TextDecoration.none),),
            ),
              Text(calculateDurationhour(activity.ActivityBeginDate, activity.ActivityEndDate),style: PoppinsRegular(mediaQuery.devicePixelRatio*4.5, textColorBlack),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Place",style: PoppinsRegular(mediaQuery.devicePixelRatio*4.5, PrimaryColor),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(activity.ActivityAdress,style: PoppinsRegular(mediaQuery.devicePixelRatio*4.5, textColorBlack),),
                      ),
                    ],
                  ),
                )
            ],),
          )


        ],

      ),
    ),
  )
);
}
class DescriptionToggle extends StatelessWidget {
  final String description;

  DescriptionToggle({required this.description});

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return BlocBuilder<DescriptionBoolBloc, DescriptionBoolState>(
      builder: (context, state) {
        final truncatedDescription = state.isFullDescription
            ? description:
        description.length < 100? description
            : description.substring(0, 100) + '...';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              truncatedDescription,
              style: PoppinsRegular(mediaquery.devicePixelRatio*4, textColorBlack),
            ),

            if (description.length > 100)

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  radius: 10.0,
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: (){
                    context.read<DescriptionBoolBloc>().add(ShowFullDescriptionEvent());
                  },
                  child: Text(state.isFullDescription ? 'Show less' : 'Show more'


                      ,style: PoppinsSemiBold( mediaquery.devicePixelRatio*5, PrimaryColor, TextDecoration.underline),),
                  ),
                ),

          ],
        );
      },
    );


      }
}
