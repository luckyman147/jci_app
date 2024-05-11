
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/ActivityParticpants.dart';
import 'package:jci_app/features/Home/domain/usercases/ActivityUseCases.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/MemberSelection.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import '../../../Teams/presentation/widgets/DetailTeamComponents.dart';
import '../../../Teams/presentation/widgets/DetailTeamWidget.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../data/model/TrainingModel/TrainingModel.dart';
import '../../data/model/events/EventModel.dart';
import '../../data/model/meetingModel/MeetingModel.dart';
import '../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';
import '../bloc/DescriptionBoolean/description_bool_bloc.dart';
import '../bloc/PageIndex/page_index_bloc.dart';
import '../pages/CreateUpdateActivityPage.dart';
import 'ActivityImplWidgets.dart';
import 'AddActivityWidgets.dart';
import 'AddUpdateFunctions.dart';
import 'Compoenents.dart';
import 'Functions.dart';
import 'ShimmerEffects.dart';
enum actionD { edit, Add }

class ActivityDetailsComponent{
  static Widget searchField(Function(String )onsearch ,String  hintText,bool isRow)=>Padding(
    padding: paddingSemetricVerticalHorizontal(),
    child: SizedBox(
      height: 50,
      width:isRow?250: double.infinity,

      child: TextField(
        onChanged: onsearch,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: PoppinsRegular(15, textColor),
          prefixIcon: Icon(Icons.search),
          border: border(textColorBlack),
            focusedBorder: border(PrimaryColor),
            enabledBorder: border(PrimaryColor),
        ),
      ),
    ),
  );
  
  
  
 static  Widget Description(mediaQuery,Activity activitys) => Padding(
    padding:  EdgeInsets.symmetric(horizontal:mediaQuery.size.width/20,vertical: 10),
    child: Align(
      alignment: Alignment.topLeft,
      child: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, state) {
          var boxDecoration = BoxDecoration(
                    color: textColorWhite,
                    border: Border.all(color: textColorBlack,),
                    borderRadius: BorderRadius.circular(10),
                  );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (activitys.runtimeType == MeetingModel)
                AgendaWidget(boxDecoration, context, mediaQuery, activitys),
              Padding(
                padding: paddingSemetricVertical(),
                child: Container(
                  width: mediaQuery.size.width ,
                  decoration: boxDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${"About".tr(context)} ${state.selectedActivity.name.tr(context)}",
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
              ),
            ],
          );
        },
      ),
    ),
  );

 static   Widget buildAddButtonWi(BuildContext context,String act,String work) {
   return AddButtonWi( PrimaryColor,  textColorBlack,  Icons.add_rounded,  () {

     Navigator.of(context).push(
       MaterialPageRoute(
         builder: (BuildContext context) {
           return  CreateUpdateActivityPage(id: 'id', activity: act, work: work, part: [],);
         },
       ),
     );


     context.read<ChangeSboolsCubit>().ChangePages('/home','/create/${"id"}/$act/$work/${[]}');

   });
 }

 static Widget ParticipantsWidget(List<ActivityParticipants>  partipants,String activityid,BuildContext ctx)=>

     Container(

       decoration: BoxDecoration(
         border: Border.all(color: textColor,),
         borderRadius: BorderRadius.circular(10),
       ),
       child: Column(
         children: [
           ActivityDetailsComponent.searchField((p0) {
     ctx.read<ParticpantsBloc>().add(SearchMemberByname(name: p0));
     }

               , "Search participant",false),

           Expanded(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListView.separated(

                 itemCount: partipants.length,
                 itemBuilder: (ctx, index) {
                   final participant = partipants[index];

                   Color tileColor;
                   switch (participant.status) {
                     case 'pending':
                       tileColor = textColorWhite; // Change color for pending status
                       break;
                     case 'present':
                       tileColor = Colors.green; // Change color for present status
                       break;
                     case 'absent':
                       tileColor = Colors.red; // Change color for absent status
                       break;
                     default:
                       tileColor = textColorWhite;
                   }

                   return PartcipantsBody(tileColor, participant, activityid, ctx);
                 }, separatorBuilder: (BuildContext context, int index) {
                   return SizedBox(height: 11,);
               },
               ),
             ),
           ),
         ],
       ),
     );

 static SingleChildScrollView PartcipantsBody(Color tileColor, ActivityParticipants participant, String activityid, BuildContext ctx) {
   return SingleChildScrollView(
             scrollDirection: Axis.horizontal,
             child: Container(
               width: MediaQuery.of(ctx).size.width * 0.9,
               decoration: BoxDecoration(
                 color: tileColor,
                 borderRadius: BorderRadius.circular(16),
               ),
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         imageWidget(Member.fromImages(participant.member[0]), 30, 18,participant.status=="pending"),
                       ],
                     ),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         participant.status!="absent"?
                         AbsenceButton(participant, activityid, ctx,Icons.close,(){
                           final param = ParticipantsParams(ActivityId: activityid, partipantId: participant.member[0]["_id"], status: "absent");
                           ctx.read<ParticpantsBloc>().add(CheckAbsenceEvent(params: param));

                         }):SizedBox(),
                         participant.status!="present"?
                         AbsenceButton(participant, activityid, ctx, Icons.check, () {
                           final param = ParticipantsParams(ActivityId: activityid, partipantId: participant.member[0]["_id"], status: "present");
                           ctx.read<ParticpantsBloc>().add(CheckAbsenceEvent(params: param));
                           // Add your logic to check participant
                         }):SizedBox()

                       ],
                     ),
                   ],
                 ),
               ),
             ),
           );
 }

 static IconButton AbsenceButton(ActivityParticipants participant, String activityid, BuildContext ctx,IconData icon,Function() onPressed) {
   return IconButton.outlined(
                           style: OutlinedButton.styleFrom(
                               side: BorderSide(color: participant.status == 'pending' ? textColorBlack : textColorWhite)
                           ),
                           icon: Icon(icon, color: participant.status == 'pending' ? textColorBlack : textColorWhite),
                           onPressed: () {
                            onPressed();
                             // Add your logic to remove participant
                           },
                         );
 }

 
 
 static Container AgendaWidget(BoxDecoration boxDecoration, BuildContext context, mediaQuery, Activity activitys) {
   return Container(
     width: mediaQuery.size.width ,
     decoration: boxDecoration,
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             "Agenda".tr(context),
             style: PoppinsNorml(
               mediaQuery.devicePixelRatio * 6,
               textColorBlack,
             ),
           ),
           SizedBox(
             height: 50 *  (activitys as MeetingModel).agenda.length.toDouble(), // Adjust the height as needed
             child: ListView.separated(
               itemCount: (activitys as MeetingModel).agenda.length,
               itemBuilder: (context, index) {
                 var i = (activitys as MeetingModel).agenda[index];
                 return Column(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 8.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(
                             '${index+1}. ${i.split('(').first}',
                             style: PoppinsLight(
                               mediaQuery.devicePixelRatio * 5,
                               textColorBlack,
                             ),
                           ),
                           Text(
                             "${i.split('(').last.split('min )').first.trim().replaceAll(RegExp(r'\s'), '')} min",
                             style: PoppinsLight(
                               mediaQuery.devicePixelRatio * 5,
                               textColorBlack,
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 );
               },
               separatorBuilder: (BuildContext context, int index) {
                 return SizedBox(height: 10);
               },
             ),
           ),
         ],
       ),
     ),
   );
 }

 static   Widget ImageCard(mediaQuery,Activity activitys) => activitys.CoverImages.isNotEmpty
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

 static  Widget dots(BuildContext context, MediaQueryData mediaQuery,Activity activitys ) => Positioned(
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
            context.read<ParticpantsBloc>().add(LoadIsParttipatedList(activityId: activitys.id));

            ACtionACtivities(context, mediaQuery, activitys);
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

 static void ACtionACtivities(BuildContext context, MediaQueryData mediaQuery, Activity activitys) {
   showModalBottomSheet(
     isScrollControlled: true,
showDragHandle: true,
       useSafeArea: true,

       clipBehavior: Clip.antiAliasWithSaveLayer,
       context: context,
       builder: (context) {
         return SingleChildScrollView(
           child: SizedBox(
             height: mediaQuery.size.height ,
             width: double.infinity,
             child: Column(
               children: [
                 Column(
                   children: [
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Row(
                           children: [
                             BackButton(
                               color: textColorBlack,
                               onPressed: () {
                                 Navigator.pop(context);
                               },
                             ),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 "Participants",
                                 style: PoppinsNorml(mediaQuery.devicePixelRatio * 6,
                                   textColorBlack, ),
                               ),
                             ),
                           ],
                         ),Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(
                             "${activitys.Participants.length} member",
                             style: PoppinsNorml(mediaQuery.devicePixelRatio * 4,
                               textColorBlack, ),
                           ),
                         ),
                       ],
                     ),

                     Padding(
                       padding: paddingSemetricHorizontal(),
                       child: SizedBox(
                          height: mediaQuery.size.height / 3.5,

                           child: ShowPartipants(activitys.id)),
                     )
                   ],
                 ),

                 Padding(padding: paddingSemetricVerticalHorizontal(),child:
                   SizedBox(
                       height: mediaQuery.size.height / 2.5,
                       child: ShowGuests(activitys.id)),
                   ),

                DEleteEditACtivityWidget(mediaQuery, activitys, context),
               ],
             ),
           ),
         );
       });
 }

 static Widget DEleteEditACtivityWidget(MediaQueryData mediaQuery, Activity activitys, BuildContext context) {
   return Container(
     margin: EdgeInsets.symmetric(horizontal: 15),
                 height: mediaQuery.size.height / 7,
                 decoration: BoxDecoration(

               border: Border.all(color: textColor, width: 1),
                   borderRadius: BorderRadius.circular(10),
                 ),
                 child: Row(


                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       actionRow(mediaQuery, activitys, textColorBlack, Icons.timer_rounded, "Reminder", () => 
                           context.read<ParticpantsBloc>().add(SendReminderEvent(activityId: activitys.id))

                           , context)

,
                       actionRow(mediaQuery, activitys, textColorBlack,
                           Icons.edit, "Update".tr(context),
                               (){
                                 AddUpdateFunctions.UpdateAction(context, activitys);



                           }
                     ,  context),
                       BlocBuilder<ActivityCubit, ActivityState>(
                   builder: (context, state) {
                     return actionRow(mediaQuery, activitys,Colors.red, Icons.delete, "Delete".tr(context), () {
                       AddUpdateFunctions. DeleteAction(context, activitys,state);

                       }
                    ,context   );
                   },
                 ),


                     ]),
               );
 }



 static  Widget rowName(mediaQuery,BuildContext context,Activity activitys,activity act, int index) => Padding(
    padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 40,horizontal: 10),
    child: Align(
      alignment: Alignment.center,
      child: Container(
        width: mediaQuery.size.width ,
        decoration:  BoxDecoration(
          border: Border.all(color: textColorBlack),
            color: textColorWhite,
            borderRadius: BorderRadius.all(Radius.circular(10)),

        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: mediaQuery.size.width / 3,
                child: Text(
                  activitys.name,
                  overflow: TextOverflow.ellipsis,

                  style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 5,
                      textColorBlack, TextDecoration.none),
                ),
              ),
            //  PriceWidget(mediaQuery, activitys, context),

              SizedBox(

                width: mediaQuery.size.width/2,
                child: ActivityDetailsComponent.PartipantsRow(
                    mediaQuery, context, activitys, act, index),
              ),

            ],
          ),
        ),
      ),
    ),
  );

 static Container PriceWidget(mediaQuery, Activity activitys, BuildContext context) {
   return Container(
                width: mediaQuery.size.width / 5,
                height: mediaQuery.size.height / 15,
                decoration: BoxDecoration(
                    color: PrimaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(activitys.price.toString()=="0"? "Free".tr(context):"${activitys.price.toString()} dt" ,
                        style: PoppinsSemiBold(
                            mediaQuery.devicePixelRatio * 4, PrimaryColor, TextDecoration.none)),
                  ),
                ));
 }
 static  Widget Back(mediaQuery, context) => Positioned(
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
 static  Widget header(MediaQueryData mediaQuery, context) => SafeArea(
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



  Container ispaid(mediaQuery,BuildContext context,Activity activitys) => Container(
      width: mediaQuery.size.width / 4,
      decoration: BoxDecoration(
          color: PrimaryColor, borderRadius: BorderRadius.circular(15)),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
              child: Text(activitys.IsPaid ? "Paid".tr(context) : "Free".tr(context),
                  style: PoppinsRegular(
                      mediaQuery.devicePixelRatio * 6, textColorWhite)))));

 static  Widget PartipantsRow(MediaQueryData mediaQuery,BuildContext context,Activity activitys,activity act,int index) => SingleChildScrollView(
   scrollDirection: Axis.horizontal,
   child: Row(

     children: [
       DeatailsTeamComponent.membersTeamImage(context,mediaQuery,activitys.Participants.length,activitys.Participants,20,30),
       BlocBuilder<ParticpantsBloc, ParticpantsState>(
    builder: (context, state) {
      return Padding(
         padding: paddingSemetricHorizontal(h:15),
         child:

         FutureJoinButton(state, index, activitys, act, mediaQuery, mediaQuery.size.width / 3, mediaQuery.devicePixelRatio * 3.5),

       );
    },
   ),


     ],
   ),
 );

 static AnimatedSwitcher FutureJoinButton(ParticpantsState state, int index, Activity activitys, activity act, MediaQueryData mediaQuery,double width,double textsize) {
   return AnimatedSwitcher(
       duration: Duration(milliseconds: 1000), // Set the duration for the animation
       child: FutureBuilder(
         future: ActivityAction.checkifMemberExist(state.isParticipantAdded[index]["participants"].cast<Map<String, dynamic>>()),// Your asynchronous function that returns a Future
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             // Show a loading indicator while data is being fetched
             return ShimmerButton.buildShimmerButton(width, 60);
           } else if (snapshot.hasError) {
             // Show an error message if an error occurs
             return ShimmerButton.buildShimmerButton(width, 60);
           } else {
             // Show the ParticipateButton with data when data is available
             return AnimatedSwitcher(
               duration: Duration(milliseconds: 500), // Set the duration for the animation
               child: ParticipateButton(
                 key: UniqueKey(), // Ensure widget is rebuilt when its properties change
                 acti: activitys,
                 index: index,
                 isPartFromState: snapshot.data!,
                 act: act,
                 textSize: textsize,
                 containerWidth: width,
               ),
             );
           }
         },
       ),
);
 }

 static  Widget kk(mediaQuery,Activity activitys)=>Padding(
   padding: paddingSemetricVerticalHorizontal(h: 20),
   child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        IconInfo(Icons.place),



        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: mediaQuery.size.width/1.5,
              height: 60,
              child: Padding(
                padding:paddingSemetricVerticalHorizontal(),
                child: Text(
                  activitys.ActivityAdress,

                  style: PoppinsSemiBold(
                      mediaQuery.devicePixelRatio * 5, textColorBlack,TextDecoration.none),
                ),
              ),
            ),
          ],
        ),

      ],
    ),
 );










 static  Widget infoCircle(mediaQuery,Activity activitys) => SingleChildScrollView(
   child: SizedBox(
     height: mediaQuery.size.height/5.5,
   
     child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
   crossAxisAlignment: CrossAxisAlignment.start,
   
        children: [
          Padding(
            padding: paddingSemetricHorizontal(h:20),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
   
              children: [
                IconInfo(Icons.calendar_month),
   
                Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEE MMM yyyy').format(activitys.ActivityBeginDate),
                        style: PoppinsSemiBold(
                            mediaQuery.devicePixelRatio * 4.5, textColorBlack,TextDecoration.none),
                      ),
                      Row(
                        children: [
   
                          Text(
                              ActivityAction. calculateDurationhour(activitys.ActivityBeginDate, activitys.ActivityEndDate),
                            style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 3.5,
                                textColor, TextDecoration.none),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
   
   
         kk(mediaQuery,activitys),
   
        ],
      ),
   ),
 );

 static Container IconInfo(IconData icon) {
   return Container(
              width: 50,
              height:50,
              decoration: BoxDecoration(
                 border: Border.all(color: textColorBlack), shape: BoxShape.circle),
              child: Icon(icon, color: textColorBlack),

            );
 }
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

Widget actionRow(
    mediaQuery, Activity activity, Color color,IconData icon, String action,Function() onTap,BuildContext context) =>
    InkWell(
      onTap:onTap ,
      child: Padding(
        padding: paddingSemetricVerticalHorizontal(),
        child: Container(
          width: mediaQuery.size.width / 4,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${action} ${activity.runtimeType.toString().split("Model")[0].tr(context)}",
                  textAlign: TextAlign.center,
                  style: PoppinsRegular(
                      mediaQuery.devicePixelRatio * 4, color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
