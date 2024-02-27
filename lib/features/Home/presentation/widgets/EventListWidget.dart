import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/Event.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';






class ActivityWidget extends StatelessWidget {
  final List<Activity> Activities;
  const ActivityWidget({Key? key, required this.Activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, state) {
    return ListView.separated(itemBuilder:(ctx,index){
      return InkWell(
          highlightColor: Colors.transparent,
          onTap: (){

            context.go('/activity/${ Activities[index].id}/${state.selectedActivity.name}');
          },
            child: Container(
          height: mediaQuery.size.height / 6,
            
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
            Activities[index].CoverImages.isNotEmpty ?
                ClipRRect(
            
                borderRadius:BorderRadius.circular(10),
                child: Image.memory(base64Decode(Activities[index].CoverImages[0]!),fit: BoxFit.cover,height: 99,width: 130,scale: 0.1,)):
            ClipRRect(
              borderRadius:BorderRadius.circular(10),
            
              child: Container(
              height: 99,
              width: 130,
              color: Colors.grey,
            ),
          ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('EEE, MMM, d').format(Activities[index].ActivityBeginDate),
                          style: PoppinsRegular(14, textColorBlack)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("Start at ${DateFormat('h:mm').format(Activities[index].ActivityBeginDate)}",
                            style:PoppinsRegular(14, textColorBlack)
                            ),
                          ),
                        ],
                      ),
                      Text(Activities[index].name,style: PoppinsSemiBold(19,textColorBlack,TextDecoration.none),),
                      Text(Activities[index].ActivityAdress,style:PoppinsSemiBold(17, PrimaryColor, TextDecoration.none),
            
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ParticipateButton(true,mediaQuery),
                      )
                    ],
                  ),
                )
              ]
            ),
          ),
        ),
      );
    } ,
        separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 20,);  },
        itemCount: Activities.length);
  },
);
  }
}





Widget ParticipateButton(bool IsPart,mediaquery){
  return InkWell(
    child: Container(
      height:mediaquery.size.height /23 ,

      decoration:BoxDecoration(
          color: IsPart?PrimaryColor:BackWidgetColor,
        borderRadius: BorderRadius.circular(12)
      ) ,

      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check,color: IsPart?textColorWhite:textColorBlack,),
            Text("Join",style: PoppinsSemiBold(15, IsPart?textColorWhite:textColorBlack, TextDecoration.none),)
          ],
        ),
      ),
    ),
  );
}









class ActivityOfMonthListWidget extends StatelessWidget {
  final List<Activity> Activities;
  const ActivityOfMonthListWidget({
    Key? key,
    required this.Activities,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, state) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
    
      itemCount: Activities.length,
      itemBuilder: (context, index) {
        return GestureDetector(

          onTap: (){

            context.go('/activity/${ Activities[index].id}/${state.selectedActivity.name}');

          },
          child: Container(
              height:mediaQuery.size.height/9,
            width: mediaQuery.size.width / 1.5,
            decoration: ActivityDecoration,
            child: Stack(
              
              children:[
                 images(mediaQuery, Activities, index, mediaQuery.size.height / 4.2,mediaQuery.size.width / 1.5),
                // Widget above the background
                PosCard(mediaQuery, Activities, index),
                details(mediaQuery, Activities, index),
              ]
            ),
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(width: 20,);  },
    
    );
  },
);
  }

}

ClipRRect images(mediaQuery,List<Activity> activity,int index,double height,double width)=>
     activity[index].CoverImages.isNotEmpty ?
    ClipRRect(
        borderRadius: ActivityRaduis,
        child: Image.memory(base64Decode(activity[index].CoverImages[0]!),fit: BoxFit.contain,)):
    ClipRRect(
      borderRadius: ActivityRaduis,
      child: Container(
        height: height,
        width: width,
        color: Colors.grey,
      ),
    );


Positioned details(MediaQueryData mediaQuery, List<Activity> activity,int index)=>Positioned(

  top: mediaQuery.size.height / 3.7,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(activity[index].name,style: PoppinsSemiBold(mediaQuery.devicePixelRatio*6, textColorBlack, TextDecoration.none),),
          Text(activity[index].ActivityAdress,style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColor,),),
          Text("Start At ${DateFormat('h:mm a').format(activity[index].ActivityBeginDate)}",
            style: PoppinsRegular(mediaQuery.devicePixelRatio*4.5, textColor,),),
        ],
      ),
    ),
  ),
);

Positioned PosCard(mediaQuery,List<Activity> activity, int index)=>Positioned(
  top: mediaQuery.size.height / 5.6,
  left: 20,
  child: Container(
    decoration: shadowDecoration,

    height: 60,
    width: 70,
    child: Center(
      child: Stack(


        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(activity[index].ActivityBeginDate.day.toString().padLeft(2, '0'),style: PoppinsSemiBold(23, PrimaryColor, TextDecoration.none),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 29.0),
            child: Text(DateFormat('MMM').format(activity[index].ActivityBeginDate),style: PoppinsNorml(20, textColorBlack),),
          ),

        ],
      ),
    ),
  ),
);
