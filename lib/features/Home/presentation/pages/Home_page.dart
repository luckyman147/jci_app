import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/pages/ActivityPage.dart';
import 'package:jci_app/features/Home/presentation/widgets/Home/HomeWidget.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/user/memberProfilPage.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/screens/AllTeamsScreen.dart';
import 'package:jci_app/features/auth/presentation/bloc/Permissions/permissions_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/config/services/MemberStore.dart';
import '../../../../core/util/ObjectifProgressTopSnackBar.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/bloc/memberPermissions/member_permission_bloc.dart';
import '../bloc/PageIndex/page_index_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {

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
    return BlocBuilder<PermissionsMemberBloc, PermissionsState>(
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

  List<BottomNavigationBarItem> _getBottomNavItems(
      PageIndexState state, BuildContext context, PermissionsState perm) {
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
              borderRadius: BorderRadius.circular(60), // Rounded corners
            ),
            child: const Icon(
              Icons.add, // Custom icon for the button
              color: ColorsApp.textColorWhite, // White icon when selected
              size: 35,
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
        icon: _buildIconWithBorder(Icons.person, state.index == 4, null),
        label: "Profile".tr(context),
      ),
    ];
  }

  Widget _buildIconWithBorder(
      IconData? icon, bool isSelected, Widget? svgPicture) {
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
      context.read<GetTeamsBloc>().add(const GetTeams(isPrivate: true));
    } else if (index == 4) {
      context.read<MembersBloc>().add(const GetUserProfileEvent(true));
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Bottom Sheet Content",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }
}
