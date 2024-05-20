

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../Home/domain/entities/Activity.dart';
import '../../../Home/domain/entities/Event.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/widgets/ErrorDisplayMessage.dart';
import '../../../Home/presentation/widgets/SearchWidget.dart';

Widget EventsTeamContainer(mediaQuery,Event item)=>BlocBuilder<FormzBloc, FormzState>(

    builder: (context, state) {
final ff=state.eventFormz.value??Event.EventTest;
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
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  color: ff.id == item.id?PrimaryColor:BackWidgetColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1))
                  ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(

                ff.id == item.id?"Selected".tr(context):"Select".tr(context)
                  ,style:PoppinsSemiBold(14,
                               ff.id == item.id?textColorWhite:textColorBlack

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
    if (state is ActivityLoadingState) {
      return LoadingWidget();
    } else if (state is ActivityLoadedState) {
      return RefreshIndicator(
          onRefresh: () {

            return

              RefreshEvents(context,SearchType.All,"");
          },
          child:


          EventsDetails( state.activitys as List<Event>,mediaQuery)

      );

    }

    else if (state is ErrorActivityState) {
      return MessageDisplayWidget(message: state.message);
    }
    return LoadingWidget();
  }, listener: (BuildContext context, AcivityFState state) {

});





Future<void> RefreshEvents(BuildContext context,SearchType type,String name) async {
  if (type==SearchType.All||name.isEmpty)
   context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: activity.Events));
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
      item.CoverImages.isEmpty
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
          base64Decode(item.CoverImages.first??""),
          width: 50,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
            width: mediaQuery.size.width/3,
            child: Text(item.name,
              overflow: TextOverflow.ellipsis,
              style: PoppinsSemiBold(18, textColorBlack,TextDecoration.none),)),
      ),

    ]);}

