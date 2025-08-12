import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/route/app_router.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/pages/ActivityPage.dart';
import 'package:jci_app/features/Home/presentation/widgets/Home/HomeWidget.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/user/memberProfilPage.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/screens/AllTeamsScreen.dart';
import 'package:logger/logger.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/config/services/MemberStore.dart';
import '../../../../core/util/ObjectifProgressTopSnackBar.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/bloc/memberPermissions/member_permission_bloc.dart';
import '../../../MemberSection/presentation/bloc/objectifs/objectif_bloc.dart';
import '../../../Teams/data/models/TeamModel.dart';
import '../../../Teams/domain/entities/Team/Team.dart';
import '../bloc/PageIndex/page_index_bloc.dart';
import '../widgets/Activity/ActivityDetailsComponents.dart';
import '../widgets/Functions/ActivityFunctions.dart';
import '../widgets/components/stuff/CreateOptionButton.dart';
@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<PermissionsBloc>().add(LoadPermissionOfMasterEvent(featuresId: [

      Constants.MANAGE_PROJECTS,
      Constants.MANAGE_EVENTS,
      Constants.MANAGE_OBJECTIFS,
      Constants.MANAGE_TEAMS,

      Constants.MANAGE_MEETINGS,Constants.MANAGE_TRAININGS]));

    context.read<MembersBloc>().add(GetUserProfileEvent(false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<UserObjectifProgressCubit, UserObjectifProgressState>(
      listener: (context, objState) {
        Logger().wtf(objState.progresStatus);
        TopSnackbar.show(objState.userProgresUpdates, context);
      },
      builder: (context, objState) {
        return BlocBuilder<PageIndexBloc, PageIndexState>(
          builder: (context, pageIndexState) {
            return BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, activityState) {
                return _getPageForIndex(pageIndexState.index, activityState);
              },
            );
          },
        );
      },
    );
  }

  Widget _getPageForIndex(int index, ActivityState activityState) {
    switch (index) {
      case 0:
        return HomeWidget(Activity: activityState.selectedActivity);
      case 1:
        return ActivityPage(Activity: activityState.selectedActivity);
      case 3:
        return const AllTeamsScreen();
      case 4:
        return const MemberSectionPage(id: 'id');
      default:
        return HomeWidget(Activity: activityState.selectedActivity);
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<PermissionsBloc, PermissionsState>(
      builder: (context, permState) {
        return BlocBuilder<PageIndexBloc, PageIndexState>(
          builder: (context, pageIndexState) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
              selectedItemColor: PrimaryColor,
              selectedLabelStyle: PoppinsRegular(15, PrimaryColor),
              unselectedItemColor: ThirdColor,
              currentIndex: pageIndexState.index,
              onTap: (index) => _onBottomNavItemTapped(index, context),
              items: _getBottomNavItems(pageIndexState, context, permState),
            );
          },
        );
      },
    );
  }

  List<BottomNavigationBarItem> _getBottomNavItems(PageIndexState state,
      BuildContext context, PermissionsState perm) {
    return [
      BottomNavigationBarItem(
        icon: _buildIconWithBorder(Icons.home, state.index == 0, null),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithBorder(
          null,
          state.index == 1,
          SvgPicture.string(
            EventIcon,
            color: state.index == 1 ? PrimaryColor : ThirdColor,
            height: 22,
            width: 22,
          ),
        ),
        label: "Activities".tr(context),
      ),
      // Custom button at index 2 to show a bottom sheet
      BottomNavigationBarItem(
        icon: GestureDetector(
          onTap: () {
            _showBottomSheet(context); // Show the bottom sheet
          },
          child: Container(
            decoration: BoxDecoration(
              color: PrimaryColor, // Fill with PrimaryColor when selected
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: const Icon(
              Icons.add, // Custom icon for the button
              color: ColorsApp.textColorWhite, // White icon when selected
              size:40,
            ),
          ),
        ),
        label: "", // No label for the custom button
      ),
      BottomNavigationBarItem(
        icon: _buildIconWithBorder(
          null,
          state.index == 3,
          SvgPicture.string(
            TeamsIcon,
            color: state.index == 3 ? PrimaryColor : ThirdColor,
            height: 23,
            width: 23,
          ),
        ),
        label: "Teams".tr(context),
      ),
      BottomNavigationBarItem(
        icon:

        BlocSelector<MembersBloc, MembersState, MembersState>(
          selector: (state) => state,
          builder: (context, states) {
            if (states.userStatus == UserStatus.Loading) {
              return CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(images.jci),
                backgroundColor: Colors.transparent,
              );
            }
            else if (states.user == null) {
              return _buildIconWithBorder(Icons.person, state.index == 4, null);
            } else if (states.user!.Images.isEmpty) {
              return CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(images.jci),
                backgroundColor: Colors.transparent,
              );
            } else {
              return CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(states.user!.Images[0]),
                backgroundColor: Colors.transparent,
              );
            }
          },
        ), label: "Profile".tr(context),
      ),
    ];
  }

  Widget _buildIconWithBorder(IconData? icon, bool isSelected,
      Widget? svgPicture) {
    return Container(
      width: 30.w,
      padding: const EdgeInsets.only(top: 8), // Add padding to avoid overlap
      decoration: BoxDecoration(
        border: isSelected
            ? const Border(
          top: BorderSide(
            color: PrimaryColor, // Top border color
            width: 3, // Border width
          ),
        )
            : null, // No border for unselected items
      ),
      child: icon != null
          ? Icon(
        icon,
        color: isSelected ? PrimaryColor : ThirdColor,
        size: 26,
      )
          : svgPicture, // Use the provided icon (Icon or SvgPicture)
    );
  }

  void _onBottomNavItemTapped(int index, BuildContext context) {
    if (index == 2) {
      _showBottomSheet(context); // Show the bottom sheet for index 2
      return; // Do not change the page index
    }
    context.read<PageIndexBloc>().add(SetIndexEvent(index: index));

    if (index == 0) {
      //    context.read<GetTeamsBloc>().add(const GetTeams(isPrivate: true));
    } else if (index == 4) {
      context.read<MembersBloc>().add(const GetUserProfileEvent(true));
    }
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width ,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create",
                style: PoppinBold(17, ColorsApp.textColorBlack, TextDecoration.none),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3,
                physics: const NeverScrollableScrollPhysics(),
                children: [
            CreateOptionButton(
                    label: "Create an Event",
                    color: Colors.blue,
                    onTap: () {
                      ActivityFunctions.   NavigateActivity(context,activity.Events);                      // Navigate to Create Event
                    }, permissionName: Constants.MANAGE_EVENTS,
                  ),
                  CreateOptionButton(
                    label: "Create a Meeting",
                    color: Colors.orange,
                    onTap: () {
                      ActivityFunctions.  NavigateActivity(context,activity.Meetings);
                      // Navigate to Create Meeting
                    }, permissionName: Constants.MANAGE_MEETINGS,
                  ),
                  CreateOptionButton(
                    label: "Create a Training",
                    color: Colors.green,
                    onTap: () {

                      ActivityFunctions.  NavigateActivity(context,activity.Trainings);
                      // Navigate to Create Training
                    }, permissionName: Constants.MANAGE_TRAININGS,
                  ),
                  CreateOptionButton(
                    label: "Create a Team",
                    color: Colors.purple,
                    onTap: () {
                      context.pushRoute(CreateTeamRoute(team: TeamModel.empty()));

                      // Navigate to Create Team
                    }, permissionName: Constants.MANAGE_TEAMS,
                  ),
                  CreateOptionButton(
                    label: "Create a Project",
                    color: Colors.teal,
                    permissionName:  Constants.MANAGE_PROJECTS,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to Create Project
                    },
                  ),
                  CreateOptionButton(
                    permissionName: Constants.MANAGE_OBJECTIFS,
                    label: "Create an Objective",
                    color: Colors.red,
                    onTap: () {
                      context.pushRoute(
                        ObjectifformPageRoute(
                          MemberId: context.read<MembersBloc>().state.user?.id??"",
                          event:  ObjectiveEvent.Create,
                          // or null
                        ),
                      );
                      // Navigate to Create Objective
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }



}
