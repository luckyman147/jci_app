import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';

import '../../../../core/app_theme.dart';

class ActivityOfWeekListWidget extends StatelessWidget {
  final List<Activity> activity;
  const ActivityOfWeekListWidget({
    Key? key,
    required this.activity,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, state) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
    
      itemCount: activity.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            context.go('/activity/${ activity[index].id}/${state.selectedActivity.name}/$index ');

          },
          child: Container(
            height:mediaQuery.size.height/9,
            width: mediaQuery.size.width*0.87 ,
            decoration: ActivityDecoration,
            child: Stack(
              
                children:[
                  Images(mediaQuery, activity, index),
                  cardPos(mediaQuery,activity,index),
                  Details(mediaQuery, activity, index),
                  ButtonComponent(Activities: activity, index: index, top: mediaQuery.size.height / 3.57, left:  mediaQuery.size.width / 2.1, mediaQuery: mediaQuery, act: state.selectedActivity,)
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

Positioned cardPos(MediaQueryData mediaQuery,List<Activity> activity,int index){
  return Positioned(
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
}

 ClipRRect Images(MediaQueryData mediaQuery,List<Activity> activity,int index)=>
     activity[index].CoverImages.isNotEmpty ?
     ClipRRect(
         borderRadius: ActivityRaduis,
         child: Container(
           color: textColor,
           child: Image.memory(base64Decode(activity[index].CoverImages[0]!),fit: BoxFit.cover, height: mediaQuery.size.height / 4.2,
               width: mediaQuery.size.width*0.87 ,
               ),
         )):
     ClipRRect(
       borderRadius: ActivityRaduis,
       child: Container(
         height: mediaQuery.size.height / 4.2,
         width: mediaQuery.size.width / 1,
         color: ThirdColor,
          child: Center(
            child: Text(activity[index].runtimeType.toString().split('Model').first,style: PoppinsSemiBold(20, textColorWhite, TextDecoration.none),),
          ),
       ),
     );
Positioned Details(MediaQueryData mediaQuery,List<Activity> activity ,int index)=>
    Positioned(

  top: mediaQuery.size.height / 3.7,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(activity[index].name,style: PoppinsSemiBold(mediaQuery.devicePixelRatio*6, textColorBlack, TextDecoration.none),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity[index].ActivityAdress,style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColor,),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),

                child: Text("Start At ${DateFormat('h:mm a').format(activity[index].ActivityBeginDate)}",
                  style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColor,),),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);