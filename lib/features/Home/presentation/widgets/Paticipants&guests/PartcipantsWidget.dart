import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/domain/Dtos/PArticipantParam.dart';
import 'package:jci_app/features/Home/domain/enums/AttendeceEmum.dart';
import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../core/app_theme.dart';
import '../../../domain/entities/Activity.dart';
import '../../bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import '../../bloc/Activity/BLOC/guests/guests_bloc.dart';
import '../Activity/ActivityDetailsComponents.dart';
import '../Implementations/GuestPartcipantsImpl.dart';
import 'Components.dart';

class PartcipantsMainwidget extends StatelessWidget {
  final PageController _pageController = PageController();
  final Activity activity;

  PartcipantsMainwidget({
    Key? key,

    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ParticpantsBloc, ParticpantsState>(
  builder: (context, sata) {
    return BlocBuilder<PageIndexBloc, PageIndexState>(
          builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  RowInfoParticpiants(context, mediaQuery),
          Column(
            children: [
              // Header with buttons to change the page index
              SizedBox(


                width: mediaQuery.size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PaticipantsButton( "All",0,state,context),
                       const  SizedBox(width: 7,),
                        PaticipantsButton( "Presents ( ${sata.PresentList.length} )",1,state,context),
                       const  SizedBox(width: 7,),


                        PaticipantsButton( "Absents ( ${sata.AbsentList.length} )",2,state,context),
                        const  SizedBox(width: 7,),

                        PaticipantsButton( "Joined(${activity.Participants.length})",3,state,context),

                      ],
                    ),
                  ),
                ),
              ),
              // PageView for the content
              SizedBox(
                height: mediaQuery.size.height / 1.5,
                width: mediaQuery.size.width,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<PageIndexBloc>().add(
                          SetParticipantIndexEvent( ParticipantIndex: index),
                        );
                  },
                  children: [
                              ShowPartipants(activity.id,activity.Participants),
                PartcipantListWidget(status: Attendance.Present,onAbsent: (){
                  _pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }, activityId: activity.id,),
                PartcipantListWidget(status: Attendance.Absent,
                onAbsent: (){
                  _pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }, activityId: activity.id,
                ),    PartcipantListWidget(status: Attendance.joined,
                onAbsent: (){
                  _pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }, activityId: activity.id,
                ),




                  ],
                ),
              ),
                ],
              ),
           /*   Padding(
                padding: paddingSemetricVerticalHorizontal(),
                child: SizedBox(
                  height: mediaQuery.size.height / 2.5,
                  child:
                ),
              ),
              DeleteEditActivityWidget(activity:  activity),*/
            ],
          ),
                  ],
                  ));
          },
        );
  },
),
      ),
    );
  }

  Widget PaticipantsButton(String title,int index,PageIndexState state, BuildContext ctx) {
    return InkWell(

                  onTap: () {
                    ctx.read<ParticpantsBloc>().add(
                    const  ChangeSelectAll( value: false),
                    );
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );


                  },
                  child:
                  AnimatedContainer(

                    decoration: BoxDecoration(
                    color:                           state.ParticipantIndex == index ? ColorsApp.PrimaryColor : ColorsApp.textColorWhite,
                        border: Border.all(
                          color:  state.ParticipantIndex == index ? ColorsApp.PrimaryColor : ColorsApp.textColorBlack,
                          width: 2,
                        ),


                            borderRadius: BorderRadius.circular(6),



                    ),
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: AutoSizeText( title,
                          style: PoppinsNorml(15.sp,state.ParticipantIndex == index ? ColorsApp.textColorWhite : ColorsApp.textColorBlack),
                        ),
                      ),
                    ),
                  ),
                ).animate(
        effects: [
          const FadeEffect(

            duration: Duration(milliseconds: 500),
          )
        ]
    );
  }

  Row RowInfoParticpiants(BuildContext context, MediaQueryData mediaQuery) {
    return Row(
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
                          "Participants".tr(context),
                          style: PoppinsNorml(
                            mediaQuery.devicePixelRatio * 6,
                            textColorBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${activity.Participants.length} ${"Member".tr(context)}",
                          style: PoppinsNorml(
                            mediaQuery.devicePixelRatio * 4,
                            textColorBlack,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<ParticpantsBloc>().add(
                            DownloadAndSaveExcelEvent(
                              activityId: activity.id,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.download_for_offline,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              );
  }
}

class PartcipantListWidget extends StatelessWidget {
  const PartcipantListWidget({
    super.key, required this.status, this.onAbsent, required this.activityId,
  });
  final Attendance status;
  final Function()? onAbsent;
   final String activityId ;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ParticpantsBloc, ParticpantsState, List<ParticipantsParams>>(
    selector: (state) => status==Attendance.Absent?state.AbsentList:status==Attendance.Present?  state.PresentList:state.joinedList,

      builder: (context, presentList) {

        // Check if the present list is empty
        if (presentList.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // "No Found" image
      const          Icon(
                Icons.not_interested, // You can choose any icon that fits the "Not Found" concept
                size: 50,  // Adjust the size of the icon
                // Customize color
              ),
              const SizedBox(height: 20),

              // Button to show all members
              ElevatedButton(
                onPressed: () {
                  onAbsent!();


                },
                child: Text('Show All Members',style: PoppinsSemiBold(17, ColorsApp.textColorBlack, TextDecoration.none),),
              ),
            ],
          );
        }

        // If the present list is not empty, show the list
        return ParticpantsComponents.ParticipantsWidget(
            presentList, activityId, context);
      },
    );
  }
}
