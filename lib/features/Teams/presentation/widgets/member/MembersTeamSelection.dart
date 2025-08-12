import 'dart:convert';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/members/members_cubit.dart';
import 'package:jci_app/features/Teams/presentation/utils/MemberUtils.dart';
import 'package:jci_app/features/Teams/presentation/utils/NavigationUtils.dart';
import 'package:jci_app/features/Teams/presentation/utils/TeamUtils.dart';

import 'package:logger/logger.dart';
import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/widgets/loading_widget.dart';

import '../../../../Home/domain/enums/SearchType.dart';
import '../../../../Home/presentation/widgets/components/stuff/ErrorDisplayMessage.dart';
import '../../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../../MemberSection/presentation/pages/user/memberProfilPage.dart';
import '../../../../../core/Member.dart';
import '../../../domain/entities/Team/Team.dart';
import '../../../domain/entities/TeamUser.dart';

class MemberTeamSelection{

 static  Widget MembersTeamContainer(mediaQuery, TeamUser item,bool isExisted,
      Function(TeamUser) onRemoveTap, Function(TeamUser) onAddTap,
      BuildContext context, List<User> ff) =>
     
       BlocBuilder<GetTaskBloc, GetTaskState>(
            builder: (context, state) {
                return   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    imageWidget(item.user),
                    DropdownButton<UserTeamRole>(
                      value: item.role, // Current selected role
                      items: UserTeamRole.values.map((role) {
                        return DropdownMenuItem<UserTeamRole>(
                          value: role,
                          child: Text(role.name), // role.name gives "canRead", "canModify", etc.
                        );
                      }).toList(),
                      onChanged: (UserTeamRole? newValue) {
                        if (newValue != null) {
                  context.read<MembersTeamCubit>().changeMemberRole(item, newValue);
                        }
                      },
                    ),


                    SelectionButton(
                        mediaQuery, ff, item, isExisted,context, onRemoveTap, onAddTap),
                  ],);


            },
          );
    


 static  Widget SelectionButton(mediaQuery, List<User> ff, TeamUser item, bool isExisted,
      BuildContext context, Function(TeamUser) onRemoveTap,
      Function(TeamUser) onAddTap) {
    return BlocBuilder<MembersTeamCubit, MembersTeamState>(
      builder: (context, state) {
        return BlocBuilder<GetTaskBloc, GetTaskState>(
          builder: (context, state) {
            return SizedBox(
              width: mediaQuery.size.width / 3,
              child:

              ElevatedButton(
                  style:
                  ff.isEmpty ? bottondec(false) :
                  bottondec(isExisted),
                  onPressed: () {

                MemberUtils.    toggleMember(context,isExisted, item, onRemoveTap, onAddTap);
                  }, child: Text(
                isExisted ? "Selected".tr(context) : "Select".tr(context)


                , style: PoppinsSemiBold(13,
                  isExisted ? textColorWhite : textColorBlack
                  , TextDecoration.none),)
             .animate()
                  .fadeIn(duration: 600.ms)

              ),
            );
          },
        );
      },
    );
  }



  SizedBox SelectionAssignButton(mediaQuery, List<TeamUser> ff, TeamUser item,
      BuildContext context, Function(TeamUser) onRemoveTap,
      Function(TeamUser) onAddTap) {
    var doesObjectExistInList = TeamUtils.doesUserExist(ff.map((e)=>e.user).toList(), item.user);
    return SizedBox(
      width: mediaQuery.size.width / 3,
      child: ElevatedButton(
          style:
          ff.isEmpty ? bottondec(false) :
          bottondec(doesObjectExistInList),
          onPressed: () {

            MemberUtils.toggleMember(context,doesObjectExistInList, item, onRemoveTap, onAddTap);

          }, child: Text(
        doesObjectExistInList ? "Selected" : "Select"


        , style: PoppinsSemiBold(17,
         doesObjectExistInList ? textColorWhite : textColorBlack
          , TextDecoration.none),)).animate().fadeIn(duration: 600.ms),
    );
  }


 static  Widget MembersTeamBottomSheet(mediaQuery,assignType assign
      ,Team team ) =>
      SizedBox(
        height: mediaQuery.size.height / .9,
        width: double.infinity,
        child: Padding(
          padding: paddingSemetricVerticalHorizontal(v: 10),
          child: BlocBuilder<MembersTeamCubit, MembersTeamState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  textMemberz(mediaQuery,context),
                  SeachMemberWidget(mediaQuery, context, (value){

                    MemberUtils.    searchMembers(context, value, state);

                  },),
                  ImportPieceOfAddMember(mediaQuery, state,assign, team)

                ],
              );
            },
          ),
        ),
      );

 static Widget MembersAssignToBottomSheet(mediaQuery
      , Function(TeamUser) onRemoveTap, Function(TeamUser) onAddTap,
      List<TeamUser> members,
      List<TeamUser> ff,BuildContext context) =>
      SizedBox(
        height: mediaQuery.size.height / .9,
        width: double.infinity,
        child: Padding(
          padding: paddingSemetricVerticalHorizontal(v: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              textMemberz(mediaQuery,context),

              AssignToPiece(mediaQuery, onRemoveTap, onAddTap, members, ff)

            ],
          ),

        ),

      );


 static Padding ImportPieceOfAddMember(mediaQuery, MembersTeamState state,assignType assign,Team team
) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: SizedBox(
            height: mediaQuery.size.height / 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MembersWidget(
                  mediaQuery, state.name,assign,team),
            )),
      ),
    )

    ;
  }

 static  Padding AssignToPiece(mediaQuery, Function(TeamUser) onRemoveTap,
      Function(TeamUser) onAddTap, List<TeamUser> members, List<TeamUser> ff) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: SizedBox(
            height: mediaQuery.size.height / 3,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<GetTaskBloc, GetTaskState>(
                  builder: (context, state) {

                    if (state.status==TaskStatus.success|| state.status==TaskStatus.Changed ||state.status==TaskStatus.ErrorUpdate){
                      return MembersDetails(
                          members, mediaQuery, onRemoveTap, onAddTap, ff);}
                    else{
                      return const Center(child: LoadingWidget());}

                  },
                )
            )),
      ),
    );
  }

static  Text textMemberz(mediaQuery,BuildContext context) {
    return Text(
      "Choose Members".tr(context),
      style: PoppinsSemiBold(
        mediaQuery.devicePixelRatio * 6,
        PrimaryColor,
        TextDecoration.none,
      ),
    );
  }

static  Padding SeachMemberWidget(mediaQuery, BuildContext context, Function(String value) onChanged,) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10,
        ),
        child: TextField(

          style: PoppinsRegular(
            mediaQuery.devicePixelRatio * 5,
            textColorBlack,
          ),
          onChanged: onChanged,
          decoration: inputDecoration(mediaQuery,false,context),
        )

    );
  }


 static Widget MembersWidget(MediaQueryData mediaQuery, String name, assignType type, Team team) {
   return BlocBuilder<MembersTeamCubit, MembersTeamState>(
     builder: (context, ste) {
       return BlocConsumer<MembersBloc, MembersState>(
         builder: (context, state) {
           switch (state.userStatus) {
             case UserStatus.Loading:
               return const LoadingWidget();

             case UserStatus.MembersLoaded:
               var members = state.members.map((e)=>TeamUser(e)).toList();
               return RefreshIndicator(
                 onRefresh: () {
                   return RefreshMembers(context, SearchType.All, "");
                 },
                 child: type == assignType.Assign
                     ? MembersDetails(members  , mediaQuery, (value) {}, (po) {}, ste.members)
                     : BuildInviteComp(members, ste.members, team),
               );

             case UserStatus.MemberByname:
               if (name.isNotEmpty) {
                 var memberByName = state.memberByName.map((e)=>TeamUser((e))).toList();
                 return RefreshIndicator(
                   onRefresh: () {
                     return RefreshMembers(context, SearchType.Name, name);
                   },
                   child: type == assignType.Assign
                       ? MembersDetails(memberByName, mediaQuery, (po) {}, (po) {}, ste.members)
                       : BuildInviteComp(memberByName, ste.members, team),
                 );
               } else {
                 context.read<MembersBloc>().add(const GetAllMembersEvent(false));
               }
               break;

             case UserStatus.Error:
               return MessageDisplayWidget(message: state.Errormessage);

             default:
               return const LoadingWidget();
           }
           return const LoadingWidget();
         },
         listener: (BuildContext context, MembersState state) {
           if (state.userStatus == UserStatus.Error) {
             context.read<MembersBloc>().add(const GetAllMembersEvent(false));
           }
         },
       );
     },
   );
 }



 static  Future<void> RefreshMembers(BuildContext context, SearchType type,
      String name) async {
    if (type == SearchType.All || name.isEmpty){
      context.read<MembersBloc>().add(const GetAllMembersEvent(true));}
    else{
      context.read<MembersBloc>().add(GetMemberByNameEvent(name: name));}
  }


 static Widget MembersDetails(List<TeamUser> members, mediaQuery,
      Function(TeamUser) onRemoveTap, Function(TeamUser) onAddTap, List<TeamUser> ff) =>
      ListView.separated(

        scrollDirection: Axis.vertical,

        itemCount: members.length,
        itemBuilder: (context, index) {


          var list = ff.map((e)=>e.user).toList();
          return InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return  MemberSectionPage(id:members[index].user.id!);
                  },
                ),);




              context.read<MembersBloc>().add(GetMemberByIdEvent( MemberInfoParams(id: members[index].user.id!,status: true)));

            },
            child: MembersTeamContainer(
                mediaQuery, members[index],TeamUtils. doesUserExist(list, members[index].user),onRemoveTap, onAddTap, context, list),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10,);
        },

      );


 static  Widget imageWidget(User item) {
    return Row(
        children: [
          photo(item.Images.isNotEmpty?  item.Images[0].toString():"", 50, 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 100,
              child: Text(item.firstName,
                overflow: TextOverflow.ellipsis,
                style: PoppinsSemiBold(15, textColorBlack, TextDecoration.none),),
            ),
          ),

        ]);
  }

 static  Widget photo(String item, double height, double circle) {

    return
      item.isEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(circle),
        child: Container(
          height: height,
          width: height,
          color: textColor,
          child: Center(
            child: Icon(
              Icons.person,
              color: textColorWhite,
              size: height / 2,
            ),
          ),
        ),

      )
          :
      ClipRRect(


        borderRadius: BorderRadius.circular(circle),
        child: Image.network(

              item,
          width: height,
          height: height,
          fit: BoxFit.cover,
        ),
      );
  }
 static Widget BuildInviteComp( List<TeamUser> members, List<TeamUser> filteredMembers,Team team ) {
   return Padding(
     padding: paddingSemetricVertical(),
     child: GridView.builder(
       itemCount: min(6, members.length),
       // Change the number of items to display
       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 2,
         childAspectRatio: 1.11,
         crossAxisSpacing: 8.0,
         mainAxisSpacing: 8.0,

       ),
       itemBuilder: (BuildContext context, int index) {
         final member = members[index];

       return buildMemberGrid(member,
           TeamUtils.   doesUserExist( team.members.members.map((e) => e.user). toList(), member.user),team);
       },
     ),
   );
 }
 static Widget buildMemberGrid( TeamUser member,bool isAssign,Team team) {
   return BlocBuilder<MembersTeamCubit, MembersTeamState>(
     builder: (context, state) {
       return InkWell(
         hoverColor: textColor,
         onTap: () {
        MemberUtils.   InviteKickMember(isAssign, team, member, context);

           // Navigate to member profile
         },
         onLongPress: () {
      NavigationUtils.     navigateToMemberProfile(context, member.user);
         },
         child: Container(
           decoration: BoxDecoration(
             color: isAssign
                 ? PrimaryColor
                 : Colors.white,
             border: Border.all(color: textColor, width: 1.0),
             borderRadius: BorderRadius.circular(15.0),
             boxShadow: [
               BoxShadow(
                 color: Colors.grey.withOpacity(0.5),
                 spreadRadius: 1,
                 blurRadius: 2,
                 offset: const Offset(2, 0), // changes position of shadow
               ),
             ],
           ),
           child: Padding(
             padding: paddingSemetricVertical(),
             child: Center(
               child: Column(
                 children: [
                   // Image
                   member.user.Images.isEmpty ? Center(child: Container(
                     height: 60,
                     width: 60,

                     decoration: BoxDecoration(
                         border: Border.all(color: textColor, width: 2),
                         shape: BoxShape.circle,
                         image: DecorationImage(
                             image: const AssetImage(vip),
                             colorFilter: ColorFilter.mode(
                                 isAssign ?
                                 Colors.white.withOpacity(0.1) :

                                 Colors.white.withOpacity(0.5)

                                 , BlendMode.dstATop),
                             fit: BoxFit.cover
                         )
                     ),

                   ),) :


                   Center(child: Container(
                       decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           border: Border.all(color: textColor, width: 2)
                       ),
                       child: photo(member.user.Images[0].cast(), 60, 50))),

                   // Badge

                   // Member Name
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(
                       '${member.user.firstName} ${member.user.lastName}',
                       style: PoppinsRegular(
                         15.0,
                        isAssign
                             ? Colors.white
                             :
                         Colors.black,
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       );
     },
   );
 }




}
