

import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

import '../../../../../core/route/app_router.dart';
import '../../../Activity_Global.dart';

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
            context.pushRoute(ActivityDetailsRoute(
              id: activity[index].activityBasics.id,
              activityType: state.selectedActivity.name,
              index: index,
            ));
          },
          child: Container(
            height:mediaQuery.size.height/9,
            width: mediaQuery.size.width*0.97 ,
            decoration: ActivityDecoration,
            child: Stack(
              
                children:[
                  Images(mediaQuery, activity, index),
                  cardPos(mediaQuery,activity,index),
                  Details(mediaQuery, activity, index),
                  ButtonComponent(Activities: activity, index: index, top: mediaQuery.size.height / 3.57, left:  mediaQuery.size.width / 3.5, mediaQuery: mediaQuery, act: state.selectedActivity,)
                ]
            ),
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(width: 10,);  },
    
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
              child: Text(activity[index].activityBasics.activityBeginDate.day.toString().padLeft(2, '0'),style: PoppinsSemiBold(23, PrimaryColor, TextDecoration.none),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 29.0),
              child: Text(DateFormat('MMM').format(activity[index].activityBasics.activityBeginDate),style: PoppinsNorml(20, textColorBlack),),
            ),
          ],
        ),
      ),
    ),
  );
}

 ClipRRect Images(MediaQueryData mediaQuery,List<Activity> activity,int index)=>
     activity[index].activityBasics.coverImages.isNotEmpty ?
     ClipRRect(
         borderRadius: ActivityRaduis,
         child: Container(
           color: textColor,
           child: Image.memory(base64Decode(activity[index].activityBasics.coverImages[0]),fit: BoxFit.cover, height: mediaQuery.size.height / 4.2,
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

          Text(activity[index].activityBasics.name,style: PoppinsSemiBold(mediaQuery.devicePixelRatio*6, textColorBlack, TextDecoration.none),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity[index].activityBasics.activityAdress,style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColor,),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),

                child: Text("Start At ${DateFormat('h:mm a').format(activity[index].activityBasics.activityBeginDate)}",
                  style: PoppinsRegular(mediaQuery.devicePixelRatio*5, textColor,),),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);