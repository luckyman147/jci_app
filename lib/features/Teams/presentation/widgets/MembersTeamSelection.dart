import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jci_app/features/Home/presentation/widgets/MemberSelection.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/widgets/ErrorDisplayMessage.dart';
import '../../../Home/presentation/widgets/SearchWidget.dart';
import '../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/pages/memberProfilPage.dart';
import '../../../auth/domain/entities/Member.dart';


Widget MembersTeamContainer(mediaQuery, Member item,bool isExisted,
    Function(Member) onRemoveTap, Function(Member) onAddTap,
    BuildContext context, List<Member> ff) =>
    BlocBuilder<FormzBloc, FormzState>(
  builder: (context, s) {
    return BlocBuilder<GetTaskBloc, GetTaskState>(
      builder: (context, state) {

        if (s.status==FormzSubmissionStatus.success){

       return   Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            imageWidget(item),


            SelectionButton(
                mediaQuery, ff, item, isExisted,context, onRemoveTap, onAddTap),
          ],);}
       else{
          return   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              imageWidget(item),


              SelectionButton(
                  mediaQuery, ff, item, isExisted,context, onRemoveTap, onAddTap),
            ],);

       }

      },
    );
  },
);


Widget SelectionButton(mediaQuery, List<Member> ff, Member item, bool isExisted,
    BuildContext context, Function(Member) onRemoveTap,
    Function(Member) onAddTap) {
  return BlocBuilder<FormzBloc, FormzState>(
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

              if (isExisted) {
                context.read<FormzBloc>().add(RemoveMember(member: item));

                onRemoveTap(item);
              }
              else {
                context.read<FormzBloc>().add(
                    MembersTeamChanged(memberTeam: item));

                onAddTap(item);
              }
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

          if (TeamFunction.doesObjectExistInList(ff, item)) {
            context.read<FormzBloc>().add(RemoveMember(member: item));
            onRemoveTap(item);
          }
          else {
            context.read<FormzBloc>().add(MembersTeamChanged(memberTeam: item));
            onAddTap(item);
          }
        }, child: Text(
      TeamFunction.   doesObjectExistInList(ff, item) ? "Selected" : "Select"


      , style: PoppinsSemiBold(17,
        TeamFunction.      doesObjectExistInList(ff, item) ? textColorWhite : textColorBlack
        , TextDecoration.none),)),
  );
}


Widget MembersTeamBottomSheet(mediaQuery
    , Function(Member) onRemoveTap, Function(Member) onAddTap) =>
    SizedBox(
      height: mediaQuery.size.height / .9,
      width: double.infinity,
      child: Padding(
        padding: paddingSemetricVerticalHorizontal(v: 10),
        child: BlocBuilder<FormzBloc, FormzState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                textMemberz(mediaQuery),
                SeachMemberWidget(mediaQuery, context, (value){

                  TeamFunction.    SearchAction(context, value, state);

                },state.memberName.displayError!= null),
                ImportPieceOfAddMember(mediaQuery, state, onRemoveTap, onAddTap)

              ],
            );
          },
        ),
      ),
    );

Widget MembersAssignToBottomSheet(mediaQuery
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


Padding ImportPieceOfAddMember(mediaQuery, FormzState state,
    Function(Member) onRemoveTap, Function(Member) onAddTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: SingleChildScrollView(
      child: SizedBox(
          height: mediaQuery.size.height / 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MembersWidget(
                mediaQuery, state.memberName.value, onRemoveTap, onAddTap),
          )),
    ),
  )

  ;
}

Padding AssignToPiece(mediaQuery, Function(Member) onRemoveTap,
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

Text textMemberz(mediaQuery) {
  return Text(
    "Choose Members",
    style: PoppinsSemiBold(
      mediaQuery.devicePixelRatio * 6,
      PrimaryColor,
      TextDecoration.none,
    ),
  );
}

Padding SeachMemberWidget(mediaQuery, BuildContext context, Function(String value) onChanged,bool isEmpty) {
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
        decoration: inputDecoration(mediaQuery,isEmpty),
      )

  );
}


Widget MembersWidget(MediaQueryData mediaQuery, String name,
    Function(Member) onRemoveTap, Function(Member) onAddTap) =>
    BlocBuilder<FormzBloc, FormzState>(
      builder: (context, ste) {
        return BlocConsumer<MembersBloc, MembersState>(
          builder: (context, state) {
            if (state is MemberLoading) {
              return LoadingWidget();
            } else if (state is AllMembersLoadedState) {
              return RefreshIndicator(
                  onRefresh: () {
                    print(state.members.length);
                    return

                      RefreshMembers(context, SearchType.All, "");
                  },
                  child:


                  MembersDetails(
                      state.members, mediaQuery, onRemoveTap, onAddTap,
                      ste.membersTeamFormz.value ?? [])

              );
            }
            else if (state is MemberByNameLoadedState) {
              if (name.isNotEmpty) {
                return RefreshIndicator(
                    onRefresh: () {
                      print(state.members.length);
                      return

                        RefreshMembers(context, SearchType.Name, name);
                    },
                    child: MembersDetails(
                        state.members, mediaQuery, onRemoveTap, onAddTap,
                        ste.membersTeamFormz.value ?? []));
              }
              else {
                context.read<MembersBloc>().add(GetAllMembersEvent());
              }
            }
            else if (state is MemberFailure) {
              return MessageDisplayWidget(message: state.message);
            }
            return LoadingWidget();
          }, listener: (BuildContext context, MembersState state) {
          if (state is MemberFailure) {
            context.read<MembersBloc>().add(GetAllMembersEvent());
          }
        },


        );
      },
    );


Future<void> RefreshMembers(BuildContext context, SearchType type,
    String name) async {
  if (type == SearchType.All || name.isEmpty)
    context.read<MembersBloc>().add(GetAllMembersEvent());
  else
    context.read<MembersBloc>().add(GetMemberByNameEvent(name: name));
}


Widget MembersDetails(List<Member> members, mediaQuery,
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


Widget imageWidget(Member item) {
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

Widget photo(List<dynamic> item, double height, double circle) {

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