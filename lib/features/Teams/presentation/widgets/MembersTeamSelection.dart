import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/MemberSelection.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../../Home/presentation/widgets/ErrorDisplayMessage.dart';
import '../../../Home/presentation/widgets/SearchWidget.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../../auth/presentation/bloc/Members/members_bloc.dart';

Widget MembersTeamContainer(mediaQuery,Member item,)=>BlocBuilder<FormzBloc, FormzState>(
    builder: (context, state) {
      final ff = state.membersTeamFormz.value??[];

      return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          imageWidget(item),
          SizedBox(
            width: mediaQuery.size.width / 3,
            child: ElevatedButton(
                style:
                ff.isEmpty?bottondec(false):
                bottondec(doesObjectExistInList(ff, item)),
                onPressed: (){
                  if (doesObjectExistInList(ff, item)){
                    context.read<FormzBloc>().add(RemoveMember( member: item));

                  }
                  else{
                    context.read<FormzBloc>().add(MembersTeamChanged( memberTeam: item));
                  }

                }, child: Text(
              doesObjectExistInList(ff, item)? "Selected":"Select"


              ,style:PoppinsSemiBold(17,
                doesObjectExistInList(ff, item)?textColorWhite:textColorBlack
                , TextDecoration.none) ,)),
          )
        ],);
    }
);





Widget MembersTeamBottomSheet(
    mediaQuery



    )=>SizedBox(
  height: mediaQuery.size.height / .9,
  width: double.infinity,
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 10,
    ),
    child: BlocBuilder<FormzBloc, FormzState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Choose Members",
              style: PoppinsSemiBold(
                mediaQuery.devicePixelRatio * 6,
                PrimaryColor,
                TextDecoration.none,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10,
                ),
                child: TextField(

                  style: PoppinsRegular(
                    mediaQuery.devicePixelRatio * 6,
                    textColorBlack,
                  ),
                  onChanged: (value) {
                    context.read<FormzBloc>().add(MembernameChanged( name: value));
                    if (state.memberName.value.length > 1){
                      context.read<MembersBloc>().add(GetMemberByNameEvent( name: state.memberName.value));}
                    else if (state.memberName.value.isEmpty|| state.memberName.displayError!= null ){
                      context.read<MembersBloc>().add(GetAllMembersEvent());
                    }
                    debugPrint(state.memberName.displayError.toString());
                    // BlocProvider.of<MembersBloc>(context)
                    //    .add(SearchMembersEvent(value));
                  },
                  decoration: InputDecoration(
                    errorText: state.memberName.displayError!= null?"Empty Field":null,
                    prefixIcon: Icon(
                      Icons.search,
                      color: textColor,
                    ),
                    hintText: "Search for a Member",
                    hintStyle: PoppinsRegular(
                      mediaQuery.devicePixelRatio * 6,
                      textColor,

                    ),

                    focusedBorder: border(PrimaryColor),
                    enabledBorder: border(ThirdColor),
                    errorBorder: border(Colors.red),
                    focusedErrorBorder: border(Colors.red),
                    errorStyle: ErrorStyle(18, Colors.red),

                  ),
                )

            ),



            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: SizedBox(
                    height: mediaQuery.size.height/3 ,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MembersWidget(mediaQuery,state.memberName.value),
                    )),
              ),
            )

          ],
        );
      },
    ),
  ),
);
Widget MembersWidget(MediaQueryData mediaQuery,String name)=>BlocConsumer<MembersBloc, MembersState>(
  builder: (context, state) {
    if (state is MemberLoading) {
      return LoadingWidget();
    } else if (state is AllMembersLoadedState) {
      return RefreshIndicator(
          onRefresh: () {
            print(state.members.length);
            return

              RefreshMembers(context,SearchType.All,"");
          },
          child:


          MembersDetails( state.members,mediaQuery)

      );

    }
    else if (state is MemberByNameLoadedState){
      debugPrint(state.toString());
      debugPrint("name is ${name.isEmpty}");
      if (name.isNotEmpty){
        return RefreshIndicator(
            onRefresh: () {
              print(state.members.length);
              return

                RefreshMembers(context,SearchType.Name,name);
            },
            child: MembersDetails( state.members,mediaQuery));
      }
      else{
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
Future<void> RefreshMembers(BuildContext context,SearchType type,String name) async {
  if (type==SearchType.All||name.isEmpty)
    context.read<MembersBloc>().add(GetAllMembersEvent());
  else
    context.read<MembersBloc>().add(GetMemberByNameEvent(name: name));

}




Widget MembersDetails(List<Member> members,mediaQuery)=>ListView.separated(
  scrollDirection: Axis.vertical,

  itemCount: members.length,
  itemBuilder: (context, index) {
    return MembersTeamContainer(mediaQuery, members[index]);
  },
  separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,);  },

);Widget imageWidget(Member item){ return Row(
    children: [
    photo(item.Images,50),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(item.firstName,style: PoppinsSemiBold(18, textColorBlack,TextDecoration.none),),
    ),

    ]);}

Widget photo(List<dynamic> item,double height){
return
  item.isEmpty
      ?  ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: Container(
      height: height,
      width: height,
      color: textColor,
    ),

  )
      :
  ClipRRect(


    borderRadius: BorderRadius.circular(100),
    child: Image.memory(
      base64Decode(item.first),
      width: height,
      height: height,
      fit: BoxFit.cover,
    ),
  );
}