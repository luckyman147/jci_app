import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';
import 'package:jci_app/features/Home/presentation/widgets/ErrorDisplayMessage.dart';
import 'package:jci_app/features/Home/presentation/widgets/MemberSelection.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/EventSelection.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamWidget.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/config/services/verification.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/util/DialogWidget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../Home/domain/entities/Activity.dart';
import '../../../Home/domain/entities/Event.dart';
import '../../../Teams/data/models/TeamModel.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../Teams/presentation/widgets/DetailTeamComponents.dart';
import '../../../Teams/presentation/widgets/DetailTeamWidget.dart';
import '../../../auth/data/models/Member/AuthModel.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../domain/usecases/MemberUseCases.dart';
import '../pages/memberProfilPage.dart';
import 'BottomShettMember.dart';

class ProfileComponents{

  static bool isInitial(StatesBool value)=> value==StatesBool.Initial;
  static bool iTeams(StatesBool value)=> value==StatesBool.Teams;
  static bool iActivities(StatesBool value)=> value==StatesBool.Activities;
  static bool iMembers(StatesBool value)=> value==StatesBool.Members;
  static bool isPoints(StatesBool value)=> value==StatesBool.Points;
  static bool isObjectif(StatesBool value)=> value==StatesBool.Objectifs;
  static bool isJCI(StatesBool value)=> value==StatesBool.JCI;


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
    return Padding(
      padding:paddingSemetricVerticalHorizontal(),
      child: Center(
        child: Container(
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon,color: textColorBlack,),
                Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Text(text,style: PoppinsRegular(17, textColorBlack, ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  static Widget ExpandedContainer( BuildContext context,bool isExpanded,Widget body,String header,StatesBool state,MediaQueryData mediaQuery,double width,double height){
  return   Padding(
    padding: paddingSemetricVerticalHorizontal(),
    child: AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isExpanded ? width:width,
      height: isExpanded ? height : 70,
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

  static   Widget CircleProfile(Member member,BuildContext context){

    return member.Images.isNotEmpty ?
    SizedBox(
      width: 80,
      height: 80,
      child: CircleProgressBar(
        foregroundColor: PrimaryColor,
        backgroundColor: textColorWhite,
        value: FunctionMember.calculateObjectifs(member.objectifs)/member.objectifs.length,
        child: phot(member.Images[0]['url'],context,80),
      ),
    ):
    NoPHoto(80,FunctionMember.calculateObjectifs(member.objectifs)/member.objectifs.length);
  }

  static Container phot(String member,BuildContext context,double height) {
    final imageBytes = base64Decode(member);
    final image = Image.memory(imageBytes,fit: BoxFit.contain);
    final screenSize = MediaQuery.of(context).size;
    final avatarSize = (screenSize.width / 3).round();

    return Container(
      width: height,
      height: height,


        child:CircleAvatar(
          radius: avatarSize / 2,

    child: SizedBox(

      child: SHAPE(imageBytes, height),
    ),
        )
        );
  }

  static ClipOval SHAPE(Uint8List imageBytes, double height) {
    return ClipOval(
      child: Image.memory(
       imageBytes,
        width: height,
        height: height,
        fit: BoxFit.contain, // Set the fit property of the Image widget to cover the entire CircleAvatar widget
      ),
    );
  }

  static SizedBox NoPHoto(double height,double value) {
    return SizedBox(

    width: height,
    height: height,
    child: CircleProgressBar(
      backgroundColor: textColorWhite,
      foregroundColor: PrimaryColor,
      value: value
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
static Widget hh(Member member,BuildContext context){
 return SizedBox(
      height: 280,
      width: 350,
      child: Stack(
      children: [
      Center(
      child: Container(
      height: 200,
      width: 350,
      decoration: boxDecoration
  ),
  ),

  //use the positioned widget to place

  Positioned(
  top: 0,
  right: 0,
  left: 0,
  child: CircleProfile(member,context)

  ),

   Positioned(
  top: 85,
  left: 0,
  right: 0,
  child: BlocBuilder<MemberManagementBloc, MemberManagementState>(
  builder: (context, state) {
    return Column(
    children: [
      descriptionName(member, state, context),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.role.toUpperCase(),style: PoppinsSemiBold(17, SecondaryColor,TextDecoration.none ),),
            buildFutureBuilder(IconButton(onPressed: (){
              BottomMemberSheet.ShowAdminChangeSheet(context,  member);

            }, icon: Icon(Icons.edit)), true, member.id, (p0) => FunctionMember.isSuperAdminANdNoOwner(member))
          ],
        ),

    ],
  );
  },
)
  ),


        Positioned(
            top: 170,
right: 0,
left: 0,
            child:
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: paddingSemetricHorizontal(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
             Padding(
               padding: paddingSemetricHorizontal(),
               child: buildFutureBuilder(ShowAction(context, member,      (){
                 context.go('/modifyUser?user=${jsonEncode(MemberModel.fromEntity(member).toJson())}');},"Edit Profile"),

                   true, "", (po)=>FunctionMember. isOwner(member.id)),
             )
                ,ShowAction(context, member,      (){          FunctionMember.Showinfo(context, member);},"contact"),
              ],
            ),
          ),
        ))



  ],
  ),
  );}

static ElevatedButton ShowAction(BuildContext context, Member member,Function() onPress,String text) {
  return ElevatedButton(
                onPressed: () {
                  onPress();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(textColorWhite),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: textColor))),
                ),
                child: Text(text,style: PoppinsRegular(17, textColorBlack, ),),
              );
}



static Row descriptionName(Member member, MemberManagementState state, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('${member.firstName} ',style: PoppinsSemiBold(21, textColorBlack, TextDecoration.none),),
      Text('${member.lastName} ',style: PoppinsSemiBold(21, textColorBlack, TextDecoration.none),),
      state.isUpdated?Icon(Icons.verified,color: PrimaryColor,):buildFutureBuilder(IconButton(

          style: ButtonStyle(

            overlayColor: MaterialStateProperty.all(PrimaryColor.withOpacity(0.1)),
            surfaceTintColor: MaterialStateProperty.all(Colors.white),      ),
          onPressed: (){
            context.read<MemberManagementBloc>().add(validateMember( memberid: member.id));

          }, icon: Center(child: Icon(Icons.check_circle_outline,size: 25,))), true, member.id, (p0) => FunctionMember.isAdminAndSuperAdmin())
    ]
    );
}

static Widget BuildObjectifsWidget(Member member,MemberManagementState state,BuildContext context, ){

    return Padding(padding: paddingSemetricVerticalHorizontal(),
      child:SingleChildScrollView(
        child: Column(children: [
          Row( mainAxisAlignment : MainAxisAlignment.end,
            children: [
              Text("${FunctionMember.calculateObjectifs(member.objectifs)}/${member.objectifs.length}",style: PoppinsRegular(17, textColor),),

            ],),
for (var item in member.objectifs) AchivedmentWidget(item['Condition'], item['name']),

         ] ),
      )

    );
}

static Widget AchivedmentWidget(bool isFinished,String text ) {
  return Padding(
    padding: paddingSemetricVertical(),
    child: Row(children: [
            Icon(Icons.check,color: isFinished?PrimaryColor:textColor,),
            Padding(
              padding: paddingSemetricHorizontal(),
              child: Text(text,style: PoppinsSemiBold(17,isFinished?PrimaryColor:textColor,isFinished?TextDecoration.lineThrough:TextDecoration.none ),),
            )

          ],),
  );
}

  static Widget BuildPointsWidget(Member member,MemberManagementState state,BuildContext context, FocusNode pointsFocusNode){
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

          Padding(
            padding:paddingSemetricHorizontal(h: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: paddingSemetricHorizontal(h: 20),
                  child: Text(state.points.toInt().toString(),style: PoppinsSemiBold(25, textColorBlack,TextDecoration.none ),),
                ),

                Text("${FunctionMember.CalculateCotisation(state.cotisation)}/${state.cotisation.length}" ,style: PoppinsSemiBold(25, textColorBlack,TextDecoration.none ),),
              ],
            ),
          ),
          SizedBox(height: 10,),
          buildFutureBuilder(Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.outlined(

                onPressed: () {
                  BottomMemberSheet.showBottomSheet(context, member,  pointsFocusNode);
                }, icon: Icon(Icons.edit,size: 20,),),

            ],

          ), true, member.id, (p0) => FunctionMember.isAdminAndSuperAdmin()),
        ],
      ),
    );
  }
 static  FutureBuilder<bool> buildFutureBuilder(Widget body,bool bolean,String id,Future<bool> Function(String?) isOwner){
    return FutureBuilder(
      builder: (context,asnapshot) {
        if(asnapshot.connectionState==ConnectionState.waiting){
          return SizedBox();
        }
        if (asnapshot.data==bolean){
          return body;

        }
        else{
          return SizedBox();
        }
      }, future: isOwner(id),
    );
  }


  static Widget TeamsComponent(Member member, MediaQueryData mediaQuery,BuildContext context) {

    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.6, // Adjust the height constraint as needed
        ),
        child:
        member.teams.isEmpty?  buildFutureBuilder(AddTeamsWidget(context)
        , true, member.id, (p0) => FunctionMember.isOwner(member.id))   :

        ListView.separated(
          itemBuilder: (context, index) {

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    DeatailsTeamComponent.ImageCard(mediaQuery, TeamModel.fromJson(member.teams[index]).CoverImage, 40),
                    Padding(
                      padding:paddingSemetricHorizontal(),
                      child: SizedBox(
                        width:mediaQuery.size.width/2.5,
                        child: Text(
                          member.teams[index]['name'],
                          overflow: TextOverflow.ellipsis,
                          style: PoppinsRegular(17, textColorBlack),
                        ),
                      ),
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

  static Column AddTeamsWidget(BuildContext context) {
    return Column(
        children: [
          IconButton.outlined(icon:Icon(Icons.add,size: 30,), onPressed: () {
            context.read<PageIndexBloc>().add(SetIndexEvent(index: 2));
            context.go('/home');
            context.read<GetTeamsBloc>().add(GetTeams(isPrivate: false));
          },),
          SizedBox(height: 10,),
          Text('Join Your first Team ',style: PoppinsRegular(17, textColorBlack),),
        ],);
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
        child: member.isEmpty || member == "assets/images/jci.png" ||member == vip
            ? Image.asset(vip
          ,
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
          icon: Center(child: Icon(Icons.camera_enhance,color: textColorWhite,size: 15,)), onPressed: () async {
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



  static Padding SaveChangesButton(Function() onPressed
      ) {
    return Padding(
      padding: paddingSemetricHorizontal(h: 20),
      child: Row(

        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onPressed,
               child: Text("Save Changes",style: PoppinsSemiBold(20, textColorWhite, TextDecoration.none
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

  static Widget MembersWidgetOnlyName(MediaQueryData mediaQuery) {
    return BlocBuilder<MembersBloc,MembersState>(builder: (context,state){

      if (state is AllMembersLoadedState) {
        return SizedBox(
            height: 200,
            child: MembersDetailsOnly(state.members, mediaQuery, ));
      } else {
        return LoadingWidget();
      }
    });
  }

  static Widget MembersDetailsOnly(List<Member> members, MediaQueryData mediaQuery) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: members.length,
      itemBuilder: (context, index) {
        return BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
          builder: (context, state) {
            return InkWell(
              onTap: () {
                if (state.upcomingPages.isNotEmpty) {
                  context.read<ChangeSboolsCubit>().ChangePages(state.upcomingPages[state.upcomingPages.length - 1], "/memberSection/${members[index].id}");
                } else {
                  context.read<ChangeSboolsCubit>().ChangePages("/home", "/memberSection/${members[index].id}");
                }
                context.read<MembersBloc>().add(GetMemberByIdEvent(MemberInfoParams(id: members[index].id,status: true)));

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MemberSectionPage(id: members[index].id);
                    },
                  ),
                );
              },
              child: imageWidget(members[index],30,18,true),
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10,);
      },
    );
  }
}



