import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';

import '../bloc/Activity/activity_cubit.dart';

class ActivityDetailsPage extends StatefulWidget {
  final String Activity;
  final String id;
  const ActivityDetailsPage({Key? key, required this.Activity, required this.id}) : super(key: key);

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  late activity act;
  @override
  void initState() {
    if (widget.Activity == 'Meetings') {
   act=activity.Meetings;
      context.read<AcivityFBloc>().add(GetActivitiesByid( id: widget.id, act: activity.Meetings));
    }
    else if (widget.Activity == 'Trainings') {
      act=activity.Trainings;
      context.read<AcivityFBloc>().add(GetActivitiesByid( id: widget.id, act: activity.Trainings));

    }
    else if (widget.Activity == 'Events') {
      act=activity.Events;
      context.read<AcivityFBloc>().add(GetActivitiesByid( id: widget.id, act: activity.Events));
    }
   // if (widget.Activity == 'Events') {
   //context.read<AcivityFBloc>().add(GetActivitiesByid( id: widget.id, act: activity.Events));
    //}
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return  BlocBuilder<AcivityFBloc, AcivityFState>(
  builder: (context, state) {
    return Scaffold(
      bottomNavigationBar: Container(

        decoration: BoxDecoration(
          color: BackWidgetColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ) ,
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height*0.02,horizontal: mediaQuery.size.width*0.05),
          child: SizedBox(

            height: mediaQuery.size.height*0.088,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [  Padding(
                padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width*0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Price",style: PoppinsRegular(mediaQuery.devicePixelRatio*7, textColorBlack,),),
                    state is ACtivityByIdLoadedState  && state.activity.IsPaid?
                    Text(state.activity.price.toString() + "dt /Personne",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*7, textColorBlack, TextDecoration.none),):
                    Text("Free",style: PoppinsSemiBold(mediaQuery.devicePixelRatio*7, Colors.green, TextDecoration.none),)
                  ],
                ),
              ),


                ElevatedButton(


                    style: ElevatedButton.styleFrom(

                      backgroundColor: PrimaryColor,


                    ),
                    onPressed: (){}, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.check,color: textColorWhite,size: 30,),

                        Text('Join',style: PoppinsSemiBold(20, textColorWhite, TextDecoration.none),),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            return buildActivityDetailsBody(context, state.selectedActivity, widget.id);
          },
        ),
      ),
    );
  },
);
  }
}
