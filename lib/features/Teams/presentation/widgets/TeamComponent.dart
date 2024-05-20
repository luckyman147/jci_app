import 'dart:convert';
import 'dart:developer';


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../Home/presentation/bloc/Activity/activity_cubit.dart';
import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../Home/presentation/widgets/Compoenents.dart';
import '../../../auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import '../../domain/entities/Team.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/GetTeam/get_teams_bloc.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';
import 'funct.dart';


class TeamComponent{
 static  Widget TaskdropButton(mediaQuery) => BlocBuilder<ActivityCubit, ActivityState>(
    builder: (context, ste) {
      return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
        builder: (context, state) {
          return Container(
            width: mediaQuery.size.width/1.5, // Increased width to 180
            height: 60,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,


            ),
            child: Padding(

              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<TaskFilter>(
                  isExpanded: true,
                  style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),
                  dropdownStyleData:  DropdownStyleData(
                    elevation: 2,
                    maxHeight: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,

                    ),
                    offset: Offset(-5, 0),
                    width: mediaQuery.size.width / 3,
                    // Keep width at 180


                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(14),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                  onMenuStateChange: (bool isMenuOpen) {
                    context.read<ToggleBooleanBloc>().add(ToggleBoolean());
                  },
                  iconStyleData: IconStyleData(iconSize: 30, icon: SvgPicture.string(state.value ? Arrow_UP : Arrow_Down)),
                  value: TaskFilter.All,
                  underline: Container(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  onChanged: (newValue) {},
                  items: <TaskFilter>[...TaskFilter.values]
                      .map<DropdownMenuItem<TaskFilter>>((TaskFilter value) {
                    return DropdownMenuItem<TaskFilter>(
                      alignment: AlignmentDirectional.centerStart,
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      );
    },
  );
 static  Widget actionTeamRow(BuildContext context,
      mediaQuery, TeamAction action, IconData icon, String text,Function() onTap) =>
      InkWell(
        onTap:onTap ,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width / 30,
                  vertical: mediaQuery.size.height / 40),
              child: Icon(
                icon,
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${text} ${"Team".tr(context)}",
                style: PoppinsRegular(
                    mediaQuery.devicePixelRatio * 8, textColorBlack),
              ),
            ),
          ],
        ),
      );
 static  Row Status(BuildContext context, TaskVisibleState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [


        StatusContainer((){
          context.read<TaskVisibleBloc>().add(changePrivacyEvent(Privacy.Primary));

          // Dispatch event to initialize GetTeamsBloc and fetch teams with updated privacy
          context.read<GetTeamsBloc>().add(initStatus());
          context.read<GetTeamsBloc>().add(GetTeams(isPrivate: false,isUpdated: state.isUpdated));
        },"Primary".tr(context),state.privacy==Privacy.Primary,Privacy.Primary),
        SizedBox(width: 10,),
        StatusContainer((){
          context.read<TaskVisibleBloc>().add(changePrivacyEvent(Privacy.Private));

          // Dispatch event to initialize GetTeamsBloc and fetch teams with updated privacy
          context.read<GetTeamsBloc>().add(initStatus());
          context.read<GetTeamsBloc>().add(GetTeams(isPrivate: true,isUpdated: true));
          context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(false));

        },"Private".tr(context),state.privacy==Privacy.Private,Privacy.Private),


      ],);
  }



 static  ElevatedButton StatusContainer(Function() onPressed, String text,bool isActive,Privacy privacy) {
    return ElevatedButton(
      style: styleFrom(isActive),
      onPressed: onPressed, child: Text(text,style:PoppinsRegular(16, isActive?textColorWhite:textColorBlack),),);
  }



 static  Row Header(BuildContext context, TaskVisibleState state, MediaQueryData mediaquery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 50,

          child: SeachRow(context, state, mediaquery),
        ),
        SecondRowPart(state, context),

      ],
    );
  }

static  Row SecondRowPart(TaskVisibleState state, BuildContext context) {
    return Row(
      children: [
        state.willSearch==false?
        iconButton(context,Icons.search, () {
          context.read<TaskVisibleBloc>().add(ChangeWillSearchEvent(true));
        },):

        iconButton(context,Icons.cancel, (){
          context.read<TaskVisibleBloc>().add(ChangeWillSearchEvent(false));
          context.read<GetTeamsBloc>().add(GetTeams(isPrivate: state.privacy==Privacy.Private));

        }),




      ProfileComponents.buildFutureBuilder( AddTeamButton(context), true, "", (p0) => FunctionMember.isAdminAndSuperAdmin())



      ],
    );
  }

static AddButton AddTeamButton(BuildContext context) {
  return AddButton(color: PrimaryColor, IconColor: textColorBlack, icon: Icons.add_rounded,
onPressed: () {
final team=jsonEncode(Team.empty().toJson());
context.go('/CreateTeam?team=${team}');
});
}

static IconButton iconButton(BuildContext context,IconData icon, Function() onPressed) {
  return IconButton(onPressed:
      onPressed
     , icon: Icon(icon,color: textColorBlack,));
}

  static Row SeachRow(BuildContext context, TaskVisibleState state, MediaQueryData mediaquery) {
    return Row(
      children: [
        BackButton(
            onPressed: () {
              context.read<PageIndexBloc>().add(SetIndexEvent(index: 0));
            }
        ),
        state.willSearch==false?
        Text("Teams".tr(context),style:PoppinsSemiBold(21, textColorBlack, TextDecoration.none)):
        SizedBox(
          width: mediaquery.size.width*0.6,
          height: 50,
          child: TextField(
              style: PoppinsRegular(16, textColorBlack) ,
              decoration: InputDecoration(
                hintText: "${"Search".tr(context)} ${"Teams".tr(context)}",
                hintStyle: PoppinsRegular(16, textColor),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                TeamFunction.searchFunction(value, context,state.privacy==Privacy.Private);

              }),
        ),
      ],
    );
  }

}



class myTaskButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          for (var activity in TaskFilter.values)
            _buildActivityButton(context, activity, mediaQuery),

        ],
      ),
    );
  }

  Widget _buildActivityButton(
      BuildContext context, TaskFilter filter, mediaQuery) {
    return BlocBuilder<TaskfilterBloc, TaskfilterState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width / 50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: state.selectedFilter == filter
                  ? PrimaryColor
                  : Colors.white,
              foregroundColor: state.selectedFilter == filter
                  ? textColorWhite
                  : Colors.black,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: textColorBlack, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              // Handle button press for the specific activity
              _handleActivityButtonClick(context, filter,state);
            },
            child: Text(
              filter.toString().split('.').last.tr(context),
              style: PoppinBold(
                  mediaQuery.size.width / 30,
                  state.selectedFilter == filter
                      ? textColorWhite
                      : textColorBlack,
                  TextDecoration.none),
            ),
          ),
        );
      },
    );
  }

  void _handleActivityButtonClick(
      BuildContext context, TaskFilter filter,TaskfilterState state  ) {
    context.read<TaskfilterBloc>().add((TaskfilterSelected(filter)));




    // Add logic to handle the button press for the specific activity
    // You can dispatch events to other blocs or perform any other actions here.
  }
}

