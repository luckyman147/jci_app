import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';
import 'package:jci_app/features/Home/data/model/events/EventModel.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/MeetingModel.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/DescriptionBoolean/description_bool_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';
import 'package:jci_app/features/Home/presentation/widgets/EventListWidget.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/util/snackbar_message.dart';

import '../../domain/entities/Activity.dart';


class ActivityDetail extends StatelessWidget {
  final Activity activitys;
  final bool bools;
  final activity act;  final int index;
  const ActivityDetail({Key? key, required this.activitys, required this.bools, required this.act, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Stack(

        children: [
          Stack(children: [
            ImageCard(mediaQuery),
            Back(mediaQuery, context),
            header(mediaQuery, context),
            dots(context, mediaQuery),
          ]),
          Padding(
            padding: EdgeInsets.symmetric(vertical:mediaQuery.size.height / 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                rowName(mediaQuery),

                PartipantsRow(mediaQuery),

                SizedBox(
                  height: mediaQuery.size.height / 40,
                ),
                infoCircle(mediaQuery),
                SizedBox(
                  height: mediaQuery.size.height / 40,
                ),

                Description(mediaQuery),
                SizedBox(
                  height: mediaQuery.size.height / 40,
                ),
      //Align(
                //alignment: Alignment.topLeft,

                //child: Text("Maps",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*5, textColorBlack, TextDecoration.none), ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget Description(mediaQuery) => Padding(
    padding:  EdgeInsets.symmetric(horizontal:mediaQuery.size.width/20),
    child: Align(
      alignment: Alignment.topLeft,
      child: BlocBuilder<ActivityCubit, ActivityState>(
    builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (activitys.runtimeType == MeetingModel)
          Container(
            decoration: BoxDecoration(
              color: textColorWhite,
              border: Border.all(color: ThirdColor,width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Agenda",
                    style: PoppinsNorml(mediaQuery.devicePixelRatio * 6,
                        textColorBlack, ),
                  ),
                  for (var i in (activitys as MeetingModel).agenda)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                i.split('(').first,
                                style: PoppinsLight(mediaQuery.devicePixelRatio * 5,
                                    textColorBlack),
                              ),  Text(
                                i.split('(').last.split('min )').first.trim().replaceAll(RegExp(r'\s'), '') + " min",
                                style: PoppinsLight(mediaQuery.devicePixelRatio * 5,
                                    textColorBlack),
                              ),

                            ],
                          ),
                        ),

                        if ((activitys as MeetingModel).agenda.indexOf(i) != (activitys as MeetingModel).agenda.length - 1)
                          SizedBox(
                            child: Divider(
                              color: ThirdColor.withOpacity(.5),
                              thickness: 1,
                            ),)
                      ],
                    ),
                ],
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: mediaQuery.size.width ,
              decoration: BoxDecoration(
                color: textColorWhite,
                border: Border.all(color: ThirdColor,width: 2),

                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Categorie",
                      style: PoppinsNorml(mediaQuery.devicePixelRatio * 6,
                          textColorBlack, ),
                    ),
                    Text("#${activitys.categorie} ", style: PoppinsRegular(mediaQuery.devicePixelRatio * 5, PrimaryColor),),
                  ],
                ),
              ),
            ),
          ),

          Container(
            width: mediaQuery.size.width ,
            decoration: BoxDecoration(
              color: textColorWhite,
              border: Border.all(color: ThirdColor,width: 2),

              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About ${state.selectedActivity.name}",
                    style: PoppinsNorml(mediaQuery.devicePixelRatio * 6,
                        textColorBlack, ),
                  ),

                  DescriptionToggle(
                    description: activitys.description,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  ),
    ),
  );
  Widget ImageCard(mediaQuery) => activitys.CoverImages.isNotEmpty
      ? ClipRRect(

          child: Container(
            color: textColor,
            child: Image.memory(
              base64Decode(activitys.CoverImages[0]!),
              fit: BoxFit.cover,
              height: mediaQuery.size.height / 2.5,
              width: double.infinity,
            ),
          ))
      : ClipRRect(

          child: Container(
            height: mediaQuery.size.height / 2.5,
            width: double.infinity,
            color: backgroundColored,
            child: Image.asset(
              "assets/images/jci.png",
              fit: BoxFit.contain,
            ),
          ),
        );

  Widget dots(BuildContext context, MediaQueryData mediaQuery, ) => Positioned(
      top: mediaQuery.size.height / 20,
      right: 10,
      child: BlocListener<AddDeleteUpdateBloc, AddDeleteUpdateState>(
  listener: (context, state) {
    if (state is DeletedActivityMessage) {
      SnackBarMessage.showSuccessSnackBar(
          message: state.message, context: context);
      context.go('/home');  }



      else if (state is ErrorAddDeleteUpdateState) {
      SnackBarMessage.showErrorSnackBar(
          message: state.message, context: context);
    }
    // TODO: implement listener
  },
  child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: mediaQuery.size.height / 4,
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        actionRow(mediaQuery, activitys,
                          Icons.edit, "Update",
                            (){
                              context.go('/create/${activitys.id}/${activitys.runtimeType == EventModel?
                              activity.Events:
                              activitys.runtimeType == MeetingModel?
                              activity.Meetings:
                              activity.Trainings
                              }/${action.edit.name}/${activitys.Participants}');



                            }
                        ),
                        actionRow(mediaQuery, activitys, Icons.delete, "Delete", () {
                       context.read<AddDeleteUpdateBloc>().add(DeleteActivityEvent(
                           act: activitys.runtimeType == EventModel?
                           activity.Events:
                            activitys.runtimeType == MeetingModel?
                            activity.Meetings:
                         activity.Trainings




                           ,id: activitys.id));

                        }),
                      ]),
                );
              });
        },
        child: Container(
          height:40,
          width: 40,

          decoration:
              BoxDecoration(color: BackWidgetColor, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Icon(Icons.more_horiz_sharp, color: textColorBlack, size: 30),
        ),
      ),
));
  Widget rowName(mediaQuery) => Padding(
    padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 40),
    child: Align(
      alignment: Alignment.center,
      child: Container(
        width: mediaQuery.size.width / 1.2,
        decoration: const BoxDecoration(
            color: textColorWhite,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: ThirdColor,
              blurRadius: 2,

              offset: Offset(0, 0),
            )
          ]
         ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activitys.name,
                    style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 5,
                        textColorBlack, TextDecoration.none),
                  ),
                  if (activitys.runtimeType == EventModel)
                    Text(
                      "By ${(activitys as EventModel).LeaderName}",
                      style: PoppinsNorml(
                          mediaQuery.devicePixelRatio * 5, textColorBlack),
                    ),
                  if (activitys.runtimeType == MeetingModel)
                    Text(
                      "By ${(activitys as MeetingModel).Director}",
                      style: PoppinsRegular(
                          mediaQuery.devicePixelRatio * 5, textColorBlack),
                    ),
                  if (activitys.runtimeType == TrainingModel)
                    Text(
                      "By ${(activitys as TrainingModel).ProfesseurName}",
                      style: PoppinsLight(
                          mediaQuery.devicePixelRatio * 5, textColorBlack),
                    )
                ],
              ),
              Container(
                width: mediaQuery.size.width / 5,
height: mediaQuery.size.height / 15,
                decoration: BoxDecoration(
                    color: PrimaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(activitys.price.toString()=="0"? "Free":"${activitys.price.toString()} dt" ,
                        style: PoppinsSemiBold(
                            mediaQuery.devicePixelRatio * 5.5, PrimaryColor, TextDecoration.none)),
                  ),
                )),


            ],
          ),
        ),
      ),
    ),
  );
  Widget Back(mediaQuery, context) => Positioned(
      top: mediaQuery.size.height / 20,
      left: 10,
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).go('/home');
        },
        child: Container(

          decoration:
              BoxDecoration(color: BackWidgetColor,borderRadius: BorderRadius.all(Radius.circular(10))  ),
          child: SvgPicture.string(
            pic,
            width: 20,
            height: 42,
          ),
        ),
      ));
  Widget header(MediaQueryData mediaQuery, context) => SafeArea(
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            return Padding(
        padding:  EdgeInsets.symmetric(horizontal: mediaQuery.devicePixelRatio*12,vertical: mediaQuery.size.height/28),
        child: Align(
            alignment: AlignmentDirectional.center,
            child: Text("${state.selectedActivity.name} Details",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*5, BackWidgetColor,TextDecoration.none),)),
            );
          },
        ),
      ],
    ),
  );
  String calculateDurationDays(DateTime beginDateTime, DateTime endDateTime) {
    final duration = endDateTime.difference(beginDateTime);

    if (duration.inDays > 0) {
      final dateFormat = DateFormat('EEEE');


      return '${dateFormat.format(beginDateTime)} - ${dateFormat.format(endDateTime)}';
    } else {
      return ' ${DateFormat('EEEE').format(beginDateTime)} ';
    }
  }

  String calculateDurationhour(DateTime beginDateTime, DateTime endDateTime) {
    final duration = endDateTime.difference(beginDateTime);
    final dateFormat = DateFormat('EEE HH:mm ');
    final timeFormat = DateFormat('HH:mm');
    if (duration.inDays > 0) {
      return ' ${dateFormat.format(beginDateTime)} - ${dateFormat.format(endDateTime)}';
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



  Container ispaid(mediaQuery) => Container(
      width: mediaQuery.size.width / 4,
      decoration: BoxDecoration(
          color: PrimaryColor, borderRadius: BorderRadius.circular(15)),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
              child: Text(activitys.IsPaid ? "Paid" : "Free",
                  style: PoppinsRegular(
                      mediaQuery.devicePixelRatio * 6, textColorWhite)))));

  Widget PartipantsRow(MediaQueryData mediaQuery) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(

                  children: [
                    activitys.Participants.length>0?
                   cont():SizedBox(),activitys.Participants.length>1?
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: cont()
                    ):SizedBox(),activitys.Participants.length>2?
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),

                      child: cont(),
                    ):SizedBox(),
                  ],
                ),
                Text(
                  "${activitys.Participants.length}  joined ",
                  style:
                      PoppinsNorml(mediaQuery.devicePixelRatio * 5, textColorBlack),
                ),
              ],
            ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8.0),
             child: ParticipateButton(acti: activitys,index: index,
               isPartFromState: bools, act: act, textSize: mediaQuery.devicePixelRatio*4, containerWidth: mediaQuery.size.width/3                                                 ,),
           )

          ],
        ),
      );

  Widget kk(mediaQuery)=>Column(
    mainAxisAlignment: MainAxisAlignment.start,
   crossAxisAlignment: CrossAxisAlignment.center,

    children: [
      SizedBox(
        width: mediaQuery.size.width/2,
        child: Container(
          width: 50,
          height:50,
          decoration: BoxDecoration(
              color: PrimaryColor.withOpacity(.2), shape: BoxShape.circle),
          child: Icon(Icons.place, color: PrimaryColor),

        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0,left: 15),
        child: Center(
          child: SizedBox(
            height: mediaQuery.size.height/20,

            child:

            activitys.runtimeType.toString().split("Model")[0]=="Meeting"?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Local Menchia",
                    style: PoppinsSemiBold(
                        mediaQuery.devicePixelRatio * 4, textColorBlack,TextDecoration.none),
                  ),
                  Text(
                    "Menchia",
                    style: PoppinsNorml(
                        mediaQuery.devicePixelRatio * 4, textColorBlack,),
                  ),
                ],
              ),
            ):


            Center(
              child: Text(
                 activitys.ActivityAdress,
                style: PoppinsSemiBold(
                    mediaQuery.devicePixelRatio * 4, textColorBlack,TextDecoration.none),
              ),
            ),
          ),
        ),
      ),

    ],
  );










  Widget infoCircle(mediaQuery) => Row(
    mainAxisAlignment: MainAxisAlignment.start,


    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0,),
        child: SizedBox(
          width:mediaQuery.size.width/2.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  width: 50,
                  height:50,
                  decoration: BoxDecoration(
                      color: PrimaryColor.withOpacity(.2), shape: BoxShape.circle),
                  child: Icon(Icons.calendar_month, color: PrimaryColor),

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),

                child: Text(
                  DateFormat('dd MMM yyyy').format(activitys.ActivityBeginDate),
                  style: PoppinsSemiBold(
                      mediaQuery.devicePixelRatio * 4.5, textColorBlack,TextDecoration.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),

                child: Center(
                    child: Text(
                  calculateDurationDays(activitys.ActivityBeginDate, activitys.ActivityEndDate),
                  style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 3.5,
                      ThirdColor, TextDecoration.none),
                )),
              ),Center(
                  child: Text(
                calculateDurationhour(activitys.ActivityBeginDate, activitys.ActivityEndDate),
                style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 3.5,
                    textColor, TextDecoration.none),
              )),
            ],
          ),
        ),
      ),

      SizedBox(
          height: mediaQuery.size.height / 6,
          child:const  VerticalDivider(
            color: BackWidgetColor,
            thickness: 2,
            indent: 0,
            endIndent: 7,
          )),
      Padding(
        padding: EdgeInsets.only(top: mediaQuery.size.height / 25),
        child: SizedBox(
            width: mediaQuery.size.width / 2.5,
            child: Padding(
              padding: EdgeInsets.only(bottom: mediaQuery.size.height / 14),
              child: kk(mediaQuery),
            )),
      ),

    ],
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
            ? description
            : description.length < 100
                ? description
                : description.substring(0, 100) + '...';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              truncatedDescription,
              style: PoppinsLight(
                  mediaquery.devicePixelRatio * 4, textColorBlack),
            ),
            if (description.length > 100)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  radius: 10.0,
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    context
                        .read<DescriptionBoolBloc>()
                        .add(ShowFullDescriptionEvent());
                  },
                  child: Text(
                    state.isFullDescription ? 'Show less' : 'Show more',
                    style: PoppinsSemiBold(mediaquery.devicePixelRatio * 5,
                        PrimaryColor, TextDecoration.underline),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

}
Widget cont()=>Padding(
  padding: const EdgeInsets.symmetric(horizontal: 18.0),
  child: Container(
    height: 30,

    width: 30,
    decoration: BoxDecoration(
        color:ThirdColor,
        border: Border.all(color: textColorWhite, width: 1),
        shape: BoxShape.circle),
  ),
);
Widget actionRow(
    mediaQuery, Activity activity, IconData icon, String action,Function() onTap) =>
    InkWell(
      onTap:onTap ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width / 30,
                vertical: mediaQuery.size.height / 40),
            child: Icon(
              icon,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${action} ${activity.runtimeType.toString().split("Model")[0]}",
              style: PoppinsRegular(
                  mediaQuery.devicePixelRatio * 8, textColorBlack),
            ),
          ),
        ],
      ),
    );