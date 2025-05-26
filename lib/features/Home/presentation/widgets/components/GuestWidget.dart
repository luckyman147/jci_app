import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/features/Home/domain/Dtos/GuestParam.dart';
import 'package:jci_app/features/Home/domain/entities/guest/Guest.dart';
import 'package:jci_app/features/Home/domain/usercases/ActivityUseCases.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../../../MemberSection/domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../../../MemberSection/domain/entity/ActionDetails.dart';
import '../../../../MemberSection/domain/entity/Objectif.dart';
import '../../../../MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import '../../../domain/entities/guest/ActivityGuest.dart';
import '../../../domain/enums/ParticipantWithEvents.dart';
import '../../bloc/Activity/BLOC/guests/guests_bloc.dart';
import '../../bloc/Activity/activity_cubit.dart';
import '../Activity/ActivityDetailsComponents.dart';
import '../Activity/ActivityImplWidgets.dart';
import '../Functions/Functions.dart';
import '../Implementations/GuestPartcipantsImpl.dart';

class GuestWidget extends StatefulWidget {
  final List<ActivityGuest> guests;
  final String activityId;
  final int index  ;


   const GuestWidget({super.key,  required this.guests, required this.activityId, required this.index}) ;
  @override
  State<GuestWidget> createState() => _GuestWidgetState();

static   Row GuestInfo(BuildContext context, Guest guest,bool act) {
    return Row(
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
                height: 30,
                width: 30,
                child:Image.asset(vip,color:act?textColorWhite:textColorBlack ,)
            )),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.5,
              child: Text(guest.name,
                overflow: TextOverflow.ellipsis,
                style:  PoppinsSemiBold(15, guest.isConfirmed || act ?textColorWhite:textColorBlack, TextDecoration.none),),
            )
          ],
        );
  }
static Widget GuestALL(BuildContext context,List<Guest> guests,String activityId)=>
    Column(
      children: [
        SingleChildScrollView(
      
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [

              IconButton.outlined(onPressed: (){
                context.read<ActivityCubit>().selectIndex(1);

              }, icon:const  Icon(Icons.arrow_back)),
              ActivityDetailsComponent.searchField((p0) {
                context.read<GuestsBloc>().add(SearchGuestActByname(name: p0));
              }, "${"Search".tr(context)} ${"Visitor".tr(context)}",true),
              IconButton.outlined(onPressed: (){
                context.read<ActivityCubit>().selectIndex(0);

              }, icon:const  Icon(Icons.home_filled)),
            ],
          ),
          
        ),
        guests.isNotEmpty?
        Expanded(
          child: ListView.separated(

            itemCount: guests.length,
            itemBuilder: (context, index) {
              return _BuiltAllGuestCard(context, guests[index],activityId);
            }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,); },
          ),
        ):Center(
          child: IconButton.outlined(
        
            


     onPressed: () {

       context.read<ActivityCubit>().selectIndex(1);

     }, icon: const Icon(Icons.add),),
        )
      ],
    );

  static Widget _BuiltAllGuestCard(BuildContext context, Guest guest, String activityId) {
    return BlocBuilder<GuestsBloc, GuestsState>(
  builder: (context, state) {
    final String? status=ActivityAction.CheckIfGuestExist(state.Activeguests, guest);
    return InkWell(
      splashColor: Colors.transparent,
      onLongPress: (){
        ActivityAction.        DeleteGestFunction(context, guest,activityId);
      },
      onDoubleTap: (){
       chngetomember(context, guest);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsApp.PrimaryColor),
          color: status==null? textColorWhite : status=="present" || status=='pending'? Colors.green:Colors.red,
          borderRadius: BorderRadius.circular(15),



        ),

        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GuestInfo(context, guest,status!=null),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  const SizedBox(width: 4),
                  status==null?
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color:  textColorBlack,

                    ),
                    onPressed: () {
                      final guestact=ActivityGuest(guest: guest, status: "pending");
                      final param=guestParams(guest: guestact, guestId: guest.id, status: status, activityid: activityId);
                      context.read<GuestsBloc>().add(AddGuestToActivityEvent( params: param));
                      context.read<ActivityCubit>().selectIndex(0);
                      context.read<GuestsBloc>().add(GetGuestsOfActivityEvent(activityId: activityId));


                    }
                  ):const SizedBox(), IconButton(
                    onPressed: () {
                      ActivityAction.showGuestDetails(context, guest);
                    },
                    icon: Icon(Icons.contact_support,color:
                    status!=null? textColorWhite: textColorBlack,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  },
);
  }

  static void chngetomember(BuildContext context, Guest guest) {
    showDialog(context: context, builder: (context)=>AlertDialog(
       title: Text("Change To Member".tr(context)),
       content: Column(
         children: [
           Text("Do you want to add to Change this visitor to be a member in JCI?".tr(context)),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               TextButton(onPressed: (){
                 Navigator.pop(context);
               }, child: Text("Cancel".tr(context),style: PoppinsRegular(15, textColor),)),
               TextButton(onPressed: (){
                 context.read<GuestsBloc>().add(ChangeGuestToMemberEvent( params: guest.id));
                 Navigator.pop(context);
               }, child: Text("Save".tr(context),style: PoppinsRegular(15, PrimaryColor),)),
             ],
           )
         ],
       ),

    ));
  }

}

class _GuestWidgetState extends State<GuestWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'guestFormKey0');
  PageController pageController = PageController();
  TextEditingController controller = TextEditingController();

  TextEditingController controller2 = TextEditingController();

  TextEditingController controller3 = TextEditingController();
  @override
  void dispose() {

    controller.dispose();
    controller2.dispose();
    controller3.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParticpantsBloc, ParticpantsState>(
  listener: (context, state) {
    if (state.status == ParticpantsStatus.ToMember) {
      SnackBarMessage.showSuccessSnackBar( message:"changed succefully",context: context);
      Navigator.pop(context);
    }
    // TODO: implement listener
  },
  child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: paddingSemetricHorizontal(),
              child: Text("Guests", style: PoppinsRegular(20, textColorBlack, )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${widget.guests.length} ${"Visitor".tr(context)}s", style: PoppinsLight(15, textColorBlack, )),
            ),
          ],
        ),
        Expanded(

          child: BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, state) {
    return PageView.builder(


        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),

            itemCount: 3,
            onPageChanged: (int page) {
           context.read<ActivityCubit>().selectIndex(page);

            },
            itemBuilder: (BuildContext context, int index) {
              if (state.index == 0) {
                return buildguests(context);
              } else  if (state.index == 1){
                return buildAddGuest(context, controller, controller2, controller3);
              }
              return ShowAllGuests(widget.activityId);
              },


          );
  },
),
        ),
      ],
    ),
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

                }, icon: const Icon(Icons.arrow_back)),
                Text("${"Add".tr(context)} ${"Visitor".tr(context)}",textAlign: TextAlign.center, style: PoppinsRegular(16, textColorBlack, )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      context.read<GuestsBloc>().add(const GetAllGuestsEvent(isUpdated: true));

                      context.read<ActivityCubit>().selectIndex(2);

                    }, child: Text("Already Exists".tr(context),style: PoppinsSemiBold(15, PrimaryColor, TextDecoration.underline),)),
                  ],
                )
            ]),
            biuildguiestfiels(controller, "Name".tr(context), TextInputType.text, "Name".tr(context),context),
            biuildguiestfiels(controller2, "Email".tr(context), TextInputType.emailAddress, "Email".tr(context),context),
            biuildguiestfiels(controller3, "Phone Number".tr(context), TextInputType.phone, "Phone Number".tr(context),context),
            TextButton(onPressed: (){

              ActivityAction.  AddGuest(_formKey, controller, controller2, controller3, context,widget.activityId);
            }, child: Text("${"Add".tr(context)} ${"Visitor".tr(context)}", style: PoppinsRegular(15, PrimaryColor,))
            )
          ]
        ),
      ),
    );
}

Padding biuildguiestfiels(TextEditingController controller, String HintText, TextInputType keyboardType,String labetext,BuildContext ctx) {
  return Padding(
            padding: paddingSemetricVerticalHorizontal(),
            child: TextFormField(
              style: PoppinsRegular(15, textColorBlack, ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text'.tr(ctx);
                }
                return null;
              },
              keyboardType: keyboardType,

              controller: controller,
              decoration: InputDecoration(
                labelText: labetext,
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
                  key: const PageStorageKey("guests"),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActivityDetailsComponent.searchField((p0) {
                        context.read<GuestsBloc>().add(SearchGuestByname(name: p0));
                      }, "${"Search".tr(context)} ${"Visitor".tr(context)}",true),
                      IconButton.outlined(onPressed: (){
                        context.read<ActivityCubit>().selectIndex(1);

                      }, icon: const Icon(Icons.arrow_forward)),
                    ],
                  ),
                ),
            widget.guests.isNotEmpty?
                Expanded(
                  child: ListView.separated(

                    itemCount: widget.guests.length,
                    itemBuilder: (context, index) {
                      return _buildGuestCard(context, widget.guests[index]);
                    }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,); },
                  ),
                ):Center(
                  child: IconButton.outlined(
                      style:ButtonStyle(


    shape: WidgetStateProperty.all(const CircleBorder()),
    )
,
    onPressed: (){
                    context.read<ActivityCubit>().selectIndex(1);
                  },
                      icon: const Icon(Icons.add,size: 40,)),
                )
              ],
            );
  }

  Widget _buildGuestCard(BuildContext context, ActivityGuest guest) {
    return InkWell(
      splashColor: Colors.transparent,
      onLongPress: (){
ActivityAction.        DeleteGestFunction(context, guest.guest,widget.activityId);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: guest.status=="present" ? Colors.green : guest.status=="absent"?Colors.red:ColorsApp.textColorWhite,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: textColorBlack),



        ),

        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          GuestWidget.GuestInfo(context, guest.guest,guest.status=="present" ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      guest.status!="present" ? Icons.check_circle : Icons.cancel,
      color: guest.status=="present"? textColorWhite: textColorBlack,

                    ),
                    onPressed: () {
                      if (guest.status!="present") {
                        ActivityAction.      ConfirmPreence(guest.guest, context,widget.activityId,"present");
                        context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
                          UpdateObjectiveProgressDTO(
                              userId:  "", // Provide the actual user ID
                              actionType: ObjectifActionType.CheckIn.name,
                              feature: [FeaturesType.Guests.name ],
                              progress: 1
                          ),
                        );

                      } else {
                        ActivityAction.      ConfirmPreence(guest.guest, context,widget.activityId,"absent");
                        context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
                          UpdateObjectiveProgressDTO(
                              userId:  "", // Provide the actual user ID
                              actionType: ObjectifActionType.CheckIn.name,
                              feature: [FeaturesType.Guests.name ],
                              progress: -1
                          ),
                        );

                      }

                    },
                  ), IconButton(
                                  onPressed: () {
                                    ActivityAction.showGuestDetails(context, guest.guest);
                                  },
                                  icon: Icon(Icons.contact_support,color:
                                    guest.status=="present" ? textColorWhite: textColorBlack,
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



