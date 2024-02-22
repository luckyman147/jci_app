import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/app_theme.dart';

import '../../domain/entities/Event.dart';

class EventsOfMonthListWidget extends StatelessWidget {
  final List<Event> Events;
  const EventsOfMonthListWidget({
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
          width: mediaQuery.size.width / 1.5,
          decoration: const BoxDecoration(

            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(43),
              bottomRight: Radius.circular(43),
              topLeft: Radius.circular(43),
              topRight: Radius.circular(15),
            ),
            color: Colors.white,

          ),
          child: Stack(

            children:[
              Events[index].CoverImages!=null&& Events[index].CoverImages.isNotEmpty ?
              ClipRRect(
                  borderRadius: BorderRadius.only(

                    topLeft: Radius.circular(41),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.memory(base64Decode(Events[index].CoverImages[0]!),fit: BoxFit.contain,)):
                  ClipRRect(
        borderRadius: BorderRadius.only(

        topLeft: Radius.circular(41),
        topRight: Radius.circular(15),),
                    child: Container(
                      height: mediaQuery.size.height / 4.2,
                      width: mediaQuery.size.width / 1.5,
                      color: Colors.grey,
                    ),
                  ),

              // Widget above the background
              Positioned(
                top: mediaQuery.size.height / 5.6,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: textColorWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 17,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]
                  ),

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
              ),
Positioned(

  top: mediaQuery.size.height / 3.7,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(Events[index].name,style: PoppinsSemiBold(mediaQuery.devicePixelRatio*6, textColorBlack, TextDecoration.none),),
          Text(Events[index].ActivityAdress,style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColor,),),
          Text("Start At ${DateFormat('h:mm a').format(Events[index].ActivityBeginDate)}",
            style: PoppinsRegular(mediaQuery.devicePixelRatio*4.5, textColor,),),
        ],
      ),
    ),
  ),
)
            ]
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(width: 20,);  },

    );
  }
}
