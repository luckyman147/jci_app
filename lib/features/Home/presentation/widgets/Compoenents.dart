
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';


import 'package:jci_app/core/app_theme.dart';


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/domain/usercases/ActivityUseCases.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/ActivityDetailsComponents.dart';
//import 'package:jci_app/features/auth/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../../../../core/strings/app_strings.dart';

import '../../../auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import '../../../auth/presentation/widgets/Text.dart';
import '../../domain/entities/Activity.dart';
import '../bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';


import '../bloc/PageIndex/page_index_bloc.dart';
import 'ActivityImplWidgets.dart';
import 'ErrorDisplayMessage.dart';
import 'EventListWidget.dart';
import 'EventOfweek.dart';
import 'Functions.dart';
import 'SearchWidget.dart';


class MyDropdownButton extends StatefulWidget {
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  late String selectedValue="Event".tr(context);
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

            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(


              borderRadius: BorderRadius.circular(16.0),

            ),
            child: DropdownButtonHideUnderline(


              child: DropdownButton2<activity>(

                style: PoppinsSemiBold(21, textColorBlack, TextDecoration.none),

                dropdownStyleData:const  DropdownStyleData(
                  maxHeight: 200,

                  width: 170,
                  decoration: BoxDecoration(
                    color: textColorWhite,
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
                iconStyleData:  IconStyleData(iconSize: 20,icon:SvgPicture.string(state.value?Arrow_UP:Arrow_Down)),


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
                    child: Text(value.name.tr(context),style: PoppinsSemiBold(MediaQuery.of(context).devicePixelRatio*5, textColorBlack, TextDecoration.none),),

                  );
                }).toList(),

              ),
            )
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
      height: 49,
      width: 49,
      child: IconButton(

        onPressed: () {
      onPressed!();
          // Navigator.pushNamed(context, Routes.search);
        },
        icon: Icon(icon,color: IconColor,size: 30,),
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
      height: 60,
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
          padding:paddingSemetricHorizontal(),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: state.selectedActivity == act
                  ? PrimaryColor
                  : Colors.white,
              foregroundColor: state.selectedActivity == act
                  ? textColorWhite
                  : Colors.black,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: textColorBlack, width:1.0),
                borderRadius: BorderRadius.circular(10.0),
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
   // context.read<ActivityOfweekBloc>().add(GetOfWeekActivitiesEvent(act: act));
    // Add logic to handle the button press for the specific activity
    // You can dispatch events to other blocs or perform any other actions here.
  }
}
class MyCategoryButtons extends StatelessWidget {
  final activity act;
  final categories = Category.values.where((category) => [Category.Comity, Category.Officiel,Category.Other].contains(category)).toList()..shuffle();
   MyCategoryButtons({super.key, required this.act});
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(

      child:



      buildCategories(Category.values, context, mediaQuery)
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, Category cat, mediaQuery) {
    return BlocBuilder<FormzBloc, FormzState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width / 40),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
              cat.toString().split('.').last,
              style: PoppinBold(
                  mediaQuery.size.width / 22,
                  textColorBlack,
                  TextDecoration.none),
                        ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.category == cat
                        ? PrimaryColor
                        : Colors.white,
                    foregroundColor: state.category == cat
                        ? textColorWhite
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),

                  onPressed: (){
                _handleCAtegoryButtonClick(context, cat);
              }, child: Text('Select',style: PoppinBold(
                  mediaQuery.size.width / 22,
                  state.category == cat
                      ? textColorWhite
                      : textColorBlack,
                  TextDecoration.none),))
            ],
          ),
        );
      },
    );
  }

  void _handleCAtegoryButtonClick(
      BuildContext context, Category cat) {
    context.read<FormzBloc>().add(CategoryChanged(category: cat));
    context.pop();

    // Add logic to handle the button press for the specific activity
    // You can dispatch events to other blocs or perform any other actions here.
  }
  Widget buildCategories(List<Category> categories, BuildContext context, MediaQueryData mediaQuery) {
   return bottomCategorySheet(context, mediaQuery, categories);

  }
  Widget bottomCategorySheet(BuildContext context, MediaQueryData mediaQuery,
      List<Category> cat


      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0,),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return BlocBuilder<FormzBloc, FormzState>(
                builder: (context, state) {
                  return CategoryBottomSheet(mediaQuery,cat);
                },
              );
            },
          );
        },
        child:Container(

            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: ThirdColor,
                width: 3,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0,),
              child: BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child:
                Text("${state.category.name}",style: PoppinsNorml(18, textColorBlack),),
              );
  },
),
            )),
      ),
    );}



  Widget CategoryDetails(List<Category> category,mediaQuery)=>ListView.separated(
    scrollDirection: Axis.vertical,

    itemCount: category.length,
    itemBuilder: (context, index) {
      return _buildCategoryButton(context, category[index], mediaQuery);
    },
    separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,);  },

  );
  Widget CategoryBottomSheet(
      mediaQuery, List<Category> categories


      )=>SizedBox(
    height: mediaQuery.size.height / .9,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10,
      ),
      child: BlocBuilder<FormzBloc, FormzState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Choose A category".tr(context),
                style: PoppinsSemiBold(
                  mediaQuery.devicePixelRatio * 6,
                  PrimaryColor,
                  TextDecoration.none,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10,
                  ),
                  child: TextField(

                    style: PoppinsRegular(
                      mediaQuery.devicePixelRatio * 6,
                      textColorBlack,
                    ),
                    onChanged: (value) {

                      context.read<AcivityFBloc>().add(SearchTextChanged(value) );


                      //    .add(SearchMembersEvent(value));
                    },
                    decoration: InputDecoration(

                      prefixIcon: Icon(
                        Icons.search,
                        color: textColor,
                      ),
                      hintText: "Search for a Category".tr(context),
                      hintStyle: PoppinsRegular(
                        mediaQuery.devicePixelRatio * 6,
                        textColor,

                      ),

                      focusedBorder: border(PrimaryColor),
                      enabledBorder: border(ThirdColor),
                      errorBorder: border(Colors.red),
                      focusedErrorBorder: border(Colors.red),
                      errorStyle: ErrorStyle(18, Colors.red),

                    ),
                  )

              ),



              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                      height: mediaQuery.size.height/3 ,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:BlocBuilder<AcivityFBloc, AcivityFState>(
  builder: (context, state) {
    if (state is SearchLoading){
      return LoadingWidget();
    }
    if(state is SearchLoaded){
      return CategoryDetails (state.categories,mediaQuery);
    }
    else if  (state is SearchError){
      return MessageDisplayWidget(message: state.message,);
    }
    else{
      return CategoryDetails (categories,mediaQuery);
    }

  },
),
                      )),
                ),
              )

            ],
          );
        },
      ),
    ),
  );

}


Widget buildBody(BuildContext context,activity act,mediaQuery) {

return BlocMonthlyWeeklyActivity(act, mediaQuery);
}
Widget buildActivityDetailsBody(BuildContext context,activity act,String id,int index) {
return ActivityDetails(act,id,index);
}


Widget buildAllBody(BuildContext context,activity act) {

return ALLActivities(act);
}



class ParticipateButton extends StatefulWidget {
  final Activity acti;
final double textSize;
final double containerWidth;
  final activity act;
  final bool isPartFromState;
  final int index;

  const ParticipateButton({
    Key? key,
    required this.acti,
    required this.index, required this.isPartFromState, required this.act, required this.textSize, required this.containerWidth,
  }) : super(key: key);

  @override
  _ParticipateButtonState createState() => _ParticipateButtonState();
}

class _ParticipateButtonState extends State<ParticipateButton> {




  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParticpantsBloc, ParticpantsState>(
      builder: (context, state) {


        return InkWell(
          onTap: () {
            final result=activityParams(act:  widget.acti, type: widget.act, id:  widget.acti.id);
            if (widget.isPartFromState) {
              context.read<ParticpantsBloc>().add(RemoveParticipantEvent( index: widget.index, act: result));
            } else {

              context.read<ParticpantsBloc>().add(AddParticipantEvent( index: widget.index, act:result));
            }
          },
          child: Container(
            width:widget.containerWidth,
            decoration: BoxDecoration(
              color: widget.isPartFromState ? PrimaryColor : BackWidgetColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon( widget.isPartFromState ? Icons.check : Icons.star,
                      color:  widget.isPartFromState ? textColorWhite : textColorBlack),
                  Text(
                    widget.isPartFromState ? "Interested".tr(context) : "Join".tr(context),
                    style: PoppinsSemiBold(widget.textSize,
                        widget.isPartFromState ? textColorWhite : textColorBlack,
                        TextDecoration.none),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget ButtonComponent({required List<Activity> Activities,required index,required double top,required double left,required MediaQueryData mediaQuery,required activity act})=>  BlocBuilder<ParticpantsBloc, ParticpantsState>(
  builder: (context, state) {
    return Positioned(
        top: top,
        left: left,


        child:
  ActivityDetailsComponent.FutureJoinButton(state, index, Activities[index], act, mediaQuery, mediaQuery.size.width/3.2, mediaQuery.devicePixelRatio*3.7)

    );
  },
);

Widget MonthWeekBuild (activity act,ActivityLoadedMonthState state,MediaQueryData mediaQuery)=>  BlocBuilder<ParticpantsBloc, ParticpantsState>(
  builder: (context, ste) {
    if  ((ste.isParticipantAdded.length==state.activitys.length&&  (ste .status==ParticpantsStatus.success || ste .status==ParticpantsStatus.changed )) ){
      if (ActivityAction.filterActivityByCurrentMonth(state.activitys).isEmpty){
        return Align(
            alignment: AlignmentDirectional.center,
            heightFactor: 3,
            child: MessageDisplayWidget(message: "No ${act.name} for this month",));
      }
      else{
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${"Upcoming".tr(context)} ${act.name}", style: PoppinsSemiBold(
                      mediaQuery.devicePixelRatio*6, Colors.black,
                      TextDecoration.none),),
                  InkWell(
                    onTap: (){
                      context.read<PageIndexBloc>().add (SetIndexEvent(index: 1));



                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: LinkedText(text: "See more".tr(context), size: mediaQuery.size.width/23),
                    ),
                  )
                ],
              ),
            ),

            Padding(

              padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 33 , horizontal: mediaQuery.size.width / 33),
              child: SizedBox(
                  height: mediaQuery.size.height * 0.4,
                  // adjust the height as needed
                  child:

                  ActivityOfMonthListWidget( Activities: ActivityAction.filterActivityByCurrentMonth(state.activitys,), act: act,)


              ),
            ),
            SizedBox(height: 10,),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(" This Weekend".tr(context), style: PoppinBold(
                  mediaQuery.size.width / 15, Colors.black,
                  TextDecoration.none),),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: mediaQuery.size.height / 33, horizontal: 6),

              child: SizedBox(
                  height: mediaQuery.size.height * 0.4, // adjust the height as needed
                  child:
    ActivityAction.  filterObjectsForCurrentWeekend(state.activitys).isNotEmpty?

                  ActivityOfWeekListWidget(activity:ActivityAction. filterObjectsForCurrentWeekend(state.activitys),):
                  MessageDisplayWidget(message: "No activity this weekend".tr(context),)

              ),
            ),
          ],
        );}}
    else {
      context.read<ParticpantsBloc>().add(initstateList(act: ActivityAction.mapObjects(state.activitys)));

      return LoadingWidget();
    }
  },
);
