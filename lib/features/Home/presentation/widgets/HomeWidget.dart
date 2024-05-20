
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';


import '../../../../core/app_theme.dart';
import '../../../MemberSection/presentation/widgets/MemberImpl.dart';
import '../../../Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../auth/data/models/Member/AuthModel.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';


import 'ActivityImplWidgets.dart';
import 'Compoenents.dart';

import 'HomeComp.dart';

class HomeWidget extends StatefulWidget {
  final activity Activity;

  const HomeWidget({Key? key, required this.Activity}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent(act: widget.Activity));
context.read<MembersBloc>().add(GetMemberByHighestRAnkEvent(isUpdated: true));

    context.read<GetTeamsBloc>().add(GetTeams(isPrivate: true));
    context.read<TaskVisibleBloc>().add(changePrivacyEvent(Privacy.Private));

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        drawer:HomeComponents. buildDrawer(context,mediaQuery),
        appBar: AppBar(title:HomeComponents. buildHeader(mediaQuery),


          centerTitle: true,
          toolbarHeight: mediaQuery.size.height / 10,
          backgroundColor: backgroundColored,
          surfaceTintColor: backgroundColored,
          foregroundColor: textColorBlack,
          shadowColor: textColorWhite,


        actions:  [
         Padding(
           padding: paddingSemetricHorizontal(),
           child: CalendarButton(color: textColorWhite, IconColor: textColorBlack,),
         )
          ],
        ),
        body: BlocConsumer<ActivityCubit, ActivityState>(
          listener: (context, state) {},
          builder: (context, state) {
            return

              SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.size.height / 38,
                        horizontal: mediaQuery.size.width / 20),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, ste) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [


                              Padding(
                                padding: paddingSemetricVertical(),
                                child: MyActivityButtons(),
                              ),
                              Padding(
                                padding: paddingSemetricHorizontal(h: 10),
                                child: buildBody(context, state.selectedActivity,
                                    mediaQuery),
                              ),


                              Padding(
                                padding: paddingSemetricHorizontal(h: 16),
                                child: HomeComponents.TeamsWidget(mediaQuery,context),
                              ),
                              MemberImpl.MemberWithHighestRanks(mediaQuery)
                            ],


                        );
                      },
                    ),
                  ),
                ),
              );
          },
        ),
      ),
    );
  }



}
