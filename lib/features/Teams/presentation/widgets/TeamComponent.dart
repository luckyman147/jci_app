import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../Home/presentation/bloc/Activity/activity_cubit.dart';
import '../../../auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';
import 'funct.dart';

Widget TaskdropButton(mediaQuery) => BlocBuilder<ActivityCubit, ActivityState>(
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
              filter.toString().split('.').last,
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


    if (filter == TaskFilter.All) {
      debugPrint(state.tasks.toString());

      context.read<GetTaskBloc>().add(initTasks(state.tasks));

    } else if (filter == TaskFilter.Completed) {
      debugPrint(state.tasks.toString());
      context.read<GetTaskBloc>().add(initTasks((filterCompletedTasks(state.tasks))));

    }
    else if (filter == TaskFilter.Pending) {
      debugPrint(state.tasks.toString());

      context.read<GetTaskBloc>().add(initTasks((filterPendingTasks(state.tasks))));

    }

    // Add logic to handle the button press for the specific activity
    // You can dispatch events to other blocs or perform any other actions here.
  }
}
Widget actionTeamRow(
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
              "${text} Team",
              style: PoppinsRegular(
                  mediaQuery.devicePixelRatio * 8, textColorBlack),
            ),
          ),
        ],
      ),
    );