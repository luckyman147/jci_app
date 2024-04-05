import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';
import 'package:jci_app/features/Home/presentation/widgets/ErrorDisplayMessage.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/EventSelection.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamWidget.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/util/DialogWidget.dart';
import '../../../Home/domain/entities/Activity.dart';
import '../../../Home/domain/entities/Event.dart';
import '../../../Teams/data/models/TeamModel.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../Teams/presentation/widgets/DetailTeamWidget.dart';
import '../../../auth/domain/entities/Member.dart';

class ProfileComponents{

  static bool isInitial(StatesBool value)=> value==StatesBool.Initial;
  static bool iTeams(StatesBool value)=> value==StatesBool.Teams;
  static bool iActivities(StatesBool value)=> value==StatesBool.Activities;
  static bool iMembers(StatesBool value)=> value==StatesBool.Members;
  static bool isPoints(StatesBool value)=> value==StatesBool.Points;


static     var boxDecoration = BoxDecoration(
  border: Border.all(color: textColor,width: 1),
  borderRadius: BorderRadius.circular(13),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 1,
      offset: const Offset(0, 1), // changes position of shadow
    ),
  ],
);
  static   Widget BuildInfoRow(IconData icon,String text) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon,color: textColor,),
          Padding(
            padding: paddingSemetricHorizontal(),
            child: Text(text,style: PoppinsRegular(17, textColor, ),),
          ),
        ],
      ),
    );
  }
  static Widget ExpandedContainer( BuildContext context,bool isExpanded,Widget body,String header,StatesBool state,MediaQueryData mediaQuery){
  return   Padding(
    padding: paddingSemetricVerticalHorizontal(),
    child: AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isExpanded ? mediaQuery.size.width/1.17 : mediaQuery.size.width/1.17,
      height: isExpanded ? mediaQuery.size.height/4 : 70,
      decoration:boxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(header,style: PoppinsSemiBold(17, textColorBlack,TextDecoration.none ),),
                IconButton(
                  onPressed: (){
                    if (isExpanded) {
                      context.read<ChangeSboolsCubit>().changeState(StatesBool.Initial);}
                    else {
                      context.read<ChangeSboolsCubit>().changeState(state);
                    }                 },
                  icon: Icon(!isExpanded?Icons.arrow_downward:Icons.arrow_upward,color: textColorBlack,),
                )
              ],
            ),
            isExpanded ? Expanded(child: SingleChildScrollView(child: body)) : SizedBox(),

          ],
        ),
      ),
    ),
  );
  }

  static   Widget CircleProfile(Member member) {
    log("member ${member.Images}");
    return member.Images.isNotEmpty ?
    SizedBox(
      width: 80,
      height: 80,
      child: CircleProgressBar(
        foregroundColor: PrimaryColor,
        backgroundColor: textColorWhite,
        value: 0.2,
        child: phot(member.Images[0]['url']),
      ),
    ):
    NoPHoto();
  }

  static Container phot(String member) {

    return Container(
      width: 80,
      height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,

        ),

        child:CircleAvatar(
          radius: 100,
          backgroundImage: MemoryImage(base64Decode(member),scale: 5),
        )
        );
  }

  static SizedBox NoPHoto() {
    return SizedBox(

    width: 80,
    height: 80,
    child: CircleProgressBar(
      backgroundColor: textColorWhite,
      foregroundColor: PrimaryColor,
      value: 0.2
      ,
      child: Container(


        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: textColor
        ),

      ),
    ),
  );
  }
static Widget hh(Member member){
 return SizedBox(
      height: 280,
      width: 350,
      child: Stack(
      children: [
      Center(
      child: Container(
      height: 180,
      width: 350,
      decoration: boxDecoration
  ),
  ),

  //use the positioned widget to place

  Positioned(
  top: 0,
  right: 0,
  left: 0,
  child: CircleProfile(member)
  ),

   Positioned(
  top: 85,
  left: 0,
  right: 0,
  child: Column(
    children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(member.firstName+' ',style: PoppinsSemiBold(21, textColorBlack, TextDecoration.none),),
        Text(member.lastName+' ',style: PoppinsSemiBold(21, textColorBlack, TextDecoration.none),),
        member.is_validated?Icon(Icons.verified,color: PrimaryColor,):SizedBox()
      ]
      ),
        Center(child: Text(member.role.toUpperCase(),style: PoppinsSemiBold(17, SecondaryColor,TextDecoration.none ),)),

    ],
  )
  ),


        Positioned(
            top: 150,

            child:
        Padding(
          padding: paddingSemetricHorizontal(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            member.phone.isNotEmpty?
            BuildInfoRow( Icons.phone, member.phone):SizedBox(),
            SizedBox(height: 10,),
            BuildInfoRow( Icons.email, member.email),

          ],),
        ))



  ],
  ),
  );}

  static Widget BuildPointsWidget(Member member){
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Column(

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(' Total Points',style: PoppinsRegular(18, textColor, ),),
              Text(' Cotisation',style: PoppinsRegular(18, textColor, ),),
            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding:paddingSemetricHorizontal(h: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(member.points.toInt().toString(),style: PoppinsSemiBold(25, textColorBlack,TextDecoration.none ),),
                    Text("Points",style: PoppinsLight(18, textColorBlack, ),),
                  ],
                ),

                Text("${FunctionMember.CalculateCotisation(member.cotisation)}/2" ,style: PoppinsSemiBold(25, textColorBlack,TextDecoration.none ),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget TeamsComponent(Member member, MediaQueryData mediaQuery) {

    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.6, // Adjust the height constraint as needed
        ),
        child: ListView.separated(
          itemBuilder: (context, index) {
            log( member.teams[index].toString());
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ImageCard(mediaQuery, TeamModel.fromJson(member.teams[index]), 40),
                    Text(
                      member.teams[index]['name'],
                      style: PoppinsRegular(17, textColorBlack),
                    ),
                  ],
                ),

IsPublic(member.teams[index]['status'])
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(width: mediaQuery.size.width/2,
              child: Divider(color: textColor,height: 12,),);
          },
          itemCount: member.teams.length,
        ),
      ),
    );
  }
static Widget ActivitiesComponent(List<dynamic> activities,MediaQueryData mediaQuery){
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: 50,

            ),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    constraints: BoxConstraints(
                      minHeight: 50,

                    ),
                    child: MyActivityButtons())),
          ),
          SizedBox(height: 10,),
          BlocBuiulderActivities(mediaQuery, activities),
        ],
      ),
    );
}

static Container BlocBuiulderActivities(MediaQueryData mediaQuery, List<dynamic> activities) {
  return Container(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * 0.6,
maxWidth:  mediaQuery.size.width*0.6              // Adjust the height constraint as needed
          ),
          child: BlocBuilder<ActivityCubit, ActivityState>(
            builder: (context, state) {
              if (state.selectedActivity==activity.Meetings )
          {
            if (activities[0]['Meetings'].isNotEmpty) {
              return listViewActivities(
                  activities[0]['Meetings'], mediaQuery);
            }
            else{
              return MessageDisplayWidget(message: "no Meetings found ");
            }

          }

              else if (state.selectedActivity==activity.Trainings ){
                if (activities[0]['Trainings'].isNotEmpty) {
                  return listViewActivities(
                      activities[0]['Trainings'], mediaQuery);
                }
                else{
                  return MessageDisplayWidget(message: "no Trainings found ");
                }
              }
              else {
                if (activities[0]['Events'].isNotEmpty){
                return listViewActivities(activities[0]['Events'], mediaQuery);}
                else{
                  return MessageDisplayWidget(message: "no Events found ");
                }
            }


            },
          ),
        );
}

static ListView listViewActivities(List<dynamic> activities, MediaQueryData mediaQuery) {
  return ListView.separated(itemBuilder: (context,index){
            log(activities[index].toString());
            return Row(
              children: [
                imageEventWidget(Activity.fromImages(activities[index] ), mediaQuery),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  //  Text(activities[index]['name'],style: PoppinsRegular(17, textColorBlack),),
                   // membersTeamImage(context,mediaQuery, activities[index]['Members'].length,activities[index]['Members'],20,30 )

                  ],
                )
              ],
            );

          },
              separatorBuilder:(context,index) =>SizedBox(height: 10,), itemCount: activities.length);
}


static  Stack imagezChanged(String member,MediaQueryData mediaQuery,BuildContext context) {

  final ImagePicker picker = ImagePicker();

  return Stack(
    children: [
      Positioned(child:
      ClipOval(
        child: member.isEmpty || member == "assets/images/jci.png"
            ? Image.asset(
          "assets/images/jci.png",
          fit: BoxFit.contain,
          width: 120,
          height: 120,
        )
            : Image.file(
          File(member),
          fit: BoxFit.contain,
          width: 120,
          height: 120,
        ),
      ),








      ),

    Positioned(
      bottom: 10,

      right: 0,
      child: Container(
        height: 30,
        width: 30,
        child: IconButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(PrimaryColor)),
          icon: Center(child: Icon(Icons.edit,color: textColorWhite,size: 15,)), onPressed: () async {
  final XFile? picked =
  await picker.pickImage(source: ImageSource.gallery);
  if (picked != null) {
  context
      .read<TaskVisibleBloc>()
      .add(ChangeImageEvent( picked.path));
  }
  },),
      ),)


    ],
  );
}



  static Padding SaveChangesButton(Member member,TextEditingController firstName,
      TextEditingController lastName,TextEditingController phone,
      String imagepath,BuildContext context,GlobalKey<FormState> formKey
      ) {
    return Padding(
      padding: paddingSemetricHorizontal(h: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: SecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: (){
                if     (!formKey.currentState!.validate()) {
                  return;
                }
                else {
                  final memberUpdate = Member(
                    id: member.id,
                    firstName: firstName.text,
                    lastName: lastName.text,
                    phone: phone.text,
                    email: member.email,
                    Images: [imagepath],
                    cotisation: member.cotisation,
                    teams: member.teams,
                    Activities: member.Activities,
                    points: member.points,
                    IsSelected: member.IsSelected,
                    role: 'member ',
                    is_validated: member.is_validated,
                    password: 'password',
                  );
                  context.read<MembersBloc>().add(
                      UpdateMemberProfileEvent(memberUpdate));
               formKey.currentState!.reset();
                  context.read<MembersBloc>().add(GetUserProfileEvent(true));


                }
              }, child: Text("Save Changes",style: PoppinsSemiBold(20, textColorWhite, TextDecoration.none
          ),)),
        ],
      ),
    );
  }
 static Widget TextfieldNum(String name, String hintText,
      TextEditingController controller, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            autofocus: true,
            autocorrect: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              onChanged(value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            style: PoppinsRegular( 18, textColorBlack),
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only digits allowed
              LengthLimitingTextInputFormatter(8), // Limit to 8 characters
            ],
            decoration: decorationTextField(null)
          ),
        ],
      ),
    );
  }

static Widget dropNumber()=> Expanded(

  child: DropdownButton<String>(
    value: '+216', // Initially selected value
    onChanged: (String? newValue) {
      // Handle dropdown value change
      // You can use newValue if needed
    },
    items: <String>['+216',"+88"] // Dropdown items
        .map<DropdownMenuItem<String>>(
          (String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ),
    )
        .toList(),
  ),
);



}


