import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jci_app/core/route/app_router.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions/Listeners.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/stuff/Compoenents.dart';
import 'package:jci_app/features/Home/presentation/widgets/Home/HomeComp.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/objectif_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../MemberSection/presentation/widgets/achivements/ObjectifImpl.dart';
import '../../../../MemberSection/presentation/widgets/member/MemberImpl.dart';
import '../../../../intro/presentation/widgets.global.dart';
import '../../bloc/Activity/activity_cubit.dart';
import '../Implementations/ActivtysImplementations.dart';
import '../components/stuff/ActivitiOptionRow.dart';


class HomeWidget extends StatefulWidget {
  final activity Activity;

  const HomeWidget({Key? key, required this.Activity}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    context.read<MembersBloc>().add(GetUserProfileEvent(true));
    context.read<ObjectifBloc>().add(FetchTop3UserobjectifsEvent());
    context.read<GetTeamsBloc>().add(GetTeamsOfuser());
context.read<ParticpantsBloc>().add(LoadParticipantIdEvent());

    context.read<AcivityFBloc>().add(
        GetActivitiesOfMonthEvent(act: widget.Activity));
    /*context.read<MembersBloc>().add(
        const GetMemberByHighestRAnkEvent(isUpdated: true));
    context.read<AddDeleteUpdateBloc>().add(
        CheckPermissions(act: widget.Activity));

    context.read<GetTeamsBloc>().add(const GetTeams(isPrivate: true));
    context.read<TaskVisibleBloc>().add(const changePrivacyEvent(Privacy.Private));
*/
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        drawer: HomeComponents.buildDrawer(context, mediaQuery),

        appBar: AppBar(
          backgroundColor: ColorsApp.backgroundColored,
          leading: Builder(
            builder: (context) => IconButton(
              icon:
            Container(
              padding: paddingSemetricVerticalHorizontal(),
              decoration:
              BoxDecoration(
                  boxShadow: [
                    BoxShadow(offset: Offset(0, 5),color:ColorsApp.ThirdColor.withOpacity(0.2),spreadRadius: 1,blurRadius: 1 ),
                  ],
                  color: ColorsApp.textColorWhite
                  ,
                  borderRadius: BorderRadius.circular(10)
              ),
            child: Icon(Icons.menu_open)), // or your custom icon
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: HomeComponents.buildHeader(mediaQuery),






          actions: [

            const CalendarButton(
                color: textColorWhite, IconColor: textColorBlack,
            ),
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const SignoutEvent());
                context.replaceRoute(LoginRoute());
                context.read<PermissionsBloc>().add(ResetListEvent());
              },
              icon: Container(
                  padding: paddingSemetricVerticalHorizontal(),
                  decoration:
                BoxDecoration(
                    boxShadow: [
                      BoxShadow(offset: Offset(0, 5),color:ColorsApp.ThirdColor.withOpacity(0.2),spreadRadius: 1,blurRadius: 1 ),
                    ],
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
                  child: Icon(
                Icons.logout,
                color: ColorsApp.textColorWhite,
              )),
            ),


          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              context.replaceRoute(LoginRoute());

            }
            // TODO: implement listener}
          },
          child: BlocListener<AcivityFBloc, AcivityFState>(
            listener: (context, state) {
          Listeners.    ListentoJoinButton(state, context,widget.Activity.name);
              // TODO: implement listener
            },
            child: BlocConsumer<ActivityCubit, ActivityState>(
              listener: (context, state) {},
              builder: (context, state) {
                return

                  SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.size.height / 38,
                            horizontal: mediaQuery.size.width / 25),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, ste) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ObjectifsCarouselImpl(),
                                ActivityOptionsRow(),


                                  HomeComponents.TeamsWidget(
                                      mediaQuery, context),


                                Padding(
                                  padding: paddingSemetricVertical(),
                                  child: const MyActivityButtons(),
                                ),


                                BlocMonthlyWeeklyActivity(
                                    state.selectedActivity,
                                    mediaQuery),




                            //    MemberImpl.memberWithHighestRanks(mediaQuery)
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
        ),
      ),
    );
  }




}
