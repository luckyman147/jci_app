import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/pages/memberProfilPage.dart';
import '../../../../core/Member.dart';
//import '../../../auth/presentation/bloc/Members/members_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import 'ErrorDisplayMessage.dart';
import 'SearchWidget.dart';

Widget MemberContainer(mediaQuery,Member item)=>BlocBuilder<FormzBloc, FormzState>(


    builder: (context, state)
    {final ff=state.memberFormz.value??Member.memberTest;
      return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          imageWidget(item,50,15,true,100),
          InkWell(
            onTap: () {
              context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: item));


            },
            child: AnimatedContainer(
              width: mediaQuery.size.width / 3,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                color: ff.id == item.id?PrimaryColor:BackWidgetColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(ff.id==item.id? "Selected".tr(context):"Select".tr(context),

                                style:PoppinsSemiBold(14,

                ff.id==item.id?textColorWhite:textColorBlack,

                TextDecoration.none) ,),
              ),
            ),
          )
        ],);
    }
);
Widget bottomMemberSheet(BuildContext context, MediaQueryData mediaQuery,
    Member member,String text,String title


    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0,),
    child: InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return BlocBuilder<FormzBloc, FormzState>(
              builder: (context, state) {
                return MembersBottomSheet(title,mediaQuery);
              },
            );
          },
        );
      },
      child:Container(
          width: mediaQuery.size.width,
          decoration:
          memberdeco,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0,),
            child: Padding(
              padding: paddingSemetricHorizontal(),
              child:
              member.firstName.isNotEmpty?imageWidget(member,40,23,true,150):
              Text(text,style: PoppinsNorml(18, ThirdColor),),
            ),
          )),
    ),
  );}







Widget MembersBottomSheet(String text,
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
              "${"Choose".tr(context)} $text",
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
                      context.read<MembersBloc>().add(const GetAllMembersEvent(false));
                    }

                    // BlocProvider.of<MembersBloc>(context)
                    //    .add(SearchMembersEvent(value));
                  },
                  decoration: InputDecoration(
                    errorText: state.memberName.displayError!= null?"Empty Field":null,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: textColor,
                    ),
                    hintText: "${"Search for a".tr(context)} $text",
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
    if (state .userStatus==UserStatus.Loading) {
      return const LoadingWidget();
    } else if (state.userStatus == UserStatus.MembersLoaded) {
      return RefreshIndicator(
          onRefresh: () {

            return

              RefreshMembers(context,SearchType.All,"");
          },
          child:


          MembersDetails( state.members,mediaQuery)

      );

    }
    else if (state .userStatus==UserStatus.MemberByname){


      if (name.isNotEmpty){
        return RefreshIndicator(
            onRefresh: () {

              return

                RefreshMembers(context,SearchType.Name,name);
            },
            child: MembersDetails( state.memberByName,mediaQuery));
      }
      else{
        context.read<MembersBloc>().add(const GetAllMembersEvent(true));
      }

    }
    else if (state .userStatus==UserStatus.Error) {
      return MessageDisplayWidget(message: state.Errormessage);
    }
    return const LoadingWidget();
  }, listener: (BuildContext context, MembersState state) {
  if (state .userStatus==UserStatus.Error) {
    context.read<MembersBloc>().add(const GetAllMembersEvent(true));
  }


},


);
Future<void> RefreshMembers(BuildContext context,SearchType type,String name) async {
  if (type==SearchType.All||name.isEmpty) {
    context.read<MembersBloc>().add(const GetAllMembersEvent(true));
  } else {
    context.read<MembersBloc>().add(GetMemberByNameEvent(name: name));
  }

}


Widget MembersDetails(List<Member> members,mediaQuery)=>ListView.separated(
  scrollDirection: Axis.vertical,

  itemCount: members.length,
  itemBuilder: (context, index) {
    return BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
  builder: (context, state) {
    return InkWell(
        onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return  MemberSectionPage(id:members[index].id!);
              },
            ),);




          context.read<MembersBloc>().add(GetMemberByIdEvent( MemberInfoParams(id: members[index].id!,status: true)));
        },

        child: MemberContainer(mediaQuery, members[index]));
  },
);
  },
  separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,);  },

);





Widget imageWidget(Member item,double height , double size,bool bools,double width){
if (item.Images.isNotEmpty){

}
  return Row(
    children: [
      PhotoReeact(item, height),
      const SizedBox(width: 8),
      SizedBox(
        width: width,
        child: Text(item.firstName,
            overflow: TextOverflow.ellipsis,
            style: PoppinsSemiBold(size, bools?textColorBlack:textColorWhite, TextDecoration.none)),
      ),]);}

ClipRRect PhotoReeact(Member item, double height) {
  return item.Images.isEmpty
        ?  ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        height: height,
        width: height,
        child:Image.asset(vip)
      ),

    )
        :
    ClipRRect(


      borderRadius: BorderRadius.circular(100),
      child: Image.memory(
        base64Decode(item.Images[0]['url']),
        width: height,
        height: height,
        fit: BoxFit.cover,
      ),
    );
}





