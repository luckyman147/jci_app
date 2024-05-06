import 'dart:convert';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/members/members_cubit.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/widgets/loading_widget.dart';

import '../../../Home/presentation/widgets/ErrorDisplayMessage.dart';
import '../../../Home/presentation/widgets/SearchWidget.dart';
import '../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/pages/memberProfilPage.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../domain/entities/Team.dart';

class MemberTeamSelection{

 static  Widget MembersTeamContainer(mediaQuery, Member item,bool isExisted,
      Function(Member) onRemoveTap, Function(Member) onAddTap,
      BuildContext context, List<Member> ff) =>
     
       BlocBuilder<GetTaskBloc, GetTaskState>(
            builder: (context, state) {
                return   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    imageWidget(item),


                    SelectionButton(
                        mediaQuery, ff, item, isExisted,context, onRemoveTap, onAddTap),
                  ],);


            },
          );
    


 static  Widget SelectionButton(mediaQuery, List<Member> ff, Member item, bool isExisted,
      BuildContext context, Function(Member) onRemoveTap,
      Function(Member) onAddTap) {
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

                TeamFunction.    ChangeMemerFunction(isExisted, context, item, onRemoveTap, onAddTap);
                  }, child: Text(
                isExisted ? "Selected" : "Select"


                , style: PoppinsSemiBold(17,
                  isExisted ? textColorWhite : textColorBlack
                  , TextDecoration.none),)),
            );
          },
        );
      },
    );
  }



  SizedBox SelectionAssignButton(mediaQuery, List<Member> ff, Member item,
      BuildContext context, Function(Member) onRemoveTap,
      Function(Member) onAddTap) {
    return SizedBox(
      width: mediaQuery.size.width / 3,
      child: ElevatedButton(
          style:
          ff.isEmpty ? bottondec(false) :
          bottondec(TeamFunction.doesObjectExistInList(ff, item)),
          onPressed: () {

            TeamFunction.ChangeMemerFunction(TeamFunction.doesObjectExistInList(ff, item), context, item, onRemoveTap, onAddTap);

          }, child: Text(
        TeamFunction.   doesObjectExistInList(ff, item) ? "Selected" : "Select"


        , style: PoppinsSemiBold(17,
          TeamFunction.      doesObjectExistInList(ff, item) ? textColorWhite : textColorBlack
          , TextDecoration.none),)),
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
                  textMemberz(mediaQuery),
                  SeachMemberWidget(mediaQuery, context, (value){

                    TeamFunction.    SearchAction(context, value, state);

                  },),
                  ImportPieceOfAddMember(mediaQuery, state,assign, team)

                ],
              );
            },
          ),
        ),
      );

 static Widget MembersAssignToBottomSheet(mediaQuery
      , Function(Member) onRemoveTap, Function(Member) onAddTap,
      List<Member> members,
      List<Member> ff,) =>
      SizedBox(
        height: mediaQuery.size.height / .9,
        width: double.infinity,
        child: Padding(
          padding: paddingSemetricVerticalHorizontal(v: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              textMemberz(mediaQuery),

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

 static  Padding AssignToPiece(mediaQuery, Function(Member) onRemoveTap,
      Function(Member) onAddTap, List<Member> members, List<Member> ff) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: SizedBox(
            height: mediaQuery.size.height / 3,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<GetTaskBloc, GetTaskState>(
                  builder: (context, state) {

                    if (state.status==TaskStatus.success|| state.status==TaskStatus.Changed){
                      return MembersDetails(
                          members, mediaQuery, onRemoveTap, onAddTap, ff);}
                    else{
                      return Center(child: CircularProgressIndicator(),);}

                  },
                )
            )),
      ),
    );
  }

static  Text textMemberz(mediaQuery) {
    return Text(
      "Choose Members",
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
            mediaQuery.devicePixelRatio * 6,
            textColorBlack,
          ),
          onChanged: onChanged,
          decoration: inputDecoration(mediaQuery,false),
        )

    );
  }


 static Widget MembersWidget(MediaQueryData mediaQuery, String name,assignType type,
    Team team) =>
      BlocBuilder<MembersTeamCubit, MembersTeamState>(
        builder: (context, ste) {
          return BlocConsumer<MembersBloc, MembersState>(
            builder: (context, state) {
              if (state is MemberLoading) {
                return LoadingWidget();
              } else if (state is AllMembersLoadedState) {

                return RefreshIndicator(
                    onRefresh: () {

                      return

                        RefreshMembers(context, SearchType.All, "");
                    },
                    child:

type==assignType.Assign ?
                    MembersDetails(
                        state.members, mediaQuery, ( value){},  (po){},
                        ste.members ):  BuildInviteComp(state.members,ste.members,team)

                );
              }
              else if (state is MemberByNameLoadedState) {
                if (name.isNotEmpty) {
                  return RefreshIndicator(
                      onRefresh: () {

                        return

                          RefreshMembers(context, SearchType.Name, name);
                      },
                      child:type==assignType.Assign ?
                      MembersDetails(
                          state.members, mediaQuery, (po){}, (po){},
                          ste.members ): BuildInviteComp(state.members,ste.members,team)

                  );
                }
                else {
                  context.read<MembersBloc>().add(const GetAllMembersEvent(false));
                }
              }
              else if (state is MemberFailure) {
                return MessageDisplayWidget(message: state.message);
              }
              return LoadingWidget();
            }, listener: (BuildContext context, MembersState state) {
            if (state is MemberFailure) {
              context.read<MembersBloc>().add(const GetAllMembersEvent(false));
            }
          },


          );
        },
      );


 static  Future<void> RefreshMembers(BuildContext context, SearchType type,
      String name) async {
    if (type == SearchType.All || name.isEmpty){
      context.read<MembersBloc>().add(const GetAllMembersEvent(true));}
    else{
      context.read<MembersBloc>().add(GetMemberByNameEvent(name: name));}
  }


 static Widget MembersDetails(List<Member> members, mediaQuery,
      Function(Member) onRemoveTap, Function(Member) onAddTap, List<Member> ff) =>
      ListView.separated(

        scrollDirection: Axis.vertical,

        itemCount: members.length,
        itemBuilder: (context, index) {


          return InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return  MemberSectionPage(id:members[index].id);
                  },
                ),);




              context.read<MembersBloc>().add(GetMemberByIdEvent( MemberInfoParams(id: members[index].id,status: true)));

            },
            child: MembersTeamContainer(
                mediaQuery, members[index],TeamFunction. doesObjectExistInList(ff, members[index]),onRemoveTap, onAddTap, context, ff),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10,);
        },

      );


 static  Widget imageWidget(Member item) {
    return Row(
        children: [
          photo(item.Images, 50, 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(item.firstName,
              style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),),
          ),

        ]);
  }

 static  Widget photo(List<dynamic> item, double height, double circle) {

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
        child: Image.memory(
          item.first is String
              ? base64Decode(item.first)
              :
          base64Decode(item[0]["url"]),
          width: height,
          height: height,
          fit: BoxFit.cover,
        ),
      );
  }
 static Widget BuildInviteComp( List<Member> members, List<Member> filteredMembers,Team team ) {
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

       return buildMemberGrid(member,  TeamFunction.   doesObjectExistInList( team.Members.map((e) => Member. toMember(e)). toList(), member),team);
       },
     ),
   );
 }
 static Widget buildMemberGrid(Member member,bool isAssign,Team team) {
   return BlocBuilder<MembersTeamCubit, MembersTeamState>(
     builder: (context, state) {
       return InkWell(
         hoverColor: textColor,
         onTap: () {
        TeamFunction.   InviteKickMember(isAssign, team, member, context);

           // Navigate to member profile
         },
         onLongPress: () {
      TeamFunction.     NavigateTOMemberSection(context, member);
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
                   member.Images.isEmpty ? Center(child: Container(
                     height: 60,
                     width: 60,

                     decoration: BoxDecoration(
                         border: Border.all(color: textColor, width: 2),
                         shape: BoxShape.circle,
                         image: DecorationImage(
                             image: AssetImage(vip),
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
                       child: photo(member.Images, 60, 50))),

                   // Badge

                   // Member Name
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(
                       member.firstName + ' ' + member.lastName,
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
