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
import 'Functions.dart';

class GuestWidget extends StatelessWidget {
  final List<Guest> guests;
  final String activityId;
  final int index  ;


   GuestWidget({ required this.guests, required this.activityId, required this.index}) ;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'guestFormKey0');  PageController pageController = PageController();
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();


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


        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),

            itemCount: 2,
            onPageChanged: (int page) {
           context.read<ActivityCubit>().selectIndex(page);

            },
            itemBuilder: (BuildContext context, int index) {
              if (state.index == 0)
              return buildguests(context);
              else {
                return buildAddGuest(context, controller, controller2, controller3);
              }
              },
         
            
          );
  },
),
        ),
      ],
    );
  }
Widget buildAddGuest(BuildContext context, TextEditingController controller, TextEditingController controller2, TextEditingController controller3 ) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.outlined(onPressed: (){
                  context.read<ActivityCubit>().selectIndex(0);

                }, icon: Icon(Icons.arrow_back)),
                Text("Add Guest",textAlign: TextAlign.center, style: PoppinsRegular(16, textColorBlack, )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: ()=>null, child: Text("Already Exists",style: PoppinsSemiBold(15, PrimaryColor, TextDecoration.underline),)),
                  ],
                )
            ]),
            biuildguiestfiels(controller, "Enter Name", TextInputType.text, "Name"),
            biuildguiestfiels(controller2, "Enter Email", TextInputType.emailAddress, "Email"),
            biuildguiestfiels(controller3, "Enter Phone Number", TextInputType.phone, "Phone Number"),
            TextButton(onPressed: (){

              ActivityAction.  AddGuest(_formKey, controller, controller2, controller3, context,activityId);
            }, child: Text("Add Guest", style: PoppinsRegular(15, PrimaryColor,))
            )
          ]
        ),
      ),
    );
}



Padding biuildguiestfiels(TextEditingController controller, String HintText, TextInputType keyboardType,String labetext) {
  return Padding(
            padding: paddingSemetricVerticalHorizontal(),
            child: TextFormField(
              style: PoppinsRegular(15, textColorBlack, ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: keyboardType,

              controller: controller,
              decoration: InputDecoration(
                labelText: '$labetext',
                border: border(PrimaryColor),
                hintText: HintText,
                hintStyle: PoppinsRegular(15, textColor, ),
                focusColor: PrimaryColor,
                focusedBorder: border(PrimaryColor),

                labelStyle: PoppinsRegular(15, textColorBlack, ),
              ),
            ),
          );
}
  Column buildguests(BuildContext context) {
    return Column(
              children: [
                SingleChildScrollView(
                  key: PageStorageKey("guests"),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActivityDetailsComponent.searchField((p0) {
                        context.read<ParticpantsBloc>().add(SearchGuestByname(name: p0));
                      }, "Search Guest",true),
                      IconButton.outlined(onPressed: (){
                        context.read<ActivityCubit>().selectIndex(1);
                  
                      }, icon: Icon(Icons.arrow_forward)),
                    ],
                  ),
                ),
            guests.isNotEmpty?
                Expanded(
                  child: ListView.builder(

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
    return InkWell(
      splashColor: Colors.transparent,
      onLongPress: (){
ActivityAction.        DeleteGestFunction(context, guest,activityId);
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: guest.isConfirmed ? Colors.green : textColorWhite,
          borderRadius: BorderRadius.circular(15),

        ),

        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                child: Text(guest.name,
                  overflow: TextOverflow.ellipsis,
                  style:  PoppinsSemiBold(15, guest.isConfirmed?textColorWhite:textColorBlack, TextDecoration.none),),
              )
            ],
          ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                  SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      !guest.isConfirmed ? Icons.check_circle : Icons.cancel,
      color: guest.isConfirmed ? textColorWhite: textColorBlack,

                    ),
                    onPressed: () {
                ActivityAction.      ConfirmPreence(guest, context,activityId);

                    },
                  ), IconButton(
                                  onPressed: () {
                                    ActivityAction.showGuestDetails(context, guest);
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
      ),
    );
  }


}



