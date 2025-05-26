import 'package:go_router/go_router.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions/Listeners.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/Compoenents.dart';
import 'package:jci_app/features/Home/presentation/widgets/Home/HomeComp.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../MemberSection/presentation/widgets/member/MemberImpl.dart';
import '../../../../intro/presentation/widgets.global.dart';
import '../../bloc/Activity/activity_cubit.dart';


class HomeWidget extends StatefulWidget {
  final activity Activity;

  const HomeWidget({Key? key, required this.Activity}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
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

          title: HomeComponents.buildHeader(mediaQuery),


          centerTitle: true,
          toolbarHeight: mediaQuery.size.height / 10,
          backgroundColor: backgroundColored,
          surfaceTintColor: backgroundColored,
          foregroundColor: textColorBlack,
          shadowColor: textColorWhite,


          actions: [
            Padding(
              padding: paddingSemetricHorizontal(),
              child: const CalendarButton(
                color: textColorWhite, IconColor: textColorBlack,),
            ),
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const SignoutEvent());
                context.go('/login');
                context.read<PermissionsBloc>().add(ResetListEvent());
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),


          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              context.go('/login');
              context.go('/login');
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
                            horizontal: mediaQuery.size.width / 20),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, ste) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: paddingSemetricVertical(),
                                  child: const MyActivityButtons(),
                                ),


                                buildBody(
                                    context, state.selectedActivity,
                                    mediaQuery),


                                Padding(
                                  padding: paddingSemetricHorizontal(h: 16),
                                  child:


                                  HomeComponents.TeamsWidget(
                                      mediaQuery, context),
                                )

                                ,
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
