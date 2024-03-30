

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/services/TeamStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';


import 'package:jci_app/features/auth/presentation/widgets/Text.dart';


import '../../../../core/app_theme.dart';
import '../../../Teams/domain/entities/Team.dart';
import '../../../Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import '../../../Teams/presentation/widgets/TeamWidget.dart';
import '../../../auth/data/models/Member/AuthModel.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

import '../bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';


import 'Compoenents.dart';

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





    super.initState();
  }



  Future<MemberModel?> _loadMemberModel() async {
    return await Store.getModel();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return BlocConsumer<ActivityCubit, ActivityState>(
      listener: (context, state) {},
      builder: (context, state) {
        return

          RefreshIndicator(
              onRefresh: () {
                return refreshFun(context, state);
              },
              child:
              SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.size.height / 33,
                        horizontal: mediaQuery.size.width / 20),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, ste) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildHeader(mediaQuery),



                              TeamsWidget(mediaQuery),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: mediaQuery.size.height / 35),
                                child: MyActivityButtons(),
                              ),
                              buildBody(context, state.selectedActivity,
                                  mediaQuery)


                            ]

                        );
                      },
                    ),
                  ),
                ),
              ));
      },
    );
  }

  Widget buildTeamWidget(MediaQueryData mediaQuery, BuildContext context,List<Team> teams) {
    return teams.isNotEmpty? Column(
                              children: [
                                buildteam(mediaQuery, context),
                                SizedBox(

                                    height: mediaQuery.size.height / 6,

                                    child: TeamHomeWidget(teams: teams),
                                )],
                            ):SizedBox();
  }

  Widget buildteam(MediaQueryData mediaQuery, BuildContext context) {
    return Padding(
      padding:paddingSemetricVertical(),
      child: Row(
                                children: [
                                  Text("My Tasks", style: PoppinsSemiBold(
                                      mediaQuery.devicePixelRatio*6, Colors.black,
                                      TextDecoration.none),),
                                  const Spacer(), InkWell(
                                    onTap: () {
                                      context.read<PageIndexBloc>().add(SetIndexEvent(index: 2));
                                      context.read<TaskVisibleBloc>().add(changePrivacyEvent(Privacy.Private));

                                    },
                                    child: Text("View All", style: PoppinsSemiBold(
                                        mediaQuery.devicePixelRatio*5, PrimaryColor,TextDecoration.underline),),
                                  ),
                                ],

                              ),
    );
  }

  Row buildHeader(MediaQueryData mediaQuery) {
    return Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                buildFutureBuilder(mediaQuery),
                               const Row(
                                  children: [
                                    CalendarButton(color: BackWidgetColor,
                                      IconColor: textColorBlack,),
                                    const SearchButton(color: BackWidgetColor,
                                      IconColor: textColorBlack,),
                                  ],
                                ),

                              ],
                            );
  }









  Future<void> refreshFun(BuildContext context, ActivityState state) {
    context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent(act: state.selectedActivity));
    context.read<ActivityOfweekBloc>().add(GetOfWeekActivitiesEvent(act: state.selectedActivity));

    return Future.value(true);


  }

  FutureBuilder<MemberModel?> buildFutureBuilder(MediaQueryData mediaQuery) {
    return FutureBuilder <MemberModel?>(
                          future:  _loadMemberModel(),
                          builder: (context,snap)  {
                            print("Data: ${snap.data}");
                            if (snap.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snap.hasError) {
                              print("Error: ${snap.error}");

                            }
                             if (snap.hasData && snap.data!=null && snap.data!.firstName!.isNotEmpty!=null){ return  Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Hello, ", style: PoppinsRegular(
                                    mediaQuery.devicePixelRatio*6, Colors.black),),
                                Text(snap.data!.firstName, style: PoppinsSemiBold(
                                    mediaQuery.devicePixelRatio*7, Colors.black,
                                    TextDecoration.none),),

                              ],


                            );}
                             else{
                               debugPrint("dddddd${snap.hasData}");
                             return Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Text("Hello, ", style: PoppinsRegular(
                                     mediaQuery.devicePixelRatio*10, Colors.black),),
                                 Text("There", style: PoppinsSemiBold(
                                     mediaQuery.devicePixelRatio*11, Colors.black,
                                     TextDecoration.none),),

                               ],


                             );
                          }}
                        );
  }

  Widget TeamsWidget(MediaQueryData mediaQuery)=>FutureBuilder<List<Team>>(
    future: fetchData(), // Call the function that returns a Future
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Display a loading indicator while waiting for the Future to complete
        return LoadingWidget();
      } else if (snapshot.hasError) {
        // Display an error message if the Future throws an error
        return SizedBox();
      } else {

        // Display the data from the Future
        return buildTeamWidget(mediaQuery, context, snapshot.data!);
      }
    },
  );
  Future<List<Team>> fetchData() async {
    final teams=await TeamStore.getCachedTeams(CacheStatus.Private);
    if (teams.isEmpty) {

      context.read<GetTeamsBloc>().add(GetTeams(isPrivate: true));

    }

    return teams;
  }
}
