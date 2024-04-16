import 'dart:convert';
import 'dart:developer';

import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';

import '../../../../core/app_theme.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../Home/presentation/widgets/Functions.dart';
import '../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import '../../../MemberSection/presentation/pages/memberProfilPage.dart';
import '../../../auth/data/models/Member/AuthModel.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../domain/entities/Team.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/GetTeam/get_teams_bloc.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';
import 'MembersTeamSelection.dart';
import 'TaskComponents.dart';
import 'TaskWidget.dart';
import 'TeamComponent.dart';
import 'TeamImpl.dart';
import 'TeamWidget.dart';

class DeatailsTeamComponent{
  static
  Align buildProgressText(GetTaskState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding:paddingSemetricHorizontal(h: 12),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            state.tasks.isNotEmpty?   const    Icon(Icons.check_circle_outline, color: PrimaryColor, size: 20,):SizedBox()
            ,Text("${calculateSumCompletedTasks(state.tasks)}/${state.tasks.length} ",
              style: PoppinsRegular(16, textColorBlack),),
          ],
        ),
      ),
    );
  }






 static BlocBuilder<GetTaskBloc, GetTaskState> buillLinkedtext(
      MediaQueryData mediaQuery,Team team) {
    return BlocBuilder<GetTaskBloc, GetTaskState>(
      builder: (context, state) {
        return TextButton(onPressed: () {
          ShowAllTasks(context, mediaQuery, state, team);
        },
            child: Text("Show More",
              style: PoppinsSemiBold(
                  mediaQuery.devicePixelRatio*5, PrimaryColor, TextDecoration.underline),));
      },
    );
  }

 static void ShowAllTasks(BuildContext context, MediaQueryData mediaQuery, GetTaskState state, Team team) {
      showModalBottomSheet(

       showDragHandle: true,
       backgroundColor: textColorWhite,
       context: context, builder: (context) {
     return SingleChildScrollView(


         child: BottomTaskSheet(mediaQuery, state.tasks,team));
   });
 }

  static SizedBox description(mediaQuery, BuildContext context,Team team ,bool mounted) {

    return SizedBox(
width: mediaQuery.size.width,


      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,


        children: [


          MembersAssignTo(mediaQuery,team,mounted),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText("Description", mediaQuery),
              SingleChildScrollView(
                child: Text(team.description, textAlign: TextAlign.justify,
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
          width: mediaQuery .size.width/1.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              GestureDetector(
                onTap: () {
                  TeamMembersShett(context, mediaQuery,team,mounted);},
                child: membersTeamImage(
                    context, mediaQuery, team.Members.length, team.Members,30,40),
              ),
              ProfileComponents.buildFutureBuilder(elevatedButtonBuildAction("Join",(){}), true, "", (p0) => FunctionMember.IsNotExistedAndPublic(team)),
              ProfileComponents.buildFutureBuilder(InviteBuitton(), true, "", (p0) => FunctionMember.ischefAndExisted(team))
            ],
          ),
        );
      },
    );
  }

  static IconButton InviteBuitton() {
    return IconButton.filled(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(PrimaryColor),

  ),
  onPressed: (){}, icon: Icon(Icons.person_add_alt_1,color: textColorWhite,));
  }

  static ElevatedButton elevatedButtonBuildAction(String text, Function() action) {
    return ElevatedButton(

                style: ElevatedButton.styleFrom(
                  primary: PrimaryColor,
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
                        child: Text("Board members ( ${team.Members.length} )",style: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),),
                      ),
                      SeachMemberWidget(mediaQuery, context,(value){},false),
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
          final member = Member.toMember(team.Members[team.Members.length-index-1]);
          return     Padding(
            padding:paddingSemetricHorizontal(h: 10),
            child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
              builder: (context, state) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: InkWell(
                    onLongPress:()async {

                      await TeamFunction.ToMembersSection(team, context, member, state,mounted);
                    },
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width:  MediaQuery.of(context).size.width/2,
                          child: Row(

                            children: [
                              imageWidget(Member.toMember(team.Members[team.Members.length-index-1])),
                                        ProfileComponents.buildFutureBuilder(Icon(Icons.person_sharp,),  true, Member.toMember(team.Members[team.Members.length-index-1]).id, (p0) => FunctionMember.isOwner(Member.toMember(team.Members[team.Members.length-index-1]).id))
                            ],
                          ),
                        ),
                        FunctionMember.isChef(team, team.Members.length-index-1)?
                        ProfileComponents.buildFutureBuilder(KickButton(context, team, index), true, "", (p0) => FunctionMember.isChefAndSuperAdmin(team)):
                        Icon(Icons.stars_sharp,color: PrimaryColor,),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }, separatorBuilder: (context,int){
      return SizedBox(height: 10,);
    }, itemCount: team.Members.length);
  }

 static Widget KickButton(BuildContext context, Team team, int index) {
   return TextButton(onPressed: () {
     context.read<GetTeamsBloc>().add(UpdateTeamMember(fields: {"teamid":team.id,"memberid":
     Member.toMember(team.Members[team.Members.length-index-1]).id.toString(),"Status":"kick"}));
   }, child: Icon( Icons.remove_circle,color: Colors.red,),);
 }

 

static  Widget ProgessBar(MediaQueryData mediaQuery, BuildContext context,) {


    return BlocBuilder<GetTaskBloc, GetTaskState>(

      builder: (context, state) {    final  sasks = state.tasks.where((element) => !element['isCompleted']);
      double containerWidth = MediaQuery
          .of(context)
          .size
          .width / (state.tasks.length*1.2);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display containers for true values with red color
            ...state.tasks.where((element) => element['isCompleted']).toList().asMap().entries.map((entry) {
              if (entry.key == 0) {
                // Apply border radius to the first container
                return Container(
                  decoration: BoxDecoration(
                    color: PrimaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  width: containerWidth,
                  height: 10,
                );
              } else {
                // Don't apply border radius to the other containers
                return Container(
                  decoration: BoxDecoration(
                    color: PrimaryColor,
                  ),
                  width: containerWidth,
                  height: 10,
                );
              }
            }).toList(),
            // Display containers for false values with blue color
            ...state.tasks.where((element) => !element['isCompleted']).toList().asMap().entries.map((entry) {

              if (entry.key == sasks.length - 1) {
                // Apply border radius to the last container
                return Container(
                  decoration: BoxDecoration(
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
                  decoration: BoxDecoration(
                    color: textColor,
                  ),
                  width: containerWidth,
                  height: 10,
                );
              }

            }).toList(),
          ],
        ),
      );
      },
    );}


static   Widget Header(BuildContext contex, mediaQuery,Team team,bool mounted) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<PageIndexBloc, PageIndexState>(
          builder: (context, state) {
            return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
              builder: (context, ste) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      BackButton(onPressed: () {
                    TeamFunction.    ReturnFunbction(context, ste);

                      },),
                      SizedBox(
                        width: mediaQuery.size.width / 1.4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child:


                          ste.WillAdded ? Text("Add Task", style: PoppinsSemiBold(
                              mediaQuery.devicePixelRatio * 5, textColorBlack,
                              TextDecoration.none),) : ste.WillDeleted ? Text("Delete Task", style: PoppinsSemiBold(
                              mediaQuery.devicePixelRatio * 5, textColorBlack,
                              TextDecoration.none),) :

                          Row(

                              children: [
                                ImageCard(mediaQuery, team.CoverImage,mediaQuery.size.height / 20.5,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    width: mediaQuery.size.width /3.5,
                                    child: Text(team.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: PoppinsRegular(
                                        mediaQuery.devicePixelRatio * 5,
                                        textColorBlack, ),),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,

                                  decoration: BoxDecoration(
                                    color:! team.status  ? Colors.red : Colors.green,
                                    shape: BoxShape.circle,

                                  ),

                                ),
                                                      ProfileComponents.buildFutureBuilder(IconButton(icon:Icon(Icons.more_vert, color: textColorBlack,), onPressed: () {
                                                eleteUpdateTeamSHeet(context, mediaQuery,team,mounted);
                                                },
                                                ), true, "member", (p0) => FunctionMember.isChefAndSuperAdmin(team))   ,
                              ]
                          ),
                        ),
                      ),

                      IconButton(onPressed: (){}, icon: Icon(Icons.exit_to_app_rounded, color: Colors.red,))

                    ],
                  ),
                );
              },
            );
          },
        ),
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





          TeamComponent.actionTeamRow(mediaQuery, TeamAction.Upload, Icons.edit, "Update", () async{
            context.read<TaskVisibleBloc>().add(ChangeImageEvent(team.CoverImage));
            final  image=  await  ActivityAction.convertBase64ToXFile(team.CoverImage);
            //log("kkkkkkkkkkkk${image!.path}");
            if (!mounted) return;
            context.go('/CreateTeam?team=${jsonEncode(team.toJson())}&&image=${image}');
            context.read<FormzBloc>().add(InitMembers(members: team.Members.map((e) => Member.toMember(e)).toList()));

            context.read<TaskVisibleBloc>().add(ChangeImageEvent(
                image!=null?
                image!.path:"assets/images/jci.png"));

          })

          ,TeamComponent.actionTeamRow(mediaQuery, TeamAction.delete, Icons.delete, "Delete", () {
            context.read<GetTeamsBloc>().add(DeleteTeam( team.id));
            context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(true));

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
                  Icon(Icons.timer, color: Colors.red,),
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


static Widget ImageCard(mediaQuery, String image,double height) =>
    image!=null&& image.isNotEmpty
        ? ClipRRect(
        borderRadius: BorderRadius.circular(100),


        child: Image.memory(
            base64Decode(image),
            fit: BoxFit.cover,
            height:height,
            width: height


        ))
        : ClipRRect(

      borderRadius: BorderRadius.circular(100),

      child: Container(
          height: height,
          width: height,
          color: backgroundColored,
          child: Image.asset("assets/images/jci.png", fit: BoxFit.contain,)
      ),
    );


Widget Progress(Team team, MediaQueryData mediaQuery,
    List<Map<String, dynamic>> tasks) =>
    SizedBox(
      height: mediaQuery.size.height / 5.5,
      child: CircleProgressBar(
        foregroundColor: PrimaryColor,
        backgroundColor: textColor,
        strokeWidth: 10,
        value: team.tasks.isEmpty
            ? 0
            : calculateSumCompletedTasks(
            tasks) /
            team.tasks.length,
        child: Align(
          alignment: Alignment.center,
          child: AnimatedCount(
            style: PoppinsSemiBold(17, textColorBlack,
                TextDecoration.none),
            count: team.tasks.isEmpty
                ? 0
                : (calculateSumCompletedTasks(
                tasks) /
                team.tasks.length) * 100,
            unit: '%',
            duration: Duration(milliseconds: 500),
          ),
        ),
      ),
    );


static Widget membersTeamImage(BuildContext context, MediaQueryData mediaQuery,
    int length, List<dynamic> items,double photoheight,double contHeight) =>
    Row(

      children: [
        for (var i = 0; i < (length > 3 ? 2 : length); i++)

          PhotoContainer(items, i,photoheight),
        if (length > 3)
          alignPhoto(length,contHeight),

      ],
    );

static Padding PhotoContainer(List<dynamic> item, int i,double height) {
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
          child: photo(
              item[i]["Images"],
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
