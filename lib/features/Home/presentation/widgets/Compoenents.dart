
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';


import 'package:jci_app/core/app_theme.dart';


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';

import '../../../../core/strings/app_strings.dart';

import '../../../auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';


import 'ActivityImplWidgets.dart';


class MyDropdownButton extends StatefulWidget {
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  String selectedValue = 'Event';


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, ste) {
    return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
      builder: (context, state) {
        return Align(
          alignment: AlignmentDirectional.topStart,
          child: Container(
              width: 200,
              height: 65,
    
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
    
    
                borderRadius: BorderRadius.circular(16.0),
    
              ),
              child: DropdownButtonHideUnderline(
    
    
                child: DropdownButton2<activity>(

                  style: PoppinsSemiBold(21, textColorBlack, TextDecoration.none),
    
                  dropdownStyleData:const  DropdownStyleData(

                    maxHeight: 200,
    
                    width: 200,
                    decoration: BoxDecoration(
                      color: backgroundColored,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
    
    
                    ),
                    offset: const Offset(-14, 0),
                    scrollbarTheme: ScrollbarThemeData(
    
                      radius: const Radius.circular(14),
    
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                  onMenuStateChange: (bool isMenuOpen) {
    
                    context.read<ToggleBooleanBloc>().add(ToggleBoolean());
    
                  },
                  iconStyleData:  IconStyleData(iconSize: 30,icon:SvgPicture.string(state.value?Arrow_UP:Arrow_Down)),
    
                  isDense: true,
                  value:ste.selectedActivity,
    
    
    
    
                  underline: Container(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  onChanged: (newValue) {
    

    

                    context.read<ActivityCubit>().selectActivity(newValue!);
                    context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: newValue));


                  },
                  items: <activity>[activity.Events, activity.Meetings, activity.Trainings ]
                      .map<DropdownMenuItem<activity>>((activity value) {
                    return DropdownMenuItem<activity>(
                      alignment: AlignmentDirectional.centerStart,
                      value: value,
                      child: Text(value.name),
    
                    );
                  }).toList(),
    
                ),
              )
          ),
        );
      },
    );
  },
);
  }
}
class SearchButton extends StatelessWidget {
  final Color color;
  final Color IconColor ;
  const SearchButton({super.key, required this.color, required this.IconColor});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 39,
      width: 49,
      child: IconButton(

        onPressed: () {
          context.go('/search');
          // Navigator.pushNamed(context, Routes.search);
        },
        icon: Icon(Icons.search,color: IconColor,),
      ),
    );
  }
}class AddButton extends StatelessWidget {
  final Color color;
  final Color IconColor ;
  final IconData icon;
  final Function()? onPressed;
  const AddButton({super.key, required this.color, required this.IconColor,
    required this.icon, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: 49,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: IconButton(

          onPressed: () {
        onPressed!();
            // Navigator.pushNamed(context, Routes.search);
          },
          icon: Icon(icon,color: IconColor,size: 33),
        ),
      ),
    );
  }
}
class CalendarButton extends StatelessWidget {
  final Color color;
  final Color IconColor ;
  const CalendarButton({super.key, required this.color, required this.IconColor});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 49,
      child: IconButton(

        onPressed: () {
          context.go('/search');
          // Navigator.pushNamed(context, Routes.search);
        },
        icon: Icon(Icons.calendar_month_rounded,color: IconColor,),
      ),
    );
  }
}

class MyActivityButtons extends StatelessWidget {
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

  Widget _buildActivityButton(
      BuildContext context, activity act, mediaQuery) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width / 50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: state.selectedActivity == act
                  ? PrimaryColor
                  : Colors.white,
              foregroundColor: state.selectedActivity == act
                  ? textColorWhite
                  : Colors.black,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            onPressed: () {
              // Handle button press for the specific activity
              _handleActivityButtonClick(context, act);
            },
            child: Text(
              act.toString().split('.').last,
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

  void _handleActivityButtonClick(
      BuildContext context, activity act) {
    context.read<ActivityCubit>().selectActivity(act);
    context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent( act: act));
    context.read<ActivityOfweekBloc>().add(GetOfWeekActivitiesEvent(act: act));
    // Add logic to handle the button press for the specific activity
    // You can dispatch events to other blocs or perform any other actions here.
  }
}
class MyCategoryButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: buildCategories(Category.values, context, mediaQuery)
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, Category cat, mediaQuery) {
    return BlocBuilder<FormzBloc, FormzState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width / 50),
          child: Chip(
          shape:    RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
                  ),
            backgroundColor:state.category == cat
                ? PrimaryColor
                : Colors.white,

            label: GestureDetector(

              onTap: (){
                _handleCAtegoryButtonClick(context, cat);
              },
              child: Text(
              cat.toString().split('.').last,
              style: PoppinBold(
                  mediaQuery.size.width / 30,
                  state.category == cat
                      ? textColorWhite
                      : textColorBlack,
                  TextDecoration.none),
                        ),
            ),)
        );
      },
    );
  }

  void _handleCAtegoryButtonClick(
      BuildContext context, Category cat) {
    context.read<FormzBloc>().add(CategoryChanged(category: cat));

    // Add logic to handle the button press for the specific activity
    // You can dispatch events to other blocs or perform any other actions here.
  }
  Widget buildCategories(List<Category> categories, BuildContext context, MediaQueryData mediaQuery) {
    List<Widget> rows = [];

    for (int i = 0; i < categories.length; i +=3) {
      List<Widget> rowChildren = [];

      // Build buttons for the current row
      for (int j = i; j < i + 3 && j < categories.length; j++) {
        rowChildren.add(_buildCategoryButton(context, categories[j], mediaQuery));
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: rowChildren,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }


}


Widget buildBody(BuildContext context,activity act) {

return BlocMonthlyActivity(act);
}
Widget buildActivityDetailsBody(BuildContext context,activity act,String id) {
return ActivityDetails(act,id);
}

Widget buildWeekBody(BuildContext context,activity act) {
return BlocWeekActivity(act);
}
Widget buildAllBody(BuildContext context,activity act) {
return ALLActivities(act);
}



