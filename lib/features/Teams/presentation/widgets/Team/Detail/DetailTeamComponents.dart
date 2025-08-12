
import 'dart:convert';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:jci_app/features/MemberSection/presentation/components/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/functions/functionMember.dart';
import 'package:jci_app/features/Teams/domain/usecases/TeamUseCases.dart';
import 'package:jci_app/features/Teams/presentation/bloc/members/members_cubit.dart';
import 'package:jci_app/features/Teams/presentation/utils/TaskUtils.dart';
import 'package:jci_app/core/Member.dart';

import '../../../../../../core/PrimitiveUser/User.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../Home/domain/enums/ActionImage.dart';
import '../../../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../../../Home/presentation/widgets/Functions/Functions.dart';

import '../../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../../../MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';



import '../../../../domain/entities/Team/Team.dart';
import '../../../../domain/entities/TeamUser.dart';
import '../../../bloc/GetTasks/get_task_bloc.dart';
import '../../../bloc/GetTeam/get_teams_bloc.dart';
import '../../../bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../utils/MemberUtils.dart';
import '../CreateTeam/CreateTeamWIdgets.dart';
import '../../member/MembersTeamSelection.dart';
import '../../Task/components/TaskComponents.dart';
import '../../Task/details/TaskWidget.dart';
import '../ component/TeamComponent.dart';
import '../implementation/TeamImpl.dart';
import '../ component/TeamWidget.dart';
import 'AddmoreMembersButton.dart';

class DeatailsTeamComponent{









  static SizedBox description(mediaQuery, BuildContext context,Team team ,bool mounted) {

    return SizedBox(
      width: mediaQuery.size.width,


      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,


        children: [



          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText("Description", mediaQuery),
              SingleChildScrollView(
                child: Text(team.meta.description, textAlign: TextAlign.justify,
                  style: PoppinsRegular(
                    mediaQuery.devicePixelRatio * 4, textColorBlack,) ,),
              ),
            ],
          ),

        ],
      ),
    );
  }

  static BlocBuilder<GetTeamsBloc, GetTeamsState> MembersAssignTo(mediaQuery,Team team,bool mounted) {
    return BlocBuilder<GetTeamsBloc, GetTeamsState>(
      builder: (context, state) {
        return SizedBox(

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              GestureDetector(
                onTap: () {
                  TeamMembersShett(context, mediaQuery,team,mounted);},
                child: membersTeamImage(
                    context, mediaQuery, team.members.members.length, team.members.members,20,30),
              ),
       //       AsyncComponents.buildFutureBuilder(elevatedButtonBuildAction("Join",(){
         //       context. read<GetTeamsBloc>().add(JoinTeam(Teamid: team.id));
            //  }), true, "", (p0) => FunctionMember.IsNotExistedAndPublic(team)),
     //       AsyncComponents.buildFutureBuilder(InviteBuitton(context,team), true, "", (p0) => FunctionMember.ischefAndExisted(team))
            ],
          ),
        );
      },
    );
  }

  static IconButton InviteBuitton(BuildContext context,Team team) {
    return IconButton.filled(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(PrimaryColor),

        ),
        onPressed: (){
          context.read<MembersBloc>( ).add(const GetAllMembersEvent(false));
          MemberBottomSheetBuilder(context, MediaQuery.of(context),assignType.Invite,team);


        }, icon:const  Icon(Icons.person_add_alt_1,color: textColorWhite,));
  }

  static ElevatedButton elevatedButtonBuildAction(String text, Function() action) {
    return ElevatedButton(

        style: ElevatedButton.styleFrom(
          backgroundColor: PrimaryColor,

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: action, child: Text(text,style: PoppinsRegular(18, textColorWhite),));
  }

  static   Future<dynamic> TeamMembersShett(BuildContext context, mediaQuery,Team team,bool mounted) {
    return showModalBottomSheet(

        showDragHandle: true,
        context: context,
        builder: (context) {
          //log(Member.toMember(team.Members[0]).toString());
          return SizedBox(
            height: mediaQuery.size.height / 1.5,
            width: mediaQuery.size.width,
            child: SingleChildScrollView(

              child: Padding(
                padding:paddingSemetricVerticalHorizontal(h: 14),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Padding(
                        padding:paddingSemetricHorizontal(),
                        child: Text(" ${team.members.members.length} ${"Members".tr (context)} ",style: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),),
                      ),

                      addMoreMembersButton(context),
                      Padding(
                        padding: paddingSemetricVertical(),
                        child: SizedBox(
                          height: mediaQuery.size.height/1.5,
                          width: mediaQuery.size.width,
                          child: TeamMembers(team,mounted),
                        ),
                      )
                    ]
                ),
              ),
            ),
          );
        });
  }

  static  ListView TeamMembers(Team team,bool mounted) {
    return ListView.separated(
        itemBuilder: (context,index){
          var members = team.members.members;
          final member = members[members.length-index-1];
          return     Padding(
            padding:paddingSemetricHorizontal(h: 10),
            child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
              builder: (context, state) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: InkWell(
                    onLongPress:()async {

                      await MemberUtils.ToMembersSection(team, context, member.user, state,mounted);
                    },
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width:  MediaQuery.of(context).size.width/1.6,
                            child: Row(

                              children: [
                                MemberTeamSelection.  imageWidget(members[members.length-index-1].user),
                        //        AsyncComponents.buildFutureBuilder(const Icon(Icons.person_sharp,),  true, Member.toMember(team.Members[team.Members.length-index-1]).id!, (p0) => FunctionMember.isOwner(Member.toMember(team.Members[team.Members.length-index-1]).id??""))
                              ],
                            ),
                          ),
                        ),
                  //      FunctionMember.isChef(team, team.Members.length-index-1)?
                     //   AsyncComponents.buildFutureBuilder(KickButton(context, team, index), true, "", (p0) => FunctionMember.isChefAndSuperAdmin(team)):
                        const Icon(Icons.stars_sharp,color: PrimaryColor,),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }, separatorBuilder: (context,int){
      return const SizedBox(height: 10,);
    }, itemCount: team.members.members.length);
  }

  static Widget KickButton(BuildContext context, Team team, int index) {
    return TextButton(onPressed: () {
      var members = team.members.members;
      final TeamInput tam=TeamInput(team.meta.id, members[members.length-index-1].user.id.toString(), "kick",members[members.length-index-1]);
      context.read<GetTeamsBloc>().add(UpdateTeamMember(fields: tam));
      Navigator.pop(context);
    }, child: const Icon( Icons.remove_circle,color: Colors.red,),);
  }



  static  Widget ProgessBar(MediaQueryData mediaQuery, BuildContext context,) {


    return BlocBuilder<GetTaskBloc, GetTaskState>(

      builder: (context, state) {    final  sasks = state.Completedtasks;
      double containerWidth = MediaQuery
          .of(context)
          .size
          .width / (state.tasks.length*1.2);
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display containers for true values with red color
              ...state.tasks.toList().asMap().entries.map((entry) {
                if (entry.key == 0) {
                  // Apply border radius to the first container
                  return AnimatedContainer(
                    decoration: const BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    width: containerWidth,
                    height: 10, duration: const Duration(milliseconds: 1000),
                  );
                } else {
                  // Don't apply border radius to the other containers
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    decoration: const BoxDecoration(
                      color: PrimaryColor,
                    ),
                    width: containerWidth,
                    height: 10,
                  );
                }
              }).toList(),
              // Display containers for false values with blue color
              ...state.tasks.toList().asMap().entries.map((entry) {

                if (entry.key == sasks.length - 1) {
                  // Apply border radius to the last container
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    decoration: const BoxDecoration(
                      color: textColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    width: containerWidth,
                    height: 10,
                  );
                }







                else {
                  // Don't apply border radius to the other containers
                  return Container(
                    decoration: const BoxDecoration(
                      color: textColor,
                    ),
                    width: containerWidth,
                    height: 10,
                  );
                }

              }).toList(),
            ],
          ),
        ),
      );
      },
    );}


  static   Widget Header(BuildContext contex, mediaQuery,Team team,bool mounted) =>
     BlocBuilder<PageIndexBloc, PageIndexState>(
          builder: (context, state) {
            return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
              builder: (context, ste) {
                return
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// 👈 Left Section: Back Button + Title or Team Info
                      Row(
                        children: [
                          BackButton(
                            onPressed: () {
                              TaskUtils.ReturnFunbction(context, ste);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              children: [
                                /// 🖼️ Team Image
                                ImageCard(
                                  mediaQuery,
                                  team.meta.coverImage,
                                  mediaQuery.size.height / 20.5,
                                ),
                                const SizedBox(width: 8),

                                /// 🏷️ Team Name
                                Text(
                                  team.meta.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: PoppinsRegular(
                                    18.sp,
                                    textColorBlack,
                                  ),
                                ),

                                AsyncComponents.buildFutureBuilder(IconButton(onPressed: (){}, icon:Icon(Icons.edit) ), PermissionType.canUpdate, Constants.MANAGE_TEAMS)

                              ],
                            ),
                          ),
                        ],
                      ),

                      /// 👉 Right Section: Status Circle + Member Assign Widget

                    ],

                );
              },
            );
          },

      );




  static  void eleteUpdateTeamSHeet(BuildContext context, mediaQuery,Team team  ,bool mounted) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: mediaQuery.size.height / 3,
            width: double.infinity,
            child: ModelShowBottomActions(mediaQuery, context,team,mounted),
          );
        });
  }

  static   Column ModelShowBottomActions(mediaQuery, BuildContext context,Team team,bool mounted) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [





          TeamComponent.actionTeamRow(context,mediaQuery, TeamAction.Upload, Icons.edit, "Update".tr(context), () async{
            context.read<TaskVisibleBloc>().add(ChangeImageEvent(team.meta.coverImage,ActionImage.ADD));
            final  image=  await  ActivityAction.convertBase64ToXFile(team.meta.coverImage);

            if (!mounted) return;
        //    context.go('/CreateTeam?team=${jsonEncode(team.toJson())}&&image=$image');
            context.read<MembersTeamCubit>().initMembers( team.members.members);

            context.read<TaskVisibleBloc>().add(ChangeImageEvent(
                image!=null?
                image.path:"assets/images/jci.png",ActionImage.ADD));

          })

          ,TeamComponent.actionTeamRow(context,mediaQuery, TeamAction.delete, Icons.delete, "Delete".tr(context), () {
            context.read<GetTeamsBloc>().add(DeleteTeam( team.meta.id));
            context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));

          }),

        ]);
  }



  static Widget Circle(Team team, DateTime parse, MediaQueryData mediaQuery,
      BuildContext context) =>
      Column(

          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween
                  , children: [
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.red,),
                    Text('Deadline', style: PoppinsNorml(14, textColorBlack,),),
                  ],
                ),
                Text(DateFormat('MMM,dd').format(parse),
                  style: PoppinsSemiBold(
                      16, textColorBlack, TextDecoration.none),),
              ]
              ),
            ),


          ]
      );


  static Widget ImageCard(
      mediaQuery,
      String image,
      double height,
      ) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(

            color: ColorsApp.BackWidgetColor, // Border color
            width: 2, // Border width
          ),

        ),
        child: ClipRRect(
borderRadius: BorderRadius.circular(15),
          child: image.isNotEmpty
              ? Image.network(
            image,
            fit: BoxFit.contain,
            height: height*1.5,
            width: height*1.5,
          )
              : Container(
            height: height*1.5,
            width: height*1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              images.jcihammem,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );




  static Widget membersTeamImage(BuildContext context, MediaQueryData mediaQuery,
      int length, List<TeamUser> items,double photoheight,double contHeight,{int  limit=3 }) =>
      Row(

        children: [
          for (var i = 0; i < (length > limit ? limit-1 : length); i++)

            PhotoContainer(items.map((e)=>e.user).toList(), i,photoheight),
          if (length > limit)
            alignPhoto(length,contHeight),

        ],
      );

  static Padding PhotoContainer(List<User> item, int i,double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Align(
        widthFactor: .5,
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: textColorWhite,
                  width: 5),
              shape: BoxShape.circle,
            ),
            child: MemberTeamSelection. photo(
                item[i].Images.isNotEmpty
                    ? item[i].Images[0]
                    : "",
                height, 15)),
      ),
    );
  }

  static Align alignPhoto(int number,double height) {
    return Align(
      widthFactor: .5,
      child: NophotoContainer(number,height),
    );
  }

  static Container NophotoContainer(int number,double height) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        border: Border.all(
            color: textColorWhite,
            width: 5),
        color: PrimaryColor,

        shape: BoxShape.circle,
      ),
      // Customize the container as needed
      child: Center(
        child: Text(
          '+ ${number - 2} ',
          style: PoppinsLight(11, textColorWhite),
        ),
      ),
    );
  }}