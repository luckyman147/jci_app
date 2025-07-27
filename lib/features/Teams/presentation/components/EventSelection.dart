

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../Home/domain/entities/Activitys/Activity.dart';
import '../../../Home/domain/entities/Activity/event/Event.dart';
import '../../../Home/domain/enums/ActivityEnum.dart';
import '../../../Home/domain/enums/SearchType.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';

Widget EventsTeamContainer(mediaQuery,Event item)=>BlocBuilder<FormzBloc, FormzState>(

    builder: (context, state) {
final ff=state.eventFormz.value??Event.eventTest;
return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          imageEventWidget(item,mediaQuery),
          InkWell(
            onTap: () {
              context.read<FormzBloc>().add(EventChanged( eventChanged: item));

            },
            child: AnimatedContainer(
              width: mediaQuery.size.width / 3,
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  color: ff.activityBasics.id == item.activityBasics.id?PrimaryColor:BackWidgetColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1))
                  ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(

                ff.activityBasics.id == item.activityBasics.id?"Selected".tr(context):"Select".tr(context)
                  ,style:PoppinsSemiBold(14,
                               ff.activityBasics.id == item.activityBasics.id?textColorWhite:textColorBlack

                , TextDecoration.none) ,),
              ),
            ),
          )
        ],);
    }
);





Widget EventsTeamBottomSheet(
    mediaQuery



    )=>SizedBox(
  height: mediaQuery.size.height / .9,
  width: double.infinity,
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 10,
    ),
    child: BlocBuilder<FormzBloc, FormzState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Select an event".tr(context),
              style: PoppinsSemiBold(
                mediaQuery.devicePixelRatio * 5,
                PrimaryColor,
                TextDecoration.none,
              ),
            ),
            Padding(
              padding:paddingSemetricVerticalHorizontal(),
              child: SingleChildScrollView(
                child: SizedBox(
                    height: mediaQuery.size.height/3 ,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:

                      EventsWidget(mediaQuery,""),
                    )),
              ),
            )

          ],
        );
      },
    ),
  ),
);
Widget EventsWidget(MediaQueryData mediaQuery,String name)=>

BlocConsumer<AcivityFBloc, AcivityFState>(
  builder: (context, state) {

    switch (state.activityfetchState) {
      case ActivityFetchState.Error:
      case ActivityFetchState.Empty:
        return const SizedBox();
      case ActivityFetchState.ActivityLoaded:
        return RefreshIndicator(
            onRefresh: () {

              return

                RefreshEvents(context,SearchType.All,"");
            },
            child:


            EventsDetails( state.activitiesSearch as List<Event>,mediaQuery)

        );
      default:
        return const LoadingWidget();
    }

  }, listener: (BuildContext context, AcivityFState state) {

});





Future<void> RefreshEvents(BuildContext context,SearchType type,String name) async {
  if (type==SearchType.All||name.isEmpty) {
    context.read<AcivityFBloc>().add(const GetAllActivitiesEvent(act: activity.Events));
  }
  //else
   // context.read<EventsBloc>().add(GetEventByNameEvent(name: name));

}




Widget EventsDetails(List<Event> Events,mediaQuery)=>ListView.separated(
  scrollDirection: Axis.vertical,

  itemCount: Events.length,
  itemBuilder: (context, index) {

    return EventsTeamContainer(mediaQuery, Events[index]);
  },
  separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,);  },

);Widget imageEventWidget(Activity item,mediaQuery){ return Row(
    children: [
      item.activityBasics.coverImages.isEmpty
          ?  ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: 50,
          width: 50,
          color: textColor,
        ),

      )
          :
      ClipRRect(


        borderRadius: BorderRadius.circular(100),
        child: Image.memory(
          base64Decode(item.activityBasics.coverImages.first??""),
          width: 50,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
            width: mediaQuery.size.width/3,
            child: Text(item.activityBasics.name,
              overflow: TextOverflow.ellipsis,
              style: PoppinsSemiBold(18, textColorBlack,TextDecoration.none),)),
      ),

    ]);}

