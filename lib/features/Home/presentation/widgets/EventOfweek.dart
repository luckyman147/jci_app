import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/features/Home/domain/entities/Event.dart';

import '../../../../core/app_theme.dart';

class EventsOfWeekListWidget extends StatelessWidget {
  final List<Event> Events;
  const EventsOfWeekListWidget({
    Key? key,
    required this.Events,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ListView.separated(
      scrollDirection: Axis.horizontal,

      itemCount: Events.length,
      itemBuilder: (context, index) {
        return Container(
          height:mediaQuery.size.height/9,
          width: mediaQuery.size.width*0.87 ,
          decoration: ActivityDecoration,
          child: Stack(

              children:[
                Images(mediaQuery, Events, index),
                cardPos(mediaQuery,Events,index),
                Details(mediaQuery, Events, index),
              ]
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(width: 20,);  },

    );
  }
}

Positioned cardPos(MediaQueryData mediaQuery,List<Event> Events,int index){
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
              child: Text(Events[index].ActivityBeginDate.day.toString(),style: PoppinsSemiBold(23, PrimaryColor, TextDecoration.none),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 29.0),
              child: Text(DateFormat('MMM').format(Events[index].ActivityBeginDate),style: PoppinsNorml(20, textColorBlack),),
            ),
          ],
        ),
      ),
    ),
  );
}


 ClipRRect Images(MediaQueryData mediaQuery,List<Event> Events,int index)=>
     Events[index].CoverImages.isNotEmpty ?
     ClipRRect(
         borderRadius: ActivityRaduis,
         child: Image.memory(base64Decode(Events[index].CoverImages[0]!),fit: BoxFit.contain,)):
     ClipRRect(
       borderRadius: ActivityRaduis,
       child: Container(
         height: mediaQuery.size.height / 4.2,
         width: mediaQuery.size.width / 1,
         color: Colors.grey,
       ),
     );
Positioned Details(MediaQueryData mediaQuery,List<Event> Events ,int index)=>
    Positioned(

  top: mediaQuery.size.height / 3.7,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(Events[index].name,style: PoppinsSemiBold(mediaQuery.devicePixelRatio*6, textColorBlack, TextDecoration.none),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Events[index].ActivityAdress,style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColor,),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),

                child: Text("Start At ${DateFormat('h:mm a').format(Events[index].ActivityBeginDate)}",
                  style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColor,),),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);