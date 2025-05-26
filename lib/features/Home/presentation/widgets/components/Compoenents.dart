import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:jci_app/core/app_theme.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Activity/ActivityDetailsComponents.dart';
//import 'package:jci_app/features/auth/presentation/bloc/Members/members_bloc.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../../core/config/env/Constants.dart';
import '../../../../../core/strings/app_strings.dart';

import '../../../../auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import '../../../../auth/presentation/widgets/Text.dart';
import '../../../domain/Dtos/ActivityParam.dart';
import '../../../domain/entities/Activity.dart';
import '../../../domain/enums/ParticipantWithEvents.dart';
import '../../bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import '../../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../bloc/Activity/activity_cubit.dart';

import '../../bloc/PageIndex/page_index_bloc.dart';
import '../Activity/ActivityImplWidgets.dart';
import '../Implementations/ActivtysImplementations.dart';
import '../buttons/PinnedButton.dart';
import 'ErrorDisplayMessage.dart';
import '../Activity/EventListWidget.dart';

import '../Functions/Functions.dart';

class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({super.key});

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  late String selectedValue = "Event".tr(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, ste) {
        return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
          builder: (context, state) {
            return Container(
                width: 170,
                height: 65,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<activity>(
                    style: PoppinsSemiBold(
                        21, textColorBlack, TextDecoration.none),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 200,
                      width: 170,
                      decoration: BoxDecoration(
                        color: textColorWhite,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                      ),
                      offset: Offset(-14, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: Radius.circular(14),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                    onMenuStateChange: (bool isMenuOpen) {
                      context.read<ToggleBooleanBloc>().add(ToggleBoolean());
                    },
                    iconStyleData: IconStyleData(
                        iconSize: 20,
                        icon: SvgPicture.string(
                            state.value ? Arrow_UP : Arrow_Down)),
                    value: ste.selectedActivity,
                    underline: Container(
                      height: 20,
                      color: Colors.transparent,
                    ),
                    onChanged: (newValue) {
                      context.read<ActivityCubit>().selectActivity(newValue!);
                      context
                          .read<AcivityFBloc>()
                          .add(GetAllActivitiesEvent(act: newValue));
                      context.read<PermissionsBloc>().add(
                              LoadPermissionOfMasterEvent(featuresId: [
                            Constants.MANAGE_EVENTS,
                            Constants.MANAGE_MEETINGS,
                            Constants.MANAGE_TRAININGS
                          ]));
                    },
                    items: <activity>[
                      activity.Events,
                      activity.Meetings,
                      activity.Trainings
                    ].map<DropdownMenuItem<activity>>((activity value) {
                      return DropdownMenuItem<activity>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(
                          value.name.tr(context),
                          style: PoppinsSemiBold(
                              18, textColorBlack, TextDecoration.none),
                        ),
                      );
                    }).toList(),
                  ),
                ));
          },
        );
      },
    );
  }
}

class SearchButton extends StatelessWidget {
  final Color color;
  final Color IconColor;
  final Function()? onPressed;
  const SearchButton(
      {super.key,
      required this.color,
      required this.IconColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 39,
      width: 49,
      child: IconButton(
        onPressed: () {
          onPressed!();
          // Navigator.pushNamed(context, Routes.search);
        },
        icon: Icon(
          Icons.search,
          color: IconColor,
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final Color color;
  final Color IconColor;
  final IconData icon;
  final Function()? onPressed;
  const AddButton(
      {super.key,
      required this.color,
      required this.IconColor,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 49,
      width: 49,
      child: IconButton(
        onPressed: () {
          onPressed!();
          // Navigator.pushNamed(context, Routes.search);
        },
        icon: Icon(
          icon,
          color: IconColor,
          size: 30,
        ),
      ),
    );
  }
}

class CalendarButton extends StatefulWidget {
  final Color color;
  final Color IconColor;

  const CalendarButton({
    super.key,
    required this.color,
    required this.IconColor,
  });

  @override
  State<CalendarButton> createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
              useSafeArea: true,
              showDragHandle: true,
              isScrollControlled: true,
              context: context,
              builder: (builder) => SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              BackButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                "Calendar".tr(context),
                                style: PoppinsSemiBold(
                                    20, textColorBlack, TextDecoration.none),
                              ),
                            ],
                          ),
                          Padding(
                            padding: paddingSemetricVertical(),
                            child: const MyActivityButtons(),
                          ),
                          SingleChildScrollView(child: ShowCalendarWidget()),
                        ],
                      ),
                    ),
                  ));

          // Navigator.pushNamed(context, Routes.search);
        },

        // Navigator.pushNamed(context, Routes.search);

        icon: Icon(
          Icons.calendar_month_rounded,
          color: widget.IconColor,
        ),
      ),
    );
  }
}

class MyActivityButtons extends StatelessWidget {
  const MyActivityButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActivityButton(context, activity.Events, mediaQuery),
          _buildActivityButton(context, activity.Meetings, mediaQuery),
          _buildActivityButton(context, activity.Trainings, mediaQuery),
        ],
      ),
    );
  }

  Widget _buildActivityButton(BuildContext context, activity act, mediaQuery) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        return Padding(
          padding: paddingSemetricHorizontal(),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: textColorBlack, width: 2.0),
              backgroundColor:
                  state.selectedActivity == act ? PrimaryColor : Colors.white,
              foregroundColor:
                  state.selectedActivity == act ? textColorWhite : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              // Handle button press for the specific activity
              _handleActivityButtonClick(context, act);
            },
            child: Text(
              act.toString().split('.').last.tr(context),
              style: PoppinBold(
                  mediaQuery.size.width / 30,
                  state.selectedActivity == act
                      ? textColorWhite
                      : textColorBlack,
                  TextDecoration.none),
            ),
          ),
        );
      },
    );
  }

  void _handleActivityButtonClick(BuildContext context, activity act) {
    context.read<ActivityCubit>().selectActivity(act);
    context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent(act: act));
    // context.read<ActivityOfweekBloc>().add(GetOfWeekActivitiesEvent(act: act));
    // Add logic to handle the button press for the specific activity
    // You can dispatch events to other blocs or perform any other actions here.
  }
}

Widget buildBody(BuildContext context, activity act, mediaQuery) {
  return BlocMonthlyWeeklyActivity(act, mediaQuery);
}

Widget buildActivityDetailsBody(
    BuildContext context, activity act, String id, int index) {
  return ActivityDetails(act, id, index);
}

Widget buildAllBody(BuildContext context, activity act) {
  return ALLActivities(act);
}

InputDecoration PollInput(String title,
    {bool iconExisted = false,
    Function()? AddOption,
    TextEditingController? optionController}) {
  return InputDecoration(
    border: border(PrimaryColor),
    labelText: title,
    errorStyle: PoppinsRegular(13.sp, Colors.red),
    labelStyle: PoppinsRegular(13.sp, ColorsApp.ThirdColor),
    enabledBorder: border(PrimaryColor),
    focusedBorder: border(PrimaryColor),
    errorBorder: border(Colors.red),
    focusedErrorBorder: border(Colors.red),
    suffixIcon: iconExisted
        ? IconButton(
            icon: const Icon(
              Icons.check_circle,
              color: ThirdColor,
              size: 20,
            ),
            onPressed: () {
              AddOption!();
            },
          )
        : null,
    prefixIcon: iconExisted
        ? IconButton(
            icon: const Icon(
              Icons.cancel,
              color: ThirdColor,
              size: 20,
            ),
            onPressed: () {
              optionController!.clear();
            },
          )
        : null,
  );
}

Widget MySearchBar(BuildContext context, activity Activity) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 50,
          child: TextField(
            style: PoppinsNorml(17, textColorBlack),
            onChanged: (value) {
              if (value.isEmpty) {
                context
                    .read<AcivityFBloc>()
                    .add(GetAllActivitiesEvent(act: Activity));
              }
              final param = activityParams(
                  act: null,
                  type: state.selectedSearchActivity,
                  Eventid: null,
                  name: value);
              context.read<AcivityFBloc>().add(GetActivitiesByName(param));
            },
            controller: TextEditingController()..text = '',
            enabled: true,
            decoration: InputDecoration(
              hintText: 'Search'.tr(context),
              hintStyle: PoppinsRegular(13, textColor),
              prefixIcon: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return ChangeactivityDialog(context, state);
                      });
                },
                icon: const Icon(Icons.filter_alt_outlined),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<ActivityCubit>().search(false);
                },
                icon: const Icon(Icons.cancel),
              ),
              border: border(PrimaryColor),
              focusedBorder: border(PrimaryColor),
            ),
          ),
        );
      },
    ),
  );
}

Widget ChangeactivityDialog(BuildContext context, ActivityState state) {
  return SizedBox(
    height: 400,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Filter by Activity Type'.tr(context),
            style: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),
          ),
        ),
        for (var item in activity.values.reversed)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CheckboxListTile(
              title: Text(
                item.name.tr(context),
                style: PoppinsRegular(17, textColorBlack),
              ),
              value: item == state.selectedSearchActivity,
              onChanged: (value) {
                context.read<ActivityCubit>().selectSearchActivity(item);
                context.pop();
              },
              activeColor: PrimaryColor,
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: PrimaryColor)),
              selected: item == state.selectedSearchActivity,
              checkboxShape: const CircleBorder(),
              selectedTileColor: PrimaryColor,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          )
      ],
    ),
  );
}

Widget ButtonComponent(
        {required List<Activity> Activities,
        required index,
        required double top,
        required double left,
        required MediaQueryData mediaQuery,
        required activity act}) =>
    BlocBuilder<AcivityFBloc, AcivityFState>(
      builder: (context, state) {
        return Positioned(
            top: top,
            left: left,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActivityDetailsComponent.FutureJoinButton(
                    state,
                    index,
                    Activities[index],
                    act,
                    mediaQuery,
                    mediaQuery.size.width / 2,
                    mediaQuery.devicePixelRatio * 5,
                    context),

              ],
            ));
      },
    );

Widget MonthWeekBuild(
        activity act, AcivityFState state, MediaQueryData mediaQuery) =>
    BlocBuilder<ParticpantsBloc, ParticpantsState>(
      builder: (context, ste) {
        if (ActivityAction.filterActivityByCurrentMonth(state.activitiesSearch)
                .isEmpty &&
            state.activitiesSearch.isEmpty) {
          return Align(
              alignment: AlignmentDirectional.center,
              heightFactor: 3,
              child: MessageDisplayWidget(
                message: "No ${act.name} for this month",
              ));
        } else if (ActivityAction.filterActivityByCurrentMonth(
                state.activitiesSearch)
            .isEmpty) {
          return WidgetMonthActivity(
              context, act, mediaQuery, state.activitiesSearch, "Previous");
        } else {
          return WidgetMonthActivity(
              context,
              act,
              mediaQuery,
              ActivityAction.filterActivityByCurrentMonth(
                  state.activitiesSearch),
              "Upcoming");
        }
      },
    );

Column WidgetMonthActivity(BuildContext context, activity act,
    MediaQueryData mediaQuery, List<Activity> acts, String text) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Align(
        alignment: AlignmentDirectional.topStart,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${text.tr(context)} ${act.name.tr(context)}",
              style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 6,
                  Colors.black, TextDecoration.none),
            ),
            InkWell(
              onTap: () {
                context.read<PageIndexBloc>().add(SetIndexEvent(index: 1));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: LinkedText(
                    text: "See more".tr(context),
                    size: mediaQuery.devicePixelRatio * 4.5),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: mediaQuery.size.height / 33, horizontal: 20),
        child: SizedBox(
            height: mediaQuery.size.height ,
            // adjust the height as needed
            child: ActivityOfMonthListWidget(
              Activities: acts,
              act: act,
            )),
      ),
    ],
  );
}
