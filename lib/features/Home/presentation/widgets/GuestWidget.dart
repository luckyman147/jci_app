import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Home/domain/entities/Guest.dart';
import 'package:jci_app/features/Home/domain/usercases/ActivityUseCases.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/AddActivityWidgets.dart';

import '../../../../core/strings/app_strings.dart';
import '../bloc/Activity/activity_cubit.dart';
import 'ActivityDetailsComponents.dart';

class GuestWidget extends StatelessWidget {
  final List<Guest> guests;
  final String activityId;
 
   GuestWidget({Key? key, required this.guests, required this.activityId}) : super(key: key);
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Guests", style: PoppinsRegular(20, textColorBlack, )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${guests.length} guests", style: PoppinsLight(15, textColorBlack, )),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3.2,
          margin: EdgeInsets.all(8),
          decoration:BoxDecoration(
            border: Border.all(color: textColor),

            borderRadius: BorderRadius.circular(15),
          ),
          child: BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, state) {
    return PageView.builder(
            scrollBehavior: ScrollBehavior(),

            scrollDirection: Axis.horizontal,
            controller: pageController,
            itemCount: 2,
            onPageChanged: (int page) {
           context.read<ActivityCubit>().selectIndex(page);

            },
            itemBuilder: (BuildContext context, int index) {
              if (state.index == 0)
              return buildguests(context);
              else {
                return buildAddGuest(context, TextEditingController(), "Name", "Enter Name");
              }
              },
         
            
          );
  },
),
        ),
      ],
    );
  }
Widget buildAddGuest(BuildContext context, TextEditingController controller, String name, String HintText) {
    return SingleChildScrollView(
      child: Column(
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton.outlined(onPressed: (){
                context.read<ActivityCubit>().selectIndex(0);

              }, icon: Icon(Icons.arrow_back)),
              Text("Add Guest",textAlign: TextAlign.center, style: PoppinsRegular(15, textColorBlack, )),
          ]),
          TextfieldNormal(context, name, HintText, controller, (p0) => null),
          TextfieldNormal(context, name, HintText, controller, (p0) => null),
          TextfieldNormal(context, name, HintText, controller, (p0) => null),
          TextButton(onPressed: (){}, child: Text("Add Guest"))

        ]
      ),
    );
}
  Column buildguests(BuildContext context) {
    return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActivityDetailsComponent.searchField((p0) => null, "Search Guest",true),
                      IconButton.outlined(onPressed: (){
                        context.read<ActivityCubit>().selectIndex(1);
                  
                      }, icon: Icon(Icons.arrow_forward)),
                    ],
                  ),
                ),
            guests.isNotEmpty?
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust as needed
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.6,
                    ),
                    itemCount: guests.length,
                    itemBuilder: (context, index) {
                      return _buildGuestCard(context, guests[index]);
                    },
                  ),
                ):Center(
                  child: IconButton.outlined(
                      style:ButtonStyle(


    shape: MaterialStateProperty.all(CircleBorder()),
    )
,
    onPressed: (){
                    context.read<ActivityCubit>().selectIndex(1);
                  },
                      icon: Icon(Icons.add,size: 40,)),
                )
              ],
            );
  }

  Widget _buildGuestCard(BuildContext context, Guest guest) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: guest.isConfirmed ? Colors.green : textColorWhite,
        borderRadius: BorderRadius.circular(15),

      ),

      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
                height: 30,
                width: 30,
                child:Image.asset(vip)
            )),
            Text(guest.name,style:  PoppinsSemiBold(15, guest.isConfirmed?textColorWhite:textColorBlack, TextDecoration.none),)
          ],
        ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    !guest.isConfirmed ? Icons.check_circle : Icons.cancel,
color: guest.isConfirmed ? textColorWhite: textColorBlack,

                  ),
                  onPressed: () {
                    if (guest.isConfirmed) {
                      final param=guestParams(guest: guest, guestId: guest.id, isConfirmed: false, activityid: activityId);
                   context.read<ParticpantsBloc>().add(ConfirmGuestEvent(params: param));
                    } else {
                      final param=guestParams(guest: guest, guestId: guest.id, isConfirmed: true, activityid: activityId);
                      context.read<ParticpantsBloc>().add(ConfirmGuestEvent(params: param));
                    }

                  },
                ), IconButton(
                                onPressed: () {
                                  _showGuestDetails(context, guest);
                                },
                                icon: Icon(Icons.contact_support,color:
                                  guest.isConfirmed ? textColorWhite: textColorBlack,
                                  ),
                              ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGuestDetails(BuildContext context, Guest guest) {
    showDialog(

      context: context,
      builder: (context) {
        return AlertDialog(

          title: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${guest.email}'),
                Text('Phone Number: ${guest.phone}'),

              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}



